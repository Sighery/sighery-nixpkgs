{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "audio-notification";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp audio_notification.sh $out/bin/audio-notification
    chmod +x $out/bin/audio-notification

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/audio-notification \
      --set PATH ${pkgs.lib.makeBinPath (with pkgs; [
        wireplumber
        bc
        gawk
        coreutils
        gnused
        libnotify
      ])}
  '';

  meta = with pkgs.lib; {
    homepage = "https://github.com/Sighery/sighery-nixpkgs";
    description = "Small helper script to display current volume and mute status on the default audio sink.";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
