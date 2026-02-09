{
  # User Configuration
  username = "player00"; # Your username (auto-set with install.sh, live-install.sh, rebuild)
  desktop = "hyprland"; # Options: hyprland, i3-gaps, gnome, plasma6
  terminal = "alacritty"; # Options: kitty, alacritty, ghostty
  editor = "vscode"; # Options: nixvim, vscode, helix, doom-emacs, nvchad, neovim
  browser = "chromium"; # Options: firefox, floorp, zen, chromium
  tuiFileManager = "yazi"; # Options: yazi, lf
  sddmTheme = "hyprland_kath"; # Options: astronaut, black_hole, purple_leaves, jake_the_dog, hyprland_kath
  defaultWallpaper = "moon.webp"; # to change wallpaper: SUPER + SHIFT + W
  hyprlockWallpaper = "dark-forest.jpg"; # See modules/themes/wallpapers for options
  shell = "bash"; # Options: zsh, bash
  games = false; # Whether to enable the gaming module

  # Hardware Configuration
  videoDriver = "nvidia"; # CRITICAL: Choose your GPU driver (nvidia, amdgpu, intel)
  hostname = "Station-Alpha"; # Your system hostname

  # Localization
  clock24h = true; # 24H or 12H clock in waybar
  locale = "en_GB.UTF-8"; # System locale
  timezone = "Chicago/US"; # Your timezone
  kbdLayout = "us"; # Keyboard layout
  kbdVariant = ""; # Keyboard variant (can be empty)
  consoleKeymap = "us"; # TTY keymap
}
