{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "scrcpy-rofi";
  version = "0.1.0";

  src = ./.;

  propagatedBuildInputs = with pkgs; [
    bash
    rofi
    scrcpy
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp scrcpy-rofi.sh $out/bin/scrcpy-rofi
    chmod +x $out/bin/scrcpy-rofi
  '';

  meta = with pkgs.lib; {
    homepage = "https://github.com/Sighery/sighery-nixpkgs";
    description = "A Rofi-based manager for scrcpy";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
