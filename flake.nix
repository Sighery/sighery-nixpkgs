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
      };
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; overlays = [ overlay ]; };
      in {
        packages.ffmpeg-helpers = pkgs.ffmpeg-helpers;
      }
    )
    // {
      overlays.default = overlay;
    };
}
