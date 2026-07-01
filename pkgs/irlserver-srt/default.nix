{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "irlserver-srt";
  version = "v1.5.4-irl2";

  src = pkgs.fetchFromGitHub {
    owner = "irlserver";
    repo = "srt";
    rev = "refs/tags/v1.5.4-irl2";
    hash = "sha256-0OqNF7ix4AzWyxlChJQ6IXRuR98rLynnlml7ojG3O3A=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
  ];

  buildInputs = with pkgs; [
    openssl
  ];

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DENABLE_STDCXX_SYNC=ON"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-UCMAKE_INSTALL_LIBDIR"
    "-DENABLE_ENCRYPTION=ON"
    "-DENABLE_BONDING=ON"
  ];

  meta = with pkgs.lib; {
    homepage = "https://github.com/irlserver/srt";
    description = "Up-to-date fork of the srt shared library with BELABOX changes";
    license = licenses.mpl20;
    platforms = platforms.all;
  };
}
