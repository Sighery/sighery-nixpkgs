{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "ffmpeg-helpers";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp fftomp4.sh $out/bin/fftomp4
    chmod +x $out/bin/fftomp4

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/fftomp4 \
      --set PATH ${pkgs.lib.makeBinPath (with pkgs; [
        ffmpeg
        coreutils
      ])}
  '';

  meta = with pkgs.lib; {
    homepage = "https://github.com/Sighery/sighery-nixpkgs";
    description = "Series of ffmpeg helper scripts for things I need to do often.";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
