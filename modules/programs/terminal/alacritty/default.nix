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
                background = "#1a1a1a";
                foreground = "#e5d6c6";
                dim_foreground = "#7f6b5d";
                bright_foreground = "#f2e6d8";
              };

              cursor = {
                text = "#1a1a1a";
                cursor = "#ff884d";
              };

              vi_mode_cursor = {
                text = "#1a1a1a";
                cursor = "#C67E4F";
              };

              search = {
                matches = {
                  foreground = "#1a1a1a";
                  background = "#ff884d";
                };
                focused_match = {
                  foreground = "#1a1a1a";
                  background = "#ffb366";
                };
              };

              footer_bar = {
                foreground = "#1a1a1a";
                background = "#a98274";
              };

              hints = {
                start = {
                  foreground = "#1a1a1a";
                  background = "#d9a066";
                };
                end = {
                  foreground = "#1a1a1a";
                  background = "#a98274";
                };
              };

              selection = {
                text = "#1a1a1a";
                background = "#ffbb99";
              };

              normal = {
                black = "#1a1a1a";
                red = "#d45d4c";
                green = "#9e8f70";
                yellow = "#d9a066";
                blue = "#6c5b4c";
                magenta = "#b57276";
                cyan = "#a98274";
                white = "#d1c0b0";
              };

              bright = {
                black = "#2a2a2a";
                red = "#e87461";
                green = "#b39c7c";
                yellow = "#e3b97f";
                blue = "#7f6b5d";
                magenta = "#c6898c";
                cyan = "#ba9486";
                white = "#f2e6d8";
              };

              indexed_colors = [
                {
                  index = 16;
                  color = "#d9a066";
                }
                {
                  index = 17;
                  color = "#ff884d";
                }
              ];
            };

            font.size = 12.0;

            window = {
              decorations = "full";
              dynamic_padding = false;
              startup_mode = "Maximized";
              opacity = 0.8;

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
