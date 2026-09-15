{
  description = "Sighery's custom package collection";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;

      packagesOverlay = final: prev:
        import ./pkgs final;

      overrides = import ./overrides { inherit (nixpkgs) lib; };

      overlay = nixpkgs.lib.composeManyExtensions [
        packagesOverlay
        overrides
      ];

      packagesFor = system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ overlay ];
          };
        in
        import ./pkgs pkgs;
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      nixosModules = import ./modules;

      packages = forAllSystems packagesFor;

      overlays.default = overlay;
    };
}
