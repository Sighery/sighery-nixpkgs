{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "openirl-srtla";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "OpenIRL";
    repo = "srtla";
    rev = "refs/tags/1.0.0";
    hash = "sha256-Q6gi046dAsjK2AklAsXrYAkDJiqnhYouZuCDnKZijmw=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    python3
  ];

  buildInputs = with pkgs; [
    spdlog
    argparse
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m 755 srtla_rec $out/bin/openirl-srtla_rec

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    homepage = "https://github.com/OpenIRL/srtla";
    description = "SRT transport proxy with link aggregation for connection bonding";
    license = licenses.agpl3Plus;
    platforms = platforms.all;
  };
}
