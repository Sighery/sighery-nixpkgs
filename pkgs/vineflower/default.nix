{ pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "vineflower";
  version = "1.11.2";

  src = pkgs.fetchurl {
    url = "https://github.com/Vineflower/vineflower/releases/download/${version}/vineflower-${version}.jar";
    sha256 = "sha256-4eJBXn94s0lgQCxL7d/IjgM9eEKiPs0TKo7C6t1U9r8=";
  };

  nativeBuildInputs = [ pkgs.makeWrapper ];
  buildInputs = [ pkgs.jre_headless ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/java
    cp $src $out/share/java/vineflower.jar

    mkdir -p $out/bin
    makeWrapper ${pkgs.jre_headless}/bin/java $out/bin/vineflower \
      --add-flags "-jar $out/share/java/vineflower.jar"
  '';

  meta = with pkgs.lib; {
    homepage = "https://github.com/Vineflower/vineflower";
    description = "Modern Java decompiler aiming to be as accurate as possible, with an emphasis on output quality. Fork of the Fernflower decompiler.";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
