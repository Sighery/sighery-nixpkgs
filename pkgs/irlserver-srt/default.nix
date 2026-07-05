{ stdenv, fetchFromGitHub, cmake, tcl, openssl, lib, ... }:

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
    tcl
  ];

  buildInputs = [
    openssl
  ];

  # postPatch = ''
  #   substituteInPlace scripts/srt.pc.in --replace-fail \
  #     $\{exec_prefix\}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  #   substituteInPlace scripts/srt.pc.in --replace-fail \
  #     $\{prefix\}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  # '';

  # configurePhase = ''
  #   runHook preConfigure

  #   ./configure

  #   runHook postConfigure
  # '';

  # postConfigure =
  configureScript = "./configure";

  # buildPhase = ''
  #   ./configure
  # '';

  # https://github.com/nh2/nixpkgs/blob/f7b53c0f6a42aa1aaa23628fd44891ad4102f9df/pkgs/development/libraries/srt/default.nix#L20-L29
  cmakeFlags = [
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-UCMAKE_INSTALL_LIBDIR"
  ];

  # cmakeFlags = [
  #   "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  #   "-DENABLE_STDCXX_SYNC=ON"
  #   "-DCMAKE_INSTALL_INCLUDEDIR=include"
  #   "-UCMAKE_INSTALL_LIBDIR"
  #   "-DENABLE_ENCRYPTION=ON"
  #   "-DENABLE_BONDING=ON"
  # ];

  meta = with lib; {
    homepage = "https://github.com/irlserver/srt";
    description = "Up-to-date fork of the srt shared library with BELABOX changes";
    license = licenses.mpl20;
    platforms = platforms.all;
  };
}
