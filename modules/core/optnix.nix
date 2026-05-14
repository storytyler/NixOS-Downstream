{
  inputs,
  options,
  pkgs,
  host,
  ...
}:
let
  optnixLib = inputs.optnix.mkLib pkgs;
in
{
  imports = [ inputs.optnix.nixosModules.optnix ];

  programs.optnix = {
    enable = true;
    settings = {
      scopes = {
        ${host} = {
          description = "NixOS configuration for ${host}";
          options-list-file = optnixLib.mkOptionsList { inherit options; };
          evaluator = "nix eval ~/NixOS#nixosConfigurations.${host}.config.{{ .Option }}";
        };
      };
    };
  };
}
