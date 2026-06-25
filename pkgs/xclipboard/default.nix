{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "xclipboard";
  version = "0.3.0";

  src = ./.;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp xclipboard.sh $out/bin/xclipboard
    chmod +x $out/bin/xclipboard

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/xclipboard \
      --set PATH ${pkgs.lib.makeBinPath (with pkgs; [
        xclip
        coreutils
      ])}
  '';

  meta = with pkgs.lib; {
    homepage = "https://github.com/Sighery/sighery-nixpkgs";
    description = "Helper script to copy files to clipboard from CLI.";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
