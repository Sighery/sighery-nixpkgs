{ stdenvNoCC, fetchurl, gnused, lib, ... }:

let
  version = "cf75574ca1958e23118a872700127c8e1fadb50c";
in
stdenvNoCC.mkDerivation {
  pname = "vscode-antislop-settings";
  version = version;

  src = fetchurl {
    url = "https://gist.githubusercontent.com/rpavlik/95d6c40d8407805e2c20bdf6d9efa44e/raw/${version}/settings.json";
    hash = "sha256-uZDHjyErG7EACMf2mHoKH4XdNI0NmH7Bj9++1Ogq1P4=";
  };

  nativeBuildInputs = [
    gnused
  ];

  unpackPhase = ''
    runHook preUnpack

    mkdir -p "$out"
    cp "$src" "$out/settings.json"

    runHook postUnpack
  '';

  postPatch = ''
    sed -i '/^\s*\/\/ /d' "$out/settings.json"
    substituteInPlace "$out/settings.json" \
      --replace-fail '"geminicodeassist.chat.automaticScrolling": false,' \
        '"geminicodeassist.chat.automaticScrolling": false'
  '';

  meta = with lib; {
    homepage = "https://gist.github.com/rpavlik/95d6c40d8407805e2c20bdf6d9efa44e";
    description = "Go away copilot and other slop machines (in vscode)";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
