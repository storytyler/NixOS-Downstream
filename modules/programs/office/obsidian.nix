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

  cursorTorchVersion = "1.0.1";
  cursorTorchRelease = "https://github.com/Astraaaa02/Obsidian-Torch-Cursor/releases/download/${cursorTorchVersion}";

  cursorTorchMainJs = pkgs.fetchurl {
    url = "${cursorTorchRelease}/main.js";
    hash = "sha256-2GveG5leB7QvSX/IC5/eFHetBTVjUfd0k6PlndkHVpk=";
  };

  cursorTorchManifest = pkgs.fetchurl {
    url = "${cursorTorchRelease}/manifest.json";
    hash = "sha256-OS8A9K46NsHbqJL5KkDg/6E6CqMIWniL03ar6ZIArKo=";
  };

  cursorTorchStyles = pkgs.fetchurl {
    url = "${cursorTorchRelease}/styles.css";
    hash = "sha256-5u8cGOt6tJcTexLwTRXxUjjzo2q2GFdPV81PB6KCY80=";
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
        cursorTorchPlugin = "${obs}/plugins/cursor-torch";

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

            # Cursor Torch plugin files (immutable — from Nix store)
            "${cursorTorchPlugin}/main.js".source = cursorTorchMainJs;
            "${cursorTorchPlugin}/manifest.json".source = cursorTorchManifest;
            "${cursorTorchPlugin}/styles.css".source = cursorTorchStyles;

            # Holographic Palette — CSS snippet for Encore theme
            "${obs}/snippets/holographic-palette.css".text = ''
              body.theme-dark {
                /* ═══════════════════════════════════════════
                   Holographic Palette — Encore dark theme
                   Source: ~/Workspace/holographic-palette.md
                   ═══════════════════════════════════════════ */

                /* ── Neutral Ramp (Encore grey variables) ── */
                /* N1 #1f1f1f — Deepest backgrounds */
                --grey-900-rgb: 31, 31, 31;
                --grey-875-rgb: 31, 31, 31;
                --grey-850-rgb: 31, 31, 31;
                /* N2 #323232 — Secondary fills, borders, inactives */
                --grey-800-rgb: 50, 50, 50;
                --grey-700-rgb: 50, 50, 50;
                --grey-600-rgb: 50, 50, 50;
                /* N3 #6b6b6b — Secondary text, comments */
                --grey-500-rgb: 107, 107, 107;
                --grey-400-rgb: 107, 107, 107;
                /* N4 #8f8f8f — Dim highlights, faint text */
                --grey-350-rgb: 143, 143, 143;
                --grey-300-rgb: 143, 143, 143;
                /* N5 #cfd3db — Primary text */
                --grey-200-rgb: 207, 211, 219;
                --grey-100-rgb: 207, 211, 219;
                --grey-50-rgb: 207, 211, 219;

                /* ── Obsidian Base Colors ── */
                --color-base-00: #1f1f1f;
                --color-base-05: #1f1f1f;
                --color-base-10: #1f1f1f;
                --color-base-20: #323232;
                --color-base-25: #323232;
                --color-base-30: #323232;
                --color-base-35: #6b6b6b;
                --color-base-40: #6b6b6b;
                --color-base-50: #8f8f8f;
                --color-base-60: #8f8f8f;
                --color-base-70: #cfd3db;
                --color-base-100: #cfd3db;

                /* ── Accent — Soft Bright Blue ── */
                /* A2 #5aa0c1 — status quo, active borders, cursor */
                --accent-h: 199;
                --accent-s: 53%;
                --accent-l: 56%;

                /* ── Extended Colors ── */
                /* Blue (A1)       #3c728c — ANSI normal */
                --color-blue: #3c728c;
                --color-blue-rgb: 60, 114, 140;
                /* Green (G1)      #5d7849 — ANSI normal, desaturated */
                --color-green: #5d7849;
                --color-green-rgb: 93, 120, 73;
                /* Red (R1)        #a05045 — ANSI normal, desaturated */
                --color-red: #a05045;
                --color-red-rgb: 160, 80, 69;
                /* Yellow (Y1)     #c38c00 — muted warm */
                --color-yellow: #c38c00;
                --color-yellow-rgb: 195, 140, 0;
                /* Magenta (M1)    #6a5a66 — faint purple warm gray */
                --color-purple: #6a5a66;
                --color-purple-rgb: 106, 90, 102;
                /* Pink (M2)       #887280 — brighter magenta */
                --color-pink: #887280;
                --color-pink-rgb: 136, 114, 128;
                /* Cyan (C1)       #4a6666 — faint teal warm gray */
                --color-cyan: #4a6666;
                --color-cyan-rgb: 74, 102, 102;
                /* Orange — blended */
                --color-orange: #a07030;
                --color-orange-rgb: 160, 112, 48;

                /* ── Background Colors ── */
                --background-primary: #1f1f1f;
                --background-primary-alt: #323232;
                --background-secondary: #1f1f1f;
                --background-secondary-alt: #323232;
                --background-modifier-hover: rgba(90, 160, 193, 0.10);
                --background-modifier-active-hover: rgba(90, 160, 193, 0.15);
                --background-modifier-border: #323232;
                --background-modifier-border-hover: #5aa0c1;
                --background-modifier-border-focus: #6acfff;
                /* Alert variants — full saturation */
                --background-modifier-error: #c31700;        /* R1_alert */
                --background-modifier-error-rgb: 195, 23, 0;
                --background-modifier-error-hover: #ff211b;  /* R2_alert */
                --background-modifier-success: #74e91c;      /* G2_alert */
                --background-modifier-success-rgb: 116, 233, 28;
                --background-modifier-message: rgba(31, 31, 31, 0.92);
                --background-modifier-form-field: rgba(255, 255, 255, 0.03);

                /* ── Text Colors ── */
                --text-normal: #cfd3db;         /* N5 */
                --text-muted: #6b6b6b;           /* N3 */
                --text-faint: #8f8f8f;           /* N4 */
                --text-accent: #5aa0c1;          /* A2 */
                --text-accent-hover: #6acfff;    /* A3 */
                --text-error: #c31700;           /* R1_alert */
                --text-warning: #ffc42d;         /* Y2 bright */
                --text-success: #6da050;         /* G2 */
                --text-selection: rgba(90, 160, 193, 0.30);
                --text-highlight-bg: rgba(106, 207, 255, 0.15);
                --text-highlight-bg-active: rgba(106, 207, 255, 0.30);
                --text-on-accent: #1f1f1f;
                --text-on-accent-inverted: #cfd3db;

                /* ── Heading / Title Colors ── */
                --inline-title-color: #cfd3db;       /* N5 — file title at top of note */
                --h1-color: #cfd3db;
                --h2-color: #cfd3db;
                --h3-color: #cfd3db;
                --h4-color: #cfd3db;
                --h5-color: #cfd3db;
                --h6-color: #cfd3db;

                /* ── Interactive Colors ── */
                --interactive-normal: #323232;        /* N2 */
                --interactive-hover: rgba(90, 160, 193, 0.12);
                --interactive-accent: #5aa0c1;        /* A2 */
                --interactive-accent-hsl: var(--accent-h), var(--accent-s), var(--accent-l);
                --interactive-accent-hover: #6acfff;  /* A3 */
                --interactive-success: #5d7849;       /* G1 */

                /* ── Additional UI ── */
                --caret-color: #5aa0c1;               /* A2 — cursor */
                --link-color: #5aa0c1;
                --link-color-hover: #6acfff;
                --link-unresolved-color: #3c728c;     /* A1 — dimmer for broken links */
                --nav-item-color-hover: #cfd3db;
                --nav-item-color-active: #cfd3db;
                --nav-item-background-hover: rgba(90, 160, 193, 0.10);
                --nav-item-background-active: rgba(90, 160, 193, 0.18);
                --tab-text-color-active: #cfd3db;
                --tab-text-color-focused-active: #cfd3db;
                --tab-divider-color: #323232;
                --icon-color: #6b6b6b;
                --icon-color-hover: #cfd3db;
                --icon-color-active: #5aa0c1;
                --icon-color-focused: #5aa0c1;
                --titlebar-background: #1f1f1f;
                --titlebar-background-focused: #1f1f1f;
                --ribbon-background: #1f1f1f;
                --sidebar-background: #1f1f1f;
                --workspace-background: #1f1f1f;

                /* Encore: update base colors after grey overrides */
                --color-base-00: rgb(var(--grey-900-rgb));
                --color-base-05: rgb(var(--grey-875-rgb));
                --color-base-10: rgb(var(--grey-850-rgb));
                --color-base-20: rgb(var(--grey-800-rgb));
                --color-base-25: rgb(var(--grey-700-rgb));
                --color-base-30: rgb(var(--grey-600-rgb));
                --color-base-35: rgb(var(--grey-500-rgb));
                --color-base-40: rgb(var(--grey-400-rgb));
                --color-base-50: rgb(var(--grey-350-rgb));
                --color-base-60: rgb(var(--grey-300-rgb));
                --color-base-70: rgb(var(--grey-200-rgb));
                --color-base-100: rgb(var(--grey-100-rgb));
              }
            '';
          };
      }
    )
  ];
}
