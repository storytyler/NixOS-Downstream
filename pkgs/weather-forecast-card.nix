{
  lib,
  fetchurl,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "weather-forecast-card";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/troinine/ha-weather-forecast-card/releases/download/v${version}/weather-forecast-card.js";
    hash = "sha256-NUIh6N1/P+Vphcpa/ppP+cBcT5BY0FevIhC1OxBJTIo=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp $src $out/weather-forecast-card.js

    runHook postInstall
  '';

  meta = {
    description = "Custom weather card with horizontal scrolling, tap-to-toggle forecasts, and chart mode";
    homepage = "https://github.com/troinine/ha-weather-forecast-card";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
