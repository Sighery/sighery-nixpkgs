{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "ffmpeg-helpers";
  version = "0.1.0";

  src = ./.;

  propagatedBuildInputs = with pkgs; [
    dash
    ffmpeg
    coreutils
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp fftomp4.sh $out/bin/fftomp4
    chmod +x $out/bin/fftomp4
  '';

  meta = with pkgs.lib; {
    homepage = "https://github.com/Sighery/sighery-nixpkgs";
    description = "Series of ffmpeg helper scripts for things I need to do often.";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
