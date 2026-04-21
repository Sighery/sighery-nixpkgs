{
  description = "Sighery's custom package collection";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      overlay = final: prev: {
        ffmpeg-helpers = import ./pkgs/ffmpeg-helpers { pkgs = final; };
        vineflower = import ./pkgs/vineflower { pkgs = final; };
        # TODO: Maybe switch to an overlay? Once I figure out how
        fantasque-sans-mono = import ./pkgs/fantasque-sans-mono { pkgs = final; };
        scrcpy-rofi = import ./pkgs/scrcpy-rofi { pkgs = final; };
        audio-notification = import ./pkgs/audio-notification { pkgs = final; };
      };
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; overlays = [ overlay ]; };
      in {
        packages.ffmpeg-helpers = pkgs.ffmpeg-helpers;
        packages.vineflower = pkgs.vineflower;
        packages.fantasque-sans-mono = pkgs.fantasque-sans-mono;
        packages.scrcpy-rofi = pkgs.scrcpy-rofi;
        packages.audio-notification = pkgs.audio-notification;
      }
    )
    // {
      overlays.default = overlay;
    };
}
