{ pkgs, ... }:

pkgs.stdenvNoCC.mkDerivation rec {
  pname = "fantasque-sans-mono";
  version = "1.7.2";

  src = pkgs.fetchzip {
    url = "https://github.com/belluzj/fantasque-sans/releases/download/v${version}/FantasqueSansMono-LargeLineHeight-NoLoopK.zip";
    stripRoot = false;
    hash = "sha256-/vfThWY+ig/5yeljEQNjpBIMQQQ84wZa0as+kUv4KXA=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 OTF/*.otf -t $out/share/fonts/opentype
    install -Dm644 README.md -t $out/share/doc/${pname}-${version}

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    homepage = "https://github.com/belluzj/fantasque-sans";
    description = "Font family with a great monospaced variant for programmers";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.rycee ];
  };
}
