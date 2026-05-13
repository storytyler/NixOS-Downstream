{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "bolder-weather-card";
  version = "1.10.3";

  src = fetchFromGitHub {
    owner = "clarinetJWD";
    repo = "bolder-weather-card";
    tag = "v${version}";
    hash = "sha256-Q7+EQQ9WB9qzb+afPFaoEsqc9TiGC1oMKDGR9AUZxTM=";
  };

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp ./dist/bolder-weather-card.js $out/bolder-weather-card.js

    runHook postInstall
  '';

  meta = {
    description = "Home Assistant weather card designed for wall-mounted displays with bold images and large text";
    homepage = "https://github.com/clarinetJWD/bolder-weather-card";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
