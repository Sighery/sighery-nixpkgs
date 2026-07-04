{ stdenv, fetchFromGitHub, cmake, openssl, lib, ... }:

stdenv.mkDerivation {
  pname = "irlserver-srt";
  version = "f229719";

  src = fetchFromGitHub {
    owner = "irlserver";
    repo = "srt";
    rev = "f2297192ce9ab572464e84228efbc46f8c1eabf4";
    hash = "sha256-1X5bpdgb9VL8/JgdCRQtVyrR+SwO7vtM/MnMxl+GIjY=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
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

  meta = with lib; {
    homepage = "https://github.com/irlserver/srt";
    description = "Up-to-date fork of the srt shared library with BELABOX changes";
    license = licenses.mpl20;
    platforms = platforms.all;
  };
}
