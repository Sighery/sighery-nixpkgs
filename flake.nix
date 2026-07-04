{
  description = "Sighery's custom package collection";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";

      pkgsBase = import nixpkgs {
        inherit system;
        overlays = [ ];
      };

      customPkgs = import ./pkgs pkgsBase;

      pkgsBaseWithCustom = pkgsBase.extend (final: prev: customPkgs);

      customOverlay = import ./overrides {
        pkgsBase = pkgsBaseWithCustom;
        customPkgs = customPkgs;
      };

      pkgs = import nixpkgs {
        inherit system;
        overlays = [ customOverlay ];
      };

    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      packages.${system} = customPkgs;

      overlays.default = customOverlay;

      nixosModules = {
        goaccess = import ./modules/goaccess.nix;
        syncthing-relay = import ./modules/syncthing-relay.nix;
      };
    };
}
