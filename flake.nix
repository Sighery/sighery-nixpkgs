{
  description = "Sighery's custom package collection";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;

      packagesOverlay = final: prev: {
        audio-notification = final.callPackage ./pkgs/audio-notification { };
        brightness-notification = final.callPackage ./pkgs/brightness-notification { };
        ffmpeg-helpers = final.callPackage ./pkgs/ffmpeg-helpers { };
        hermes = final.callPackage ./pkgs/hermes { };
        irlserver-irl-srt-server = final.callPackage ./pkgs/irlserver-irl-srt-server { };
        irlserver-srt = final.callPackage ./pkgs/irlserver-srt { };
        irlserver-srtla = final.callPackage ./pkgs/irlserver-srtla { };
        kitty-grab = final.callPackage ./pkgs/kitty-grab { };
        openirl-srt = final.callPackage ./pkgs/openirl-srt { };
        openirl-srt-live-server = final.callPackage ./pkgs/openirl-srt-live-server { };
        openirl-srtla = final.callPackage ./pkgs/openirl-srtla { };
        scrcpy-rofi = final.callPackage ./pkgs/scrcpy-rofi { };
        spotify-adblock = final.callPackage ./pkgs/spotify-adblock { };
        vineflower = final.callPackage ./pkgs/vineflower { };
        vscode-antislop-settings = final.callPackage ./pkgs/vscode-antislop-settings { };
        xclipboard = final.callPackage ./pkgs/xclipboard { };
      };

      spotifyOverride = import ./overrides/spotify.nix;
      fantasqueOverride = import ./overrides/fantasque-sans-mono.nix;

      overlay = final: prev:
        (packagesOverlay final prev)
        // (spotifyOverride final prev)
        // (fantasqueOverride final prev);

      packagesFor = system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ overlay ];
          };
        in
        {
          audio-notification = pkgs.audio-notification;
          brightness-notification = pkgs.brightness-notification;
          ffmpeg-helpers = pkgs.ffmpeg-helpers;
          hermes = pkgs.hermes;
          irlserver-irl-srt-server = pkgs.irlserver-irl-srt-server;
          irlserver-srt = pkgs.irlserver-srt;
          irlserver-srtla = pkgs.irlserver-srtla;
          kitty-grab = pkgs.kitty-grab;
          openirl-srt = pkgs.openirl-srt;
          openirl-srt-live-server = pkgs.openirl-srt-live-server;
          openirl-srtla = pkgs.openirl-srtla;
          scrcpy-rofi = pkgs.scrcpy-rofi;
          spotify-adblock = pkgs.spotify-adblock;
          vineflower = pkgs.vineflower;
          vscode-antislop-settings = pkgs.vscode-antislop-settings;
          xclipboard = pkgs.xclipboard;
        };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      nixosModules = {
        goaccess = import ./modules/goaccess.nix;
        srtla-relay = import ./modules/srtla-relay.nix;
        syncthing-relay = import ./modules/syncthing-relay.nix;
      };

      packages = forAllSystems packagesFor;

      overlays.default = overlay;
    };
}
