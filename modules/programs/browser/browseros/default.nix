{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.stdenv.mkDerivation {
      pname = "browseros";
      version = "0.28.0";
      src = pkgs.fetchurl {
        url = "https://github.com/browseros-ai/BrowserOS/releases/download/v0.28.0/BrowserOS_v0.28.0_x64.AppImage";
        hash = "sha256-YY3g0xNr/Jm4Q1PJSg27vO+M5jur/lM2a6iTN03BbCA=";
      };
      unpackPhase = "true";
      installPhase = ''
        install -Dm755 $src $out/bin/browseros
      '';
    })
  ];
}
