{ pkgs, ... }:
let
  livesyncVersion = "0.25.70";
  livesyncRelease =
    "https://github.com/vrtmrz/obsidian-livesync/releases/download/${livesyncVersion}";

  livesyncMainJs = pkgs.fetchurl {
    url = "${livesyncRelease}/main.js";
    hash = "sha256-hmN3ojxVMTLkzoquvGzkwe+y7MFkCDS5py7coMS3JS0=";
  };

  livesyncManifest = pkgs.fetchurl {
    url = "${livesyncRelease}/manifest.json";
    hash = "sha256-CetyQuKLO3t35Mn/oXD+T0pKhrDRjtbmAuO9L0JKOZg=";
  };

  livesyncStyles = pkgs.fetchurl {
    url = "${livesyncRelease}/styles.css";
    hash = "sha256-t4Vv6AsekgOcvc6ikut5jTMM+BcWBgNEqlPXL0pozaw=";
  };
in
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      let
        configDir =
          "${config.home.homeDirectory}/NixOS/modules/programs/office/json";
        vault = "Workspace/writing";
        obs = "${vault}/.obsidian";
        plugin = "${obs}/plugins/obsidian-livesync";

        mkObsidianLink = name: {
          "${obs}/${name}".source =
            config.lib.file.mkOutOfStoreSymlink "${configDir}/${name}";
        };
      in
      {
        home.packages = [ pkgs.obsidian ];

        # Spellcheck dictionaries (Chromium .bdic format)
        xdg.configFile = {
          "obsidian/Dictionaries/${pkgs.hunspellDictsChromium.en-us.dictFileName}".source =
            pkgs.hunspellDictsChromium.en-us;
          "obsidian/Dictionaries/${pkgs.hunspellDictsChromium.en-gb.dictFileName}".source =
            pkgs.hunspellDictsChromium.en-gb;
        };

        home.file =
          (builtins.foldl' (acc: x: acc // x) { } [
            # Core Obsidian config (mutable)
            (mkObsidianLink "app.json")
            (mkObsidianLink "appearance.json")
            (mkObsidianLink "core-plugins.json")
            (mkObsidianLink "community-plugins.json")

          {}])
          // {
            # LiveSync plugin files (immutable — from Nix store)
            "${plugin}/main.js".source = livesyncMainJs;
            "${plugin}/manifest.json".source = livesyncManifest;
            "${plugin}/styles.css".source = livesyncStyles;
          };
      }
    )
  ];
}
