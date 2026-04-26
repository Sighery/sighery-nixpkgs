{
  description = "Sighery's custom package collection";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      overlay = final: prev: let
        spotify-adblock = import ./pkgs/spotify-adblock { pkgs = final; };
      in {
        ffmpeg-helpers = import ./pkgs/ffmpeg-helpers { pkgs = final; };
        vineflower = import ./pkgs/vineflower { pkgs = final; };
        scrcpy-rofi = import ./pkgs/scrcpy-rofi { pkgs = final; };
        audio-notification = import ./pkgs/audio-notification { pkgs = final; };

        spotify = prev.spotify.overrideAttrs (old: {
          buildInputs = (old.buildInputs or [ ]) ++ [prev.zip prev.unzip];
          postInstall =
            (old.postInstall or "")
            + ''
              ln -s ${spotify-adblock}/lib/libspotifyadblock.so $libdir
              sed -i "s:^Name=Spotify.*:Name=Spotify-adblock:" "$out/share/spotify/spotify.desktop"
              wrapProgram $out/bin/spotify \
                --set LD_PRELOAD "${spotify-adblock}/lib/libspotifyadblock.so"

              # Hide placeholder for advert banner
              ${prev.unzip}/bin/unzip -p $out/share/spotify/Apps/xpui.spa xpui-snapshot.js | sed 's/adsEnabled:\!0/adsEnabled:false/' > $out/share/spotify/Apps/xpui-snapshot.js
              ${prev.zip}/bin/zip --junk-paths --update $out/share/spotify/Apps/xpui.spa $out/share/spotify/Apps/xpui-snapshot.js
              rm $out/share/spotify/Apps/xpui-snapshot.js
            '';
        });

        fantasque-sans-mono = prev.fantasque-sans-mono.overrideAttrs(old: {
          version = "1.7.2";

          src = prev.fetchzip {
            url = "https://github.com/belluzj/fantasque-sans/releases/download/v1.7.2/FantasqueSansMono-LargeLineHeight-NoLoopK.zip";
            stripRoot = false;
            hash = "sha256-/vfThWY+ig/5yeljEQNjpBIMQQQ84wZa0as+kUv4KXA=";
          };
        });
      };
    in
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; overlays = [ overlay ]; };
      in {
        packages.ffmpeg-helpers = pkgs.ffmpeg-helpers;
        packages.vineflower = pkgs.vineflower;
        packages.scrcpy-rofi = pkgs.scrcpy-rofi;
        packages.audio-notification = pkgs.audio-notification;
      }
    )
    // {
      overlays.default = overlay;
    };
}
