{ stdenv, fetchurl, makeWrapper, jre_headless, lib, ... }:

let
  pname = "vineflower";
  version = "1.11.2";
in
stdenv.mkDerivation {
  pname = pname;
  version = version;

  src = fetchurl {
    url = "https://github.com/Vineflower/${pname}/releases/download/${version}/${pname}-${version}.jar";
    sha256 = "sha256-4eJBXn94s0lgQCxL7d/IjgM9eEKiPs0TKo7C6t1U9r8=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre_headless ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    cp $src $out/share/java/vineflower.jar

    mkdir -p $out/bin
    makeWrapper ${jre_headless}/bin/java $out/bin/vineflower \
      --add-flags "-jar $out/share/java/vineflower.jar"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/Vineflower/vineflower";
    description = "Modern Java decompiler aiming to be as accurate as possible, with an emphasis on output quality. Fork of the Fernflower decompiler.";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
