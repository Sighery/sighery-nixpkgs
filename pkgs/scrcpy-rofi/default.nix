{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "scrcpy-rofi";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp scrcpy-rofi.sh $out/bin/scrcpy-rofi
    chmod +x $out/bin/scrcpy-rofi

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/scrcpy-rofi \
      --set PATH ${pkgs.lib.makeBinPath (with pkgs; [
        rofi
        scrcpy
      ])}
  '';

  meta = with pkgs.lib; {
    homepage = "https://github.com/Sighery/sighery-nixpkgs";
    description = "A Rofi-based manager for scrcpy";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
