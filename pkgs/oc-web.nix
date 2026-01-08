{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "oc-web";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "kcrommett";
    repo = "oc-web";
    rev = "v${version}";
    hash = "sha256-xtgfOmZ/Eyc7vnfswB0pfwdfkxkN0bY2alD4I8uWZJY=";
  };

  meta = {
    description = "";
    homepage = "https://github.com/kcrommett/oc-web";
    changelog = "https://github.com/kcrommett/oc-web/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "oc-web";
    platforms = lib.platforms.all;
  };
}
