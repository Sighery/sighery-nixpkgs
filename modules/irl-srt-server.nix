{ config, lib, pkgs, ... }:

let
  serviceName = "irl-srt-server";
  cfg = config.services."${serviceName}";
  dataDirectory = "/var/lib/${serviceName}";
  userName = cfg.userName;
  types = lib.types;
in
{
  options.services."${serviceName}" = {
    enable = lib.mkEnableOption "${serviceName} service";

    slsConfig = lib.mkOption {
      type = types.nonEmptyStr;
      description = ''
        SLS configuration.
        For reference, check <https://github.com/irlserver/irl-srt-server/blob/16a66c531f7a71ef05e47ccfb707f0e1862b30e1/src/sls.conf>.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services."${serviceName}" = {
      description = "SRT/LA Relay";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = baseNameOf dataDirectory;

        Restart = "on-failure";
        ExecStartPre =
          let
            slsConfig = pkgs.writeTextFile {
              name = "irl-srt-server-sls-config";
              text = cfg.slsConfig;
            };
          in
          "${pkgs.writers.writeBash "${serviceName}-copy-settings" ''
            install -dm700 ${dataDirectory}
            install -Dm600 ${slsConfig} ${dataDirectory}/sls.conf
          ''}";

        ExecStart = "${pkgs.irlserver-irl-srt-server}/bin/srt_server -c ${dataDirectory}/sls.conf";
      };
    };
  };
}
