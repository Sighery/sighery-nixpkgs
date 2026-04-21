{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "audio-notification";
  version = "0.1.0";

  src = ./.;

  propagatedBuildInputs = with pkgs; [
    bash
    wireplumber
    bc
    gawk
    coreutils
    gnused
    libnotify
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp audio_notification.sh $out/bin/audio-notification
    chmox +x
  '';
}
