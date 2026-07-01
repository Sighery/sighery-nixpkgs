{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "irlserver-srt";
  version = "v1.5.4+openirl.1";

  src = pkgs.fetchFromGitHub {
    owner = "OpenIRL";
    repo = "srt";
    rev = "refs/tags/v1.5.4+openirl.1";
    hash = "sha256-geHIFEAUGKrU2R4I8QAL/3BzJncrgglYQKe3boKWagI=";
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
    homepage = "https://github.com/OpenIRL/srt";
    description = "Secure, Reliable, Transport";
    license = licenses.mpl20;
    platforms = platforms.all;
  };
}
