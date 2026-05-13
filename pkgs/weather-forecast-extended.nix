{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "weather-forecast-extended";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Thyraz";
    repo = "weather-forecast-extended";
    tag = "v${version}";
    hash = "sha256-fFqzwPjaHSd/gaNsoQuoIMlNXLFtYhvkvXQRVnlWDZ8=";
  };

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp ./dist/weatherforecastextended.js $out/weather-forecast-extended.js

    runHook postInstall
  '';

  meta = {
    description = "Weather card with extended forecast features including horizontal orientation";
    homepage = "https://github.com/Thyraz/weather-forecast-extended";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
