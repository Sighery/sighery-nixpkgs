{ pkgs }:

let
  callPackage = pkgs.lib.callPackageWith (pkgs // packages);
  packages = {
    audio-notification = callPackage ./audio-notification { };
    brightness-notification = callPackage ./brightness-notification { };
    ffmpeg-helpers = callPackage ./ffmpeg-helpers { };
    hermes = callPackage ./hermes { };
    irlserver-irl-srt-server = callPackage ./irlserver-irl-srt-server { };
    irlserver-srt = callPackage ./irlserver-srt { };
    irlserver-srtla = callPackage ./irlserver-srtla { };
    kitty-grab = callPackage ./kitty-grab { };
    openirl-srt = callPackage ./openirl-srt { };
    openirl-srt-live-server = callPackage ./openirl-srt-live-server { };
    openirl-srtla = callPackage ./openirl-srtla { };
    scrcpy-rofi = callPackage ./scrcpy-rofi { };
    spotify-adblock = callPackage ./spotify-adblock { };
    vineflower = callPackage ./vineflower { };
    vscode-antislop-settings = callPackage ./vscode-antislop-settings { };
    xclipboard = callPackage ./xclipboard { };
  };
in
packages
