final: prev:
let
  callPackage = final.lib.callPackageWith (final // prev);
in
{
  audio-notification = callPackage ../pkgs/audio-notification { };
  brightness-notification = callPackage ../pkgs/brightness-notification { };
  ffmpeg-helpers = callPackage ../pkgs/ffmpeg-helpers { };
  hermes = callPackage ../pkgs/hermes { };
  irlserver-irl-srt-server = callPackage ../pkgs/irlserver-irl-srt-server { };
  irlserver-srt = callPackage ../pkgs/irlserver-srt { };
  irlserver-srtla = callPackage ../pkgs/irlserver-srtla { };
  kitty-grab = callPackage ../pkgs/kitty-grab { };
  openirl-srt = callPackage ../pkgs/openirl-srt { };
  openirl-srt-live-server = callPackage ../pkgs/openirl-srt-live-server { };
  openirl-srtla = callPackage ../pkgs/openirl-srtla { };
  scrcpy-rofi = callPackage ../pkgs/scrcpy-rofi { };
  vineflower = callPackage ../pkgs/vineflower { };
  vscode-antislop-settings = callPackage ../pkgs/vscode-antislop-settings { };
  xclipboard = callPackage ../pkgs/xclipboard { };
}
