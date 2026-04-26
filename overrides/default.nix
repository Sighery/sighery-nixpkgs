{ pkgsBase, customPkgs, ... }:

let
  filteredPkgs = pkgsBase.lib.filterAttrs (name: pkg:
    !(pkg.meta or {}).excludeFromOverlay or false
  ) customPkgs;

  dir = ./.;
  entries = builtins.readDir dir;

  overrideDirs = pkgsBase.lib.filterAttrs (name: type:
    type == "directory"
    && builtins.pathExists (dir + "/${name}/default.nix")
  ) entries;

  overrideNames = builtins.attrNames overrideDirs;

  overrideFns = map (
    name: import (./. + "/${name}") { inherit pkgsBase; }
  ) overrideNames;

  combinedOverrides = final: prev:
    builtins.foldl'
      (acc: overrideFn: acc // overrideFn final prev)
      {}
      overrideFns;
in
  final: prev:
    combinedOverrides final prev

    # Custom packages
    // filteredPkgs
