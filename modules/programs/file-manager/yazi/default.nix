{ pkgs, lib, ... }:
let
  initLua = import ./plugins { inherit lib; };
in
{
  home-manager.sharedModules = [
    (_: {
      home.packages = with pkgs; [ trash-cli ];
      programs.yazi = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        shellWrapperName = "yy"; # Silence stateVersion < 26.05 warning
        initLua = initLua;
        plugins = {
          compress = pkgs.yaziPlugins.compress;
          chmod = pkgs.yaziPlugins.chmod;
          recycle-bin = pkgs.yaziPlugins.recycle-bin;
        };
        settings = {
          mgr = {
            show_hidden = true;
            show_symlink = true;
            sort_dir_first = true;
            linemode = "size";
            ratio = [ 1 3 4 ];
          };
          preview = {
            tab_size = 4;
            image_filter = "triangle";
            max_width = 1920;
            max_height = 1080;
            image_quality = 90;
          };
        };
        keymap = {
          mgr.prepend_keymap = [
            {
              on = [ "R" "b" ];
              run = "plugin recycle-bin";
              desc = "Open Recycle Bin Menu";
            }
            {
              on = [ "R" "x" ];
              run = "plugin chmod";
              desc = "Chmod on selected files";
            }
            {
              on = [ "<S-c>" "a" ];
              run = "plugin compress";
              desc = "Compress selected files";
            }
            {
              on = [ "<S-c>" "p" ];
              run = "plugin compress -p";
              desc = "Compress selected files (password)";
            }
            {
              on = [ "<S-c>" "h" ];
              run = "plugin compress -ph";
              desc = "Compress selected files (password+header)";
            }
            {
              on = [ "<S-c>" "l" ];
              run = "plugin compress -l";
              desc = "Compress selected files (compression level)";
            }
            {
              on = [ "<S-c>" "u" ];
              run = "plugin compress -phl";
              desc = "Compress selected files (password+header+level)";
            }
            {
              on = "q";
              run = "close";
            }
            {
              on = [ "e" ];
              run = "open";
            }
            {
              on = [ "g" "D" ];
              run = "cd ~/Documents";
            }
            {
              on = [ "g" "p" ];
              run = "cd /mnt/work/Projects";
            }
            {
              on = [ "g" "P" ];
              run = "cd /mnt/games/Windows/Pirate";
            }
          ];
        };
        theme = {
          mgr = {
            border_symbol = " ";
          };
          status = {
            separator_open = "";
            separator_close = "";
          };
        };
      };
    })
  ];
}
