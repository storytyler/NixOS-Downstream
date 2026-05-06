{
  description = "A simple flake for an atomic system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
    thunderbird-catppuccin = {
      url = "github:catppuccin/thunderbird";
      flake = false;
    };
    claude-code = {
      url = "github:sadjow/claude-code-nix";
    };
    compose2nix = {
      url = "github:aksiksi/compose2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opencode = {
      url = "github:sst/opencode";
    };
    optnix = {
      url = "github:water-sucks/optnix";
    };
  };

  outputs =
    {
      opencode,
      claude-code,
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      mkHost =
        host:
        nixpkgs.lib.nixosSystem {
          modules = [
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            ./hosts/${host}/configuration.nix
          ];
          specialArgs = {
            overlays = import ./overlays { inherit inputs host; };
            inherit
              self
              inputs
              outputs
              host
              ;
          };
        };
    in
    {
      templates = import ./dev-shells;
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
      nixosConfigurations = {
        Default = mkHost "Default";
        Subrelay-01 = mkHost "Subrelay-01";
        Scout-02 = mkHost "Scout-02";
        Station-Alpha = mkHost "Station-Alpha";
      };
    };
}
