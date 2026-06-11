# Taken from https://github.com/NL-TCH/nur-packages/blob/bcba7e4cf0f28a60630df8e2b56dc37b94e06d2b/pkgs/spotify-adblock/default.nix
{ pkgs, ... }:

pkgs.rustPlatform.buildRustPackage {
  pname = "spotify-adblock";
  version = "lastcommit 2026-06-07";

  src = pkgs.fetchFromGitHub {
    owner = "abba23";
    repo = "spotify-adblock";
    rev = "9aeadd3cfd4d50212059720c09f662f149942fec";
    fetchSubmodules = false;
    hash = "sha256-3X7vScKmnb65wJ4xWAT2AeyAMPTGzKZCFA549zm9gLc=";
  };

  cargoHash = "sha256-gxGetdqaoJa/ZF1VnW6UXJyJfLBGZxZnyKpT/Qk/8Og=";

  patchPhase = ''
    substituteInPlace src/config.rs \
      --replace 'config.toml' $out/etc/spotify-adblock/config.toml
  '';

  buildPhase = ''
    runHook preBuild

    make

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/etc/spotify-adblock
    install -D --mode=644 config.toml $out/etc/spotify-adblock
    mkdir -p $out/lib
    install -D --mode=644 --strip target/release/libspotifyadblock.so $out/lib

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    homepage = "https://github.com/abba23/spotify-adblock";
    description = "Adblocker for Spotify";
    license = licenses.gpl3;
    platforms = platforms.linux;

    # Custom attr to exclude from the flake overlay
    excludeFromOverlay = true;
  };
}
