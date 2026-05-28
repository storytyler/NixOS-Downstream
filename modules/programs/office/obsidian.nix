{ pkgs, ... }:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      let
        configDir = "${config.home.homeDirectory}/NixOS/modules/programs/office/json";
        vault = "Workspace/writing";
        obs = "${vault}/.obsidian";

        mkObsidianLink = name: {
          "${obs}/${name}".source =
            config.lib.file.mkOutOfStoreSymlink "${configDir}/${name}";
        };
      in
      {
        home.packages = [ pkgs.obsidian ];

        home.file = builtins.foldl' (acc: x: acc // x) {} [
          (mkObsidianLink "app.json")
          (mkObsidianLink "appearance.json")
          (mkObsidianLink "core-plugins.json")
        ];
      }
    )
  ];
}
