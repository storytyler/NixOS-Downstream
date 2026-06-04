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
    compose2nix = {
      url = "github:aksiksi/compose2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    skwd-wall.url = "github:liixini/skwd-wall";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opencode = {
      url = "github:sst/opencode";
    };
    # TEMP PIN: jerome-benoit/qmd@3cf89cd95b80 includes upstream PR #574 (NixOS
    # compat — fixes EROFS in node-llama-cpp localBuilds + extends LD_LIBRARY_PATH
    # to include glibc/libstdc++ for the FHS-linked prebuilts).
    # Track upstream PR: https://github.com/tobi/qmd/pull/574
    # Unpin back to `github:tobi/qmd` once #574 merges to main. Revert by deleting
    # this comment and changing the url to `github:tobi/qmd`, then `nix flake update`.
    # Tracked in codemem (search: "qmd fork pin PR 574").
    qmd = {
      url = "github:jerome-benoit/qmd/3cf89cc95b80da4c649f1e1e3a3df877144a8bc9";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    optnix = {
      url = "github:water-sucks/optnix";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      opencode,
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
