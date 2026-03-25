{
  # User Configuration
  username = "player00"; # Your username (auto-set with install.sh, live-install.sh, rebuild)
  desktop = "hyprland"; # Options: hyprland, i3-gaps, gnome
  terminal = "alacritty"; # Options: kitty, alacritty, ghostty
  editor = "vscode"; # Options: vscode, helix
  browser = "chromium"; # Options: firefox, floorp, zen
  tuiFileManager = "yazi"; # Options: yazi, lf
  sddmTheme = "black_hole"; # Options: astronaut, black_hole, purple_leaves, jake_the_dog, hyprland_kath
  defaultWallpaper = "kurzgesagt.webp"; # to change wallpaper: SUPER + SHIFT + W
  hyprlockWallpaper = "evening-sky.webp"; # See modules/themes/wallpapers for options
  shell = "bash"; # Options: zsh, bash
  games = false; # Whether to enable the gaming module
  bluetooth = false; # Disable bluetooth to save CPU (radio polling)

  # Hardware Configuration
  videoDriver = "intel"; # CRITICAL: Choose your GPU driver (nvidia, amdgpu, intel)
  hostname = "Subrelay-01"; # Your system hostname

  # Localization
  clock24h = true; # 24H or 12H clock in waybar
  locale = "en_GB.UTF-8"; # System locale
  timezone = "Chicago/US"; # Your timezone
  kbdLayout = "us"; # Keyboard layout
  kbdVariant = ""; # Keyboard variant (can be empty)
  consoleKeymap = "us"; # TTY keymap
}
