# Taken from https://github.com/NL-TCH/nur-packages/blob/bcba7e4cf0f28a60630df8e2b56dc37b94e06d2b/pkgs/spotify-adblock/default.nix
{ pkgs, ... }:

pkgs.rustPlatform.buildRustPackage {
  pname = "spotify-adblock";
  version = "lastcommit 2025-05-20";

  src = pkgs.fetchFromGitHub {
    owner = "abba23";
    repo = "spotify-adblock";
    rev = "refs/heads/main";
    fetchSubmodules = false;
    hash = "sha256-nwiX2wCZBKRTNPhmrurWQWISQdxgomdNwcIKG2kSQsE=";
  };

  cargoHash = "sha256-oGpe+kBf6kBboyx/YfbQBt1vvjtXd1n2pOH6FNcbF8M=";

  patchPhase = ''
    substituteInPlace src/lib.rs \
      --replace 'config.toml' $out/etc/spotify-adblock/config.toml
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/etc/spotify-adblock
    install -D --mode=644 config.toml $out/etc/spotify-adblock
    mkdir -p $out/lib
    install -D --mode=644 --strip target/release/libspotifyadblock.so $out/lib
  '';

  meta = with pkgs.lib; {
    homepage = "https://github.com/abba23/spotify-adblock";
    description = "Adblocker for Spotify";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
