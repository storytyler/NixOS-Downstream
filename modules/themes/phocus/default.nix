{ pkgs, ... }:
let
  gtkThemeName = "phocus";
in
{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {
        gtk = {
          enable = true;
          gtk2.force = true;
          theme = {
            name = gtkThemeName;
            package = pkgs.phocus;
          };
          iconTheme = {
            package = pkgs.papirus-icon-theme;
            name = "Papirus-Dark";
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
          ADW_COLOR_SCHEME = "prefer-dark";
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
      }
    )
  ];
}
