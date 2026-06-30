{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "irlserver-srtla";
  version = "39e324a";

  src = pkgs.fetchFromGitHub {
    owner = "irlserver";
    repo = "srtla";
    rev = "39e324a9420763720b9f16c463971ababa757bc1";
    hash = "sha256-pb3SrhqzHoLdovjR802pf33jFgpYvybN9NsBfh3rQZk=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    python3
  ];

  buildInputs = with pkgs; [
    spdlog
    argparse
  ];

  patches = [
    ./dynamic-spdlog.diff
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m 755 srtla_rec $out/bin/irlserver-srtla_rec
    install -m 755 srtla_send $out/bin/irlserver-srtla_send

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    homepage = "https://github.com/irlserver/srtla";
    description = "SRT transport proxy with link aggregation for connection bonding";
    license = licenses.agpl3Plus;
    platforms = platforms.all;
  };
}
