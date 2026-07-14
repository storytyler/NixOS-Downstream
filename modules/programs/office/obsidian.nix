{ pkgs, ... }:
let
  livesyncVersion = "0.25.70";
  livesyncRelease = "https://github.com/vrtmrz/obsidian-livesync/releases/download/${livesyncVersion}";

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

  hearthVersion = "1.10.0";
  hearthRelease = "https://github.com/ondreu/Hearth/releases/download/${hearthVersion}";

  hearthMainJs = pkgs.fetchurl {
    url = "${hearthRelease}/main.js";
    hash = "sha256-AUw5vSJ6edVodVcLc4zPnUGNUTahOu3C/fRb1sVotjo=";
  };

  hearthManifest = pkgs.fetchurl {
    url = "${hearthRelease}/manifest.json";
    hash = "sha256-u/0ygcKIaRDLUh7t7RM1qbX+9m0aQBEyPFClUfoIgv0=";
  };

  hearthStyles = pkgs.fetchurl {
    url = "${hearthRelease}/styles.css";
    hash = "sha256-tr34vTL53KONw4mpGg1DEpLInb5lGeyYsqLHxfVLHl0=";
  };

  styleSettingsVersion = "1.0.9";
  styleSettingsRelease = "https://github.com/obsidian-community/obsidian-style-settings/releases/download/${styleSettingsVersion}";

  styleSettingsMainJs = pkgs.fetchurl {
    url = "${styleSettingsRelease}/main.js";
    hash = "sha256-GCirqs2rTFV4twWmJcWFswUS+O+tTHz8WhjnDMNVdGg=";
  };

  styleSettingsManifest = pkgs.fetchurl {
    url = "${styleSettingsRelease}/manifest.json";
    hash = "sha256-nP/cIM8qoTVIIOAFC2lLD5tXZEbj1dRKNq6LAYflv7g==";
  };

  styleSettingsStyles = pkgs.fetchurl {
    url = "${styleSettingsRelease}/styles.css";
    hash = "sha256-7nk30r5QZTqJzLMK5fBXKyNQfVt/EyjQBScaNjB1v9g=";
  };
in
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      let
        configDir = "${config.home.homeDirectory}/NixOS/modules/programs/office/json";
        vault = "Workspace/writing";
        obs = "${vault}/.obsidian";
        livesyncPlugin = "${obs}/plugins/obsidian-livesync";
        hearthPlugin = "${obs}/plugins/hearth";
        styleSettingsPlugin = "${obs}/plugins/obsidian-style-settings";

        mkObsidianLink = name: {
          "${obs}/${name}".source = config.lib.file.mkOutOfStoreSymlink "${configDir}/${name}";
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

            { }
          ])
          // {
            # LiveSync plugin files (immutable — from Nix store)
            "${livesyncPlugin}/main.js".source = livesyncMainJs;
            "${livesyncPlugin}/manifest.json".source = livesyncManifest;
            "${livesyncPlugin}/styles.css".source = livesyncStyles;

            # Hearth plugin files (immutable — from Nix store)
            "${hearthPlugin}/main.js".source = hearthMainJs;
            "${hearthPlugin}/manifest.json".source = hearthManifest;
            "${hearthPlugin}/styles.css".source = hearthStyles;

            # Style Settings plugin files (immutable — from Nix store)
            "${styleSettingsPlugin}/main.js".source = styleSettingsMainJs;
            "${styleSettingsPlugin}/manifest.json".source = styleSettingsManifest;
            "${styleSettingsPlugin}/styles.css".source = styleSettingsStyles;
          };
      }
    )
  ];
}
