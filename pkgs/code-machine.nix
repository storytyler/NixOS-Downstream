{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
}:

buildNpmPackage rec {
  pname = "code-machine-cli";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "moazbuilds";
    repo = "CodeMachine-CLI";
    rev = "v${version}";
    hash = "sha256-aLoEdI0h1t0xSBCCiQ7YrntGee9dTI8YkoTUcVw/p3g=";
  };

  npmDepsHash = "sha256-dWrRLG5ogW5H/rp9TKgnXx2wLgeoDL1IKVkWodZOlpE=";

  nativeBuildInputs = [ nodejs ];

  meta = {
    description = "CodeMachine is a CLI-native orchestration platform that uses coordinated multi-agent AI workflows to adaptively transform specification files into production-ready code";
    homepage = "https://github.com/moazbuilds/CodeMachine-CLI/archive/refs/tags/v0.5.0.tar.gz";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "code-machine-cli";
    platforms = lib.platforms.all;
  };
}
