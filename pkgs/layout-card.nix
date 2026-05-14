{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "layout-card";
  version = "2.4.7";
  src = fetchFromGitHub {
    owner = "thomasloven";
    repo = "lovelace-layout-card";
    tag = "v${version}";
    hash = "sha256-xni9cTgv5rdpr+Oo4Zh/d/2ERMiqDiTFGAiXEnigqjc=";
  };

  installPhase = ''
    mkdir $out
    cp ./layout-card.js $out/layout-card.js
  '';

  meta = with lib; {
    description = "CSS Grid layout card for Home Assistant Lovelace";
    homepage = "https://github.com/thomasloven/lovelace-layout-card";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
