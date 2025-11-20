{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "model-runner";
  version = "0.1.46";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "model-runner";
    rev = "cmd/cli/v${version}";
    hash = "sha256-A6QVtIuK217XBN0cHW+oQNp6ZcYV4wunEzVI/TOEOK4=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  ldflags = [ "-s" "-w" ];

  meta = {
    description = "Docker Model Runner";
    homepage = "https://github.com/docker/model-runner";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "model-runner";
  };
}
