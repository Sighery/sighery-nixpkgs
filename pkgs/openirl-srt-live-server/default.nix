{ stdenv, fetchFromGitHub, gnumake, openirl-srt, zlib, openssl, sqlite, lib, ... }:

stdenv.mkDerivation {
  pname = "openirl-srt-live-server";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "OpenIRL";
    repo = "srt-live-server";
    rev = "refs/tags/1.5.2";
    hash = "sha256-0BROl2La/wqk/IbJhJQlBQ42oG/bmv8AhYt8dqfUF6E=";
  };

  nativeBuildInputs = [
    gnumake
  ];

  buildInputs = [
    openirl-srt
    zlib
    openssl
    sqlite
  ];

  installPhase = ''
    mkdir -p "$out/bin"
    install -m 755 bin/* $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/OpenIRL/srt-live-server";
    description = "SRT Live Server for low latency streaming";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
