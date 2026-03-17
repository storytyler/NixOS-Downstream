{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "portainer-mcp";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "portainer";
    repo = "portainer-mcp";
    rev = "v${version}";
    hash = "sha256-J8M7RMWsbuVnC77myJ2Wyy+zJPwWkg5CjwGNzR4SiQU=";
  };

  vendorHash = "sha256-cD57hnS3J8v1BmvD50dtvsjrEJowklhSHl7esGZkz6I=";

  # Integration tests require Docker/testcontainers
  doCheck = false;
  env.CGO_ENABLED = 0;

  flags = [ "-trimpath" ];

  ldflags = [
    "-s"
    "-w"
    "-extldflags -static"
  ];

  meta = with lib; {
    description = "MCP server for Portainer container management";
    homepage = "https://github.com/portainer/portainer-mcp";
    mainProgram = "portainer-mcp";
    license = licenses.zlib;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ ];
  };
}
