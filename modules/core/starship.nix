{ ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.starship = {
        enable = true;
        settings = {
          add_newline = false;
          scan_timeout = 10;
          format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$python$nix_shell$character";
          directory = {
            truncate_to_repo = false;
            read_only = " ro";
            style = "#8f8f8f";
          };
          /*
               style_user = "green bold";
               style_root = "red bold";
               format = "[$user]($style)";
               disabled = false;
               show_always = true;
             };
          */
          character = {
            success_symbol = "[❯](#3c728c)";
            error_symbol = "[❯](#d06050)";
            vimcmd_symbol = "[❮](#8f8f8f)";
          };
          git_branch = {
            format = "[$branch]($style)";
            symbol = "git ";
            style = "#3c728c";
          };
          git_status = {
            format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](#ffc42d) ($ahead_behind$stashed)]($style)";
            style = "#3c728c";
            conflicted = "​";
            untracked = "​";
            modified = "​";
            staged = "​";
            renamed = "​";
            deleted = "​";
            stashed = "≡";
          };
          git_state = {
            format = ''\([$state( $progress_current/$progress_total)]($style)\) '';
            style = "#6b6b6b";
          };
          cmd_duration = {
            format = "[$duration]($style) ";
            style = "#3c728c";
          };
          aws = {
            symbol = "aws ";
          };
          azure = {
            symbol = "az ";
          };
          bun = {
            symbol = "bun ";
          };

          cmake = {
            symbol = "cmake ";
          };
          deno = {
            symbol = "deno ";
          };
          docker_context = {
            symbol = "docker ";
          };
          golang = {
            symbol = "go ";
          };
          # hostname = {
          #   ssh_only = false;
          #   format = " on [$hostname](bold red)\n";
          #   disabled = false;
          # };
          lua = {
            symbol = "lua ";
          };
          nodejs = {
            symbol = "nodejs ";
          };
          memory_usage = {
            symbol = "memory ";
          };
          nim = {
            symbol = "nim ";
          };

          nix_shell = {
            symbol = "❄️ ";
            format = "[$symbol]($style)";
          };

          shell = {
            disabled = false;
            style = "cyan";
            bash_indicator = "";
            powershell_indicator = "";
          };

          os.symbols = {
            Alpaquita = "alq ";
            Alpine = "alp ";
            Amazon = "amz ";
            Android = "andr ";
            Arch = "rch ";
            Artix = "atx ";
            CentOS = "cent ";
            Debian = "deb ";
            DragonFly = "dfbsd ";
            Emscripten = "emsc ";
            EndeavourOS = "ndev ";
            Fedora = "fed ";
            FreeBSD = "fbsd ";
            Garuda = "garu ";
            Gentoo = "gent ";
            HardenedBSD = "hbsd ";
            Illumos = "lum ";
            Linux = "lnx ";
            Mabox = "mbox ";
            Macos = "mac ";
            Manjaro = "mjo ";
            Mariner = "mrn ";
            MidnightBSD = "mid ";
            Mint = "mint ";
            NetBSD = "nbsd ";
            NixOS = "nix ";
            OpenBSD = "obsd ";
            OpenCloudOS = "ocos ";
            openEuler = "oeul ";
            openSUSE = "osuse ";
            OracleLinux = "orac ";
            Pop = "pop ";
            Raspbian = "rasp ";
            Redhat = "rhl ";
            RedHatEnterprise = "rhel ";
            Redox = "redox ";
            Solus = "sol ";
            SUSE = "suse ";
            Ubuntu = "ubnt ";
            Unknown = "unk ";
            Windows = "win ";
          };
          package = {
            symbol = "pkg ";
          };
          purescript = {
            symbol = "purs ";
          };
          python = {
            format = "[$virtualenv]($style) ";
            style = "bright-black";
            symbol = "py ";
          };
          rust = {
            symbol = "rs ";
          };
          status = {
            symbol = "[x](bold red) ";
          };
          sudo = {
            symbol = "sudo ";
          };
          terraform = {
            symbol = "terraform ";
          };
          zig = {
            symbol = "zig ";
          };
        };
      };
    })
  ];
}
