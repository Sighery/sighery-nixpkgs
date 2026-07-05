{
  description = "Sighery's custom package collection";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";

      localPkgsOverlay = import ./overrides/local-packages.nix;
      fantasqueOverlay = import ./overrides/fantasque-sans-mono;
      spotifyOverlay = import ./overrides/spotify;

      overlays = [
        localPkgsOverlay
        fantasqueOverlay
        spotifyOverlay
      ];

      composedOverlay = nixpkgs.lib.composeManyExtensions overlays;

      pkgs = import nixpkgs {
        inherit system;
        overlays = overlays;
      };

      customPkgs = import ./pkgs { inherit pkgs; };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      packages.${system} = customPkgs;

      overlays.default = composedOverlay;

      nixosModules = {
        goaccess = import ./modules/goaccess.nix;
        srtla-relay = import ./modules/srtla-relay.nix;
        syncthing-relay = import ./modules/syncthing-relay.nix;
      };
    };
}
