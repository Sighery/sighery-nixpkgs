{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.syncthing.relay;

  dataDirectory = "/var/lib/syncthing-relay";

  relayOptions = [
    "--keys=${dataDirectory}"
    "--listen=${cfg.listenAddress}:${toString cfg.port}"
    "--provided-by=${escapeShellArg cfg.providedBy}"
  ]
  ++ optional (cfg.enableStatusSrv == true) "--status-srv=${cfg.statusListenAddress}:${toString cfg.statusPort}"
  ++ optional (cfg.enableStatusSrv == false) "--status-srv="
  ++ optional (cfg.pools != null) "--pools=${escapeShellArg (concatStringsSep "," cfg.pools)}"
  ++ optional (cfg.globalRateBps != null) "--global-rate=${toString cfg.globalRateBps}"
  ++ optional (cfg.perSessionRateBps != null) "--per-session-rate=${toString cfg.perSessionRateBps}"
  ++ cfg.extraOptions;

  strelaysrvWrapper = pkgs.writers.writeBash "strelaysrv-wrapper" ''
    TOKEN=$(cat "$CREDENTIALS_DIRECTORY/relay_token")
    ${pkgs.syncthing-relay}/bin/strelaysrv ${concatStringsSep " " relayOptions} --token="$TOKEN"
  '';
in
{
  disabledModules = [ "services/networking/syncthing-relay.nix" ];

  ###### interface

  options.services.syncthing.relay = {
    enable = mkEnableOption "Syncthing relay service";

    cert = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Path to the `cert.pem` file, which will be copied into `dataDirectory`
      '';
    };

    key = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Path to the `key.pem` file, which will be copied into `dataDirectory`
      '';
    };

    listenAddress = mkOption {
      type = types.str;
      default = "";
      example = "1.2.3.4";
      description = ''
        Address to listen on for relay traffic.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 22067;
      description = ''
        Port to listen on for relay traffic. This port should be added to
        `networking.firewall.allowedTCPPorts`.
      '';
    };

    statusListenAddress = mkOption {
      type = types.str;
      default = "";
      example = "1.2.3.4";
      description = ''
        Address to listen on for serving the relay status API.
      '';
    };

    statusPort = mkOption {
      type = types.port;
      default = 22070;
      description = ''
        Port to listen on for serving the relay status API. This port should be
        added to `networking.firewall.allowedTCPPorts`.
      '';
    };

    enableStatusSrv = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether the relay status API is enabled. When using a private relay,
        this might be unnecessary.
      '';
    };

    pools = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = ''
        Relay pools to join. If null, uses the default global pool.
      '';
    };

    token = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Path to the file containing the token.
      '';
    };

    providedBy = mkOption {
      type = types.str;
      default = "";
      description = ''
        Human-readable description of the provider of the relay (you).
      '';
    };

    globalRateBps = mkOption {
      type = types.nullOr types.ints.positive;
      default = null;
      description = ''
        Global bandwidth rate limit in bytes per second.
      '';
    };

    perSessionRateBps = mkOption {
      type = types.nullOr types.ints.positive;
      default = null;
      description = ''
        Per session bandwidth rate limit in bytes per second.
      '';
    };

    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Extra command line arguments to pass to strelaysrv.
      '';
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.syncthing-relay = {
      description = "Syncthing relay service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = baseNameOf dataDirectory;

        LoadCredential =
          [ ]
          ++ optional (cfg.token != null) "relay_token:${cfg.token}"
          ++ optional (cfg.key != null) "key:${cfg.key}"
          ++ optional (cfg.cert != null) "cert:${cfg.cert}";

        Restart = "on-failure";
        ExecStartPre =
          mkIf (cfg.cert != null || cfg.key != null)
            "${pkgs.writers.writeBash "syncthing-relay-copy-keys" ''
              install -dm700 ${dataDirectory}
              ${optionalString (cfg.cert != null) ''
                install -Dm644 "$CREDENTIALS_DIRECTORY/cert" ${dataDirectory}/cert.pem
              ''}
              ${optionalString (cfg.key != null) ''
                install -Dm600 "$CREDENTIALS_DIRECTORY/key" ${dataDirectory}/key.pem
              ''}
            ''}";
        ExecStart =
          if cfg.token != null then
            "${strelaysrvWrapper}"
          else
            "${pkgs.syncthing-relay}/bin/strelaysrv ${concatStringsSep " " relayOptions}";
      };
    };
  };
}
