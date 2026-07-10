{ pkgs, ... }:
let
  gtkThemeName = "gruvbox-dark";
  kvantumThemeName = "Gruvbox-Dark-Brown";
in
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        home.packages = [ pkgs.gruvbox-kvantum ];

        gtk = {
          enable = true;
          gtk2.force = true;
          theme = {
            name = gtkThemeName;
            package = pkgs.gruvbox-dark-gtk;
          };
          iconTheme = {
            package = pkgs.gruvbox-plus-icons;
            name = "Gruvbox-Plus-Dark";
          };
          gtk3.extraConfig = {
            "gtk-application-prefer-dark-theme" = "1";
          };
          gtk4.extraConfig = {
            "gtk-application-prefer-dark-theme" = "1";
          };
          gtk4.theme = null;
        };

        home.sessionVariables = {
          ADW_COLOR_SCHEME = "prefer-dark"; # Libadwaita
        };

        dconf.settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
          };
        };

        home.pointerCursor = {
          enable = true;
          gtk.enable = true;
          x11.enable = true;
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
          size = 24;
        };

        xdg.configFile = {
          "Kvantum/${kvantumThemeName}".source = "${pkgs.gruvbox-kvantum}/share/Kvantum/${kvantumThemeName}";
          "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
            General.theme = kvantumThemeName;
          };
        };
      }
    )
  ];
}
