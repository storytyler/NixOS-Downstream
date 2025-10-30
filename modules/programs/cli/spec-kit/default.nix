  { pkgs, lib, ... }:

  {
    environment.systemPackages = with pkgs; [
      (python3.pkgs.buildPythonApplication {
        pname = "spec-kit";
        version = "0.0.79";
        pyproject = true;

        src = fetchFromGitHub {
          owner = "github";
          repo = "spec-kit";
          rev = "v0.0.79";
          hash = "sha256-A5WQ6/YeEfYrGRxO/V7grKB3O2wv4WIXBvNBAYxAx4Y=";
        };

        build-system = [
          python3.pkgs.hatchling
        ];

        dependencies = with python3.pkgs; [
          httpx
          platformdirs
          readchar
          rich
          truststore
          typer
        ];

        pythonImportsCheck = [ "specify_cli" ];

        meta = {
          description = "Toolkit to help you get started with Spec-Driven Development";
          homepage = "https://github.com/github/spec-kit";
          changelog = "https://github.com/github/spec-kit/blob/v0.0.79/CHANGELOG.md";
          license = lib.licenses.mit;
          mainProgram = "spec-kit";
        };
      })
    ];
  }