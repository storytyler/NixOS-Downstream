{
  inputs,
  lib,
  ...
}:
let
  # ═══════════════════════════════════════════════════════
  # Holographic Palette — Spicetify color override
  # Source: ~/Workspace/holographic-palette.md
  # Convention: matches obsidian.nix holographic-palette.css
  #
  # Method: crudini --set overrides into catppuccin/mocha
  # so the theme's user.css + theme.js (accent picker, surface
  # layers) still work — we just swap the color space.
  # ═══════════════════════════════════════════════════════

  # ── 18 standard spicetify keys → holographic ──
  holoStandard = {
    text = "cfd3db"; # N5 — primary text
    subtext = "6b6b6b"; # N3 — secondary text
    main = "1f1f1f"; # N1 — main field bg
    main-elevated = "323232"; # N2 — elevated bg
    highlight = "323232"; # N2 — hover bg
    highlight-elevated = "6b6b6b"; # N3 — elevated hover bg
    sidebar = "1f1f1f"; # N1 — sidebar bg
    player = "323232"; # N2 — player bar bg
    card = "323232"; # N2 — card bg
    shadow = "1f1f1f"; # N1 — drop shadow depth
    selected-row = "5aa0c1"; # A2 — accent-blue selected row
    button = "6da050"; # G2 — play button (terminal-safe green)
    button-active = "74e91c"; # G2_alert — actively playing (full-saturation)
    button-disabled = "323232"; # N2 — disabled control bg
    tab-active = "3c728c"; # A1 — active nav tab
    notification = "5aa0c1"; # A2 — status-quo blue toast
    notification-error = "c31700"; # R1_alert — full-saturation danger red
    misc = "6b6b6b"; # N3 — misc UI
  };

  # ── 22 catppuccin extras (user.css + theme.js) → holographic ──
  holoExtras = {
    # Neutral ramp (crust→overlay layers map to N1→N4 variants)
    crust = "1a1a1a"; # slightly deeper than N1
    mantle = "1f1f1f"; # N1
    base = "1f1f1f"; # N1
    surface0 = "282828"; # between N1 and N2
    surface1 = "323232"; # N2
    surface2 = "3d3d3d"; # slightly brighter than N2
    overlay0 = "4a4a4a"; # between N2 and N3
    overlay1 = "6b6b6b"; # N3
    overlay2 = "8f8f8f"; # N4
    # Accent picker rows (theme.js: rosewater→lavender)
    rosewater = "cfd3db"; # N5
    flamingo = "887280"; # M2 (muted pink)
    pink = "887280"; # M2
    maroon = "a05045"; # R1 (desaturated red)
    red = "c31700"; # R1_alert
    peach = "c38c00"; # Y1 (muted warm)
    yellow = "ffc42d"; # Y2 (bright warm)
    green = "6da050"; # G2
    teal = "4a6666"; # C1 (near-neutral cyan)
    sapphire = "3c728c"; # A1 (dark blue)
    blue = "5aa0c1"; # A2 (mid blue)
    sky = "6acfff"; # A3 (bright blue)
    mauve = "6a5a66"; # M1 (faint purple warm gray)
    lavender = "887280"; # M2
  };

  holoColors = holoStandard // holoExtras;
in
{
  # allow spotify to be installed if you don't have unfree enabled already
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "spotify"
    ];

  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};

        setCommands = lib.concatStringsSep "\n" (
          lib.mapAttrsToList (
            key: val: "crudini --set Themes/catppuccin/color.ini mocha ${key} ${val}"
          ) holoColors
        );
      in
      {
        # import the flake's module for your system
        imports = [ inputs.spicetify-nix.homeManagerModules.default ];

        # configure spicetify :)
        programs.spicetify = {
          enable = true;
          # windowManagerPatch = config.programs.hyprland.enable;

          # Keep catppuccin as BASE theme (layout/CSS/JS infra) but override
          # ALL 40 key-value pairs in the mocha section to the holographic palette.
          # extraCommands runs after color.ini is copied; crudini --set overwrites
          # individual keys without touching the other 3 flavor sections.
          colorScheme = "mocha";

          extraCommands = ''
            # ═══════════════════════════════════════════════════════
            # Holographic Palette — override catppuccin/mocha colors
            # Source: ~/Workspace/holographic-palette.md
            # Convention: matches obsidian.nix holographic-palette.css
            # ═══════════════════════════════════════════════════════
            ${setCommands}
          '';

          theme = spicePkgs.themes.catppuccin // {
            additionalCss = ''
              /* ═══════════════════════════════════════════
                 Holographic Palette — Glass Tints
                 Source: ~/Workspace/holographic-palette.md
                 Adheres to obsidian.nix holographic-palette.css convention.
                 ═══════════════════════════════════════════ */

              /* T1 #6a798418 — blue-gray glass, global tint */
              .Root__main-view-overlay {
                background-color: rgba(106, 121, 132, 0.09) !important;
              }

              /* T3 #98d1ff10 — light blue, now-playing bar glow */
              .main-nowPlayingBar-nowPlayingBar {
                box-shadow: inset 0 1px 0 rgba(152, 209, 255, 0.06),
                            0 -2px 16px rgba(106, 207, 255, 0.04);
              }
            '';
          };

          enabledExtensions = with spicePkgs.extensions; [
            adblock
            shuffle # shuffle+ (special characters are sanitized out of ext names)
            keyboardShortcut # vimium-like navigation
            copyLyrics # copy lyrics with selection
            # autoVolume
            # showQueueDuration
            # fullAppDisplay
            # hidePodcasts
          ];
          # enabledCustomApps = with spicePkgs.apps; [
          #   reddit
          #   lyricsPlus
          #   marketplace
          #   localFiles
          #   ncsVisualizer
          # ];
        };
      }
    )
  ];
}
