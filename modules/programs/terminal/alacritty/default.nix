{
  lib,
  pkgs,
  ...
}:
{
  home-manager.sharedModules = [
    (_: {
      programs.alacritty =
        let
          inherit (lib) getExe;
        in
        {
          enable = true;
          settings = {
            colors = {
              primary = {
                background = "#1f1f1f";
                foreground = "#cfd3db";
              };

              cursor = {
                text = "#1f1f1f";
                cursor = "#5aa0c1";
              };

              vi_mode_cursor = {
                text = "#1f1f1f";
                cursor = "#5aa0c1";
              };

              selection = {
                text = "#1f1f1f";
                background = "#3c728c";
              };

              normal = {
                black = "#1f1f1f";
                red = "#a05045";
                green = "#5d7849";
                yellow = "#c38c00";
                blue = "#3c728c";
                magenta = "#6a5a66";
                cyan = "#4a6666";
                white = "#6b6b6b";
              };

              bright = {
                black = "#323232";
                red = "#d06050";
                green = "#6da050";
                yellow = "#ffc42d";
                blue = "#5aa0c1";
                magenta = "#887280";
                cyan = "#688880";
                white = "#cfd3db";
              };
            };

            font.size = 12.0;

            window = {
              decorations = "full";
              dynamic_padding = false;
              startup_mode = "Maximized";
              opacity = 0.2;

              padding.x = 0;
              padding.y = 0;
              dimensions.columns = 100;
              dimensions.lines = 30;
              class.general = "Alacritty";
              class.instance = "Alacritty";
            };

            terminal.shell = {
              program = "${getExe pkgs.zsh}";
            };

            keyboard.bindings = [
              {
                chars = "cd $(${getExe pkgs.fd} . /mnt/work /mnt/work/dev/ /run /run/current-system ~/.local/ ~/ --max-depth 2 | fzf)\r";
                key = "F";
                mods = "Control";
              }
              {
                chars = "tmux-sessionizer\r";
                key = "T";
                mods = "Control";
              }
              {
                action = "Paste";
                key = "Y";
                mods = "Control";
              }
              {
                action = "Copy";
                key = "W";
                mods = "Alt";
              }
              {
                action = "SpawnNewInstance";
                key = "Return";
                mods = "Super|Shift";
              }
            ];

            selection = {
              save_to_clipboard = false;
              semantic_escape_chars = ",│`|:\"' ()[]{}<>\t";
            };

            scrolling = {
              history = 10000;
              multiplier = 3;
            };
          };
        };
    })
  ];
}
