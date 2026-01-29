{
  lib,
  pkgs,
  ...
}:
{
  home-manager.sharedModules = [
    (_: {
      programs.ghostty = {
        enable = true;

        # Use Ghostty from nixpkgs (stable and tested)
        package = pkgs.ghostty;

        # Systemd integration for faster startup and better performance
        systemd = {
          enable = lib.mkDefault true;
        };

        # Shell integration (bash, fish, zsh automatically enabled based on config)
        enableBashIntegration = lib.mkDefault true;
        enableZshIntegration = lib.mkDefault true;
        enableFishIntegration = lib.mkDefault true;

        # Configuration settings
        # See: https://ghostty.org/docs/config/reference
        settings = {
          # Theme - matches your existing Catppuccin theme
          theme = "catppuccin-mocha";

          # Font settings
          font-size = 12;
          font-family = "monospace";

          # Cursor
          cursor-style = "block";
          cursor-style-blink = false;

          # Window
          window-decoration = false;
          window-padding-x = 0;
          window-padding-y = 0;
          window-width = 100;
          window-height = 30;
          window-theme = "dark";

          # Scrollback
          scrollback-limit = 10000;

          # Shell
          shell-integration = "detect";

          # Clipboard
          confirm-close-surface = false;

          # Keybindings - custom keybinds
          keybind = [
            # Clear screen with Ctrl+L
            "ctrl+l=clear"
            # Copy with Ctrl+W
            "ctrl+w=copy"
            # Paste with Ctrl+Y
            "ctrl+y=paste"
            # New instance with Super+Return
            "super+return=new_window"
          ];
        };

        # Define custom Catppuccin Mocha theme
        themes = {
          catppuccin-mocha = {
            palette = [
              "0=#45475a"
              "1=#f38ba8"
              "2=#a6e3a1"
              "3=#f9e2af"
              "4=#89b4fa"
              "5=#f5c2e7"
              "6=#94e2d5"
              "7=#bac2de"
              "8=#585b70"
              "9=#f38ba8"
              "10=#a6e3a1"
              "11=#f9e2af"
              "12=#89b4fa"
              "13=#f5c2e7"
              "14=#94e2d5"
              "15=#a6adc8"
            ];
            background = "#1e1e2e";
            foreground = "#cdd6f4";
            cursor-color = "#f5e0dc";
            selection-background = "#353749";
            selection-foreground = "#cdd6f4";
          };
        };

        # Optional: Install Vim syntax highlighting
        installVimSyntax = lib.mkDefault true;

        # Optional: Install bat syntax highlighting
        installBatSyntax = lib.mkDefault true;

        # Optional: Clear default keybinds if you want full custom control
        clearDefaultKeybinds = false;
      };
    })
  ];
}
