{
  # User Configuration
  username = "player00"; # Your username (auto-set with install.sh, live-install.sh, rebuild)
  desktop = "hyprland"; # Options: hyprland, gnome
  bar = "hyprpanel"; # Options: waybar, hyprpanel, noctalia-shell, caelestia-shell
  waybarTheme = "stylish"; # Options: stylish, minimal (only applies when bar = "waybar")
  terminal = "alacritty"; # Options: kitty, alacritty, ghostty
  editor = "vscode"; # Options: vscode, helix
  browser = "zen"; # Options: firefox, floorp, zen, chromium
  tuiFileManager = "yazi"; # Options: yazi, lf
  sddmTheme = "hyprland_kath"; # Options: astronaut, black_hole, purple_leaves, jake_the_dog, hyprland_kath
  defaultWallpaper = "EmberNAsh.png"; # to change wallpaper: SUPER + SHIFT + W
  hyprlockWallpaper = "door.png"; # See modules/themes/wallpapers for options
  shell = "bash"; # Options: zsh, bash
  games = true; # Whether to enable the gaming module
  bluetoothSupport = true; # Whether your motherboard supports bluetooth
  batterySupport = false; # Whether device has a battery (laptop)

  # Hardware Configuration
  videoDriver = "nvidia"; # CRITICAL: Choose your GPU driver (nvidia, amdgpu, intel)
  hostname = "Station-Alpha"; # Your system hostname

  # Localization
  clock24h = true; # 24H or 12H clock in waybar
  locale = "en_GB.UTF-8"; # System locale
  timezone = "America/Chicago"; # Your timezone
  kbdLayout = "us"; # Keyboard layout
  kbdVariant = ""; # Keyboard variant (can be empty)
  consoleKeymap = "us"; # TTY keymap

  # Home Assistant location (used by met weather integration)
  latitude = 42.057856;
  longitude = -91.574895;
  elevation = 265;
}
