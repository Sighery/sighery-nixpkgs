# My personal nixpkgs for custom packages

There are some packages that are never going to be added into the official
`nixpkgs` because they're just one-off scripts that I use. Likewise, I also
override certain packages, like `fantasque-sans-mono`, to use an older version
without font ligatures. This would never be included in the official
`nixpkgs`.

So this flake is going to include my custom packages/overrides, which can be
easily included into any Nix setup.

The current list of packages can be found under [pkgs/][]. Each subdirectory
is a package. There is automation to automatically include any subdirectory
there into the flake packages.

Likewise, the list of overlay overrides can be found under [overrides/][].
Each subdirectory is an override. There is also automation to discover any
newly added overrides.

Custom packages are also automatically included into the overlay, to make it
easy to extend `nixpkgs` with my custom packages in Nix setups. The only
exceptions are custom packages with `meta.excludeFromOverlay` set to `true`.
Some custom packages, for different reasons, have no business being included
into the overlay.


### Check current overlay packages:

```sh
$ nix repl
Nix 2.31.4
Type :? for help.
nix-repl> :lf .
Added 14 variables.
_type, inputs, lastModified, lastModifiedDate, narHash, outPath, outputs, overlays, packages, rev, revCount, shortRev, sourceInfo, submodules

nix-repl> pkgs = import <nixpkgs> {}

nix-repl> builtins.attrNames (overlays.default pkgs pkgs)
[
  "audio-notification"
  "fantasque-sans-mono"
  "ffmpeg-helpers"
  "kitty-grab"
  "scrcpy-rofi"
  "spotify"
  "vineflower"
]
```


[pkgs/]: pkgs/
[overrides/]: overrides/
