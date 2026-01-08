{
  description = "RocketNotes dev shell";

  inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.nodejs_20 # for frontend
          pkgs.go_1_24 # for backend
          pkgs.python312 # for any AI helpers
          pkgs.yarn
          pkgs.git
        ];
        shellHook = ''
          echo "🚀 RocketNotes dev shell ready"
        '';
      };
    };
}
