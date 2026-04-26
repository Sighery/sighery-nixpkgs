pkgs:

let
  dir = ./.;
  entries = builtins.readDir dir;

  packageDirs = pkgs.lib.filterAttrs (name: type:
    type == "directory"
    && builtins.pathExists (dir + "/${name}/default.nix")
  ) entries;
in
  pkgs.lib.mapAttrs (name: _:
    import (dir + "/${name}") pkgs
  ) packageDirs
