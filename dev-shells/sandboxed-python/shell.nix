{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  buildInputs = [ ];

  shellHook = ''
    echo "Sandboxed Python Environment"
    echo ""
    echo "Usage: ./docker-sandbox-python [OPTIONS] [DIRECTORY]"
    echo ""
    echo "Examples:"
    echo "  ./docker-sandbox-python                    # Run in current directory"
    echo "  ./docker-sandbox-python /path/to/project   # Run in specific directory"
    echo "  ./docker-sandbox-python --python=3.11      # Use Python 3.11"
    echo ""
    echo "Run './docker-sandbox-python --help' for all options"
    echo ""
    echo "Make sure to add this directory to your PATH, or run:"
    echo "  export PATH=$(pwd):\$PATH"
  '';
}
