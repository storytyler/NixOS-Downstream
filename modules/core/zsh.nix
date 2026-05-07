{ self, pkgs, ... }:
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        programs.zsh = {
          enable = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          syntaxHighlighting.styles = {
            "command" = "fg=#E07A5F";
            "builtin" = "fg=#E07A5F";
            "alias" = "fg=#E07A5F";
            "function" = "fg=#E07A5F";
            "unknown-token" = "fg=#D1495B";
            "path" = "fg=#d9a066";
            "single-quoted-argument" = "fg=#e0a040";
            "double-quoted-argument" = "fg=#e0a040";
          };
          enableCompletion = true;
          history.size = 100000;
          history.path = "\${XDG_DATA_HOME}/zsh/history";
          dotDir = "${config.xdg.configHome}/zsh";
          oh-my-zsh = {
            enable = true;
            plugins = [
              "git"
              "gitignore"
              "z"
            ];
          };
          initContent = ''
            # Syntax Highlighting — Ember & Ash overrides
            typeset -A ZSH_HIGHLIGHT_STYLES
            ZSH_HIGHLIGHT_STYLES[command]="fg=#E07A5F"
            ZSH_HIGHLIGHT_STYLES[builtin]="fg=#E07A5F"
            ZSH_HIGHLIGHT_STYLES[alias]="fg=#E07A5F"
            ZSH_HIGHLIGHT_STYLES[function]="fg=#E07A5F"
            ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=#D1495B"
            ZSH_HIGHLIGHT_STYLES[path]="fg=#d9a066"
            ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=#e0a040"
            ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=#e0a040"

            # Starship Prompt
            if command -v starship &>/dev/null; then
              eval "$(starship init zsh)"
            fi

            # Direnv Hook
            if command -v direnv &>/dev/null; then
              eval "$(direnv hook zsh)"
            fi

            # Key Bindings
            # bindkey -s ^t "tmux-sessionizer\n"
            # bindkey '^f' "cd $(${pkgs.fd}/bin/fd . /mnt/work /mnt/work/Projects/ /run/current-system ~/ --max-depth 1 | fzf)\n"
            bindkey '^a' beginning-of-line
            bindkey '^e' end-of-line

            # options
            unsetopt menu_complete
            unsetopt flowcontrol

            setopt prompt_subst
            setopt always_to_end
            setopt append_history
            setopt auto_menu
            setopt complete_in_word
            setopt extended_history
            setopt hist_expire_dups_first
            setopt hist_ignore_dups
            setopt hist_ignore_space
            setopt hist_verify
            setopt inc_append_history
            setopt share_history
          '';
          envExtra = ''
            # Autosuggestion color — muted orange, visible against dark background
            export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#b87a4f"

            # Defaults
            export XMONAD_CONFIG_DIR="''${XDG_CONFIG_HOME:-$HOME/.config}/xmonad" # xmonad.hs is expected to stay here
            export XMONAD_DATA_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/xmonad"
            export XMONAD_CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/xmonad"

            export FZF_DEFAULT_OPTS=" \
            --color=bg+:#3A2F2B,bg:#1A1513,spinner:#ff915e,hl:#D1495B \
            --color=fg:#D8C9B6,header:#D1495B,info:#C67E4F,pointer:#E07A5F \
            --color=marker:#ff915e,fg+:#F4EDE4,prompt:#C67E4F,hl+:#D1495B"
          '';
          shellGlobalAliases = {
            UUID = "$(uuidgen | tr -d \\n)";
            G = "| grep";
          };
          shellAliases = {
            lf = ''
                {
                  tmp="$(mktemp)"
                  # `command` is needed in case `lfcd` is aliased to `lf`
                  command lf -last-dir-path="$tmp" "$@"
                  if [ -f "$tmp" ]; then
                      dir="$(cat "$tmp")"
                      rm -f "$tmp"
                      if [ -d "$dir" ]; then
                          if [ "$dir" != "$(pwd)" ]; then
                              cd "$dir"
                          fi
                      fi
                  fi
              }
            '';
            fnew = ''
              if [ -d "$2" ]; then
                echo "Directory \"$2\" already exists!"
                return 1
              fi
              nix flake new $2 --template ${self}/dev-shells#$1
              cd $2
              direnv allow
            '';

            finit = ''
              nix flake init --template ${self}/dev-shells#$1
              direnv allow
            '';
            cdown = ''
              N=$1
              while [[ $((--N)) -gt  0 ]]
                do
                  echo "$N" |  figlet -c | lolcat &&  sleep 1
              done
            '';
            cls = "clear";
            tml = "tmux list-sessions";
            tma = "tmux attach";
            tms = "tmux attach -t $(tmux ls -F '#{session_name}: #{session_path} (#{session_windows} windows)' | fzf | cut -d: -f1)";
            l = "${pkgs.eza}/bin/eza -lh  --icons=auto"; # long list
            ls = "${pkgs.eza}/bin/eza -1   --icons=auto"; # short list
            ll = "${pkgs.eza}/bin/eza -lha --icons=auto --sort=name --group-directories-first"; # long list all
            ld = "${pkgs.eza}/bin/eza -lhD --icons=auto"; # long list dirs
            tree = "${pkgs.eza}/bin/eza --icons=auto --tree"; # dir tree
            vc = "code --disable-gpu"; # gui code editor
            nv = "nvim";
            nf = "${pkgs.microfetch}/bin/microfetch";
            ff = "fastfetch";
            cp = "cp -iv";
            mv = "mv -iv";
            rm = "rm -vI";
            bc = "bc -ql";
            mkd = "mkdir -pv";
            tp = "${pkgs.trash-cli}/bin/trash-put";
            tpr = "${pkgs.trash-cli}/bin/trash-restore";
            grep = "grep --color=always";
            pokemon = "pokego --random 1-8 --no-title";

            # Nixos
            list-gens = "nixos-rebuild list-generations";
            find-store-path = ''function { nix-shell -p $1 --command "nix eval -f \"<nixpkgs>\" --raw $1" }'';
            update-input = "nix flake update $@";
            sysup = "nix flake update --flake ~/NixOS && rebuild";

            # Directory Shortcuts.
            dots = "cd ~/NixOS/";
            games = "cd /mnt/games/";
            work = "cd /mnt/work/";
            media = "cd /mnt/work/media/";
            projects = "cd /mnt/work/Projects/";
            proj = "cd /mnt/work/Projects/";
            dev = "cd /mnt/work/Projects/";
            # dev = "cd /mnt/work/dev/";
            # nixdir = "cd /mnt/work/dev/nix/";
            # cppdir = "cd /mnt/work/dev/C++/";
            # zigdir = "cd /mnt/work/dev/Zig/";
            # csdir = "cd /mnt/work/dev/C#/";
            # rustdir = "cd /mnt/work/dev/Rust/";
            # pydir = "cd /mnt/work/dev/Python/";
            # javadir = "cd /mnt/work/dev/Java/";
            # luadir = "cd /mnt/work/dev/lua/";
            # webdir = "cd /mnt/work/dev/Website/";
          };
        };
      }
    )
  ];
}
