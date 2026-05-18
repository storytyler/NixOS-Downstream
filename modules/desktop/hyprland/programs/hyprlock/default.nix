{ host, ... }:
let
  inherit (import ../../../../../hosts/${host}/variables.nix) hyprlockWallpaper;
in
{
  home-manager.sharedModules = [
    (_: {
      programs.hyprlock = {
        enable = true;
        settings = {
          general = {
            hide_cursor = true;
          };

          background = [
            {
              monitor = "";
              color = "rgb(26, 21, 18)";
              path = "${../../../../themes/wallpapers/${hyprlockWallpaper}}";

              blur_size = 0;
              blur_passes = 0;
            }
          ];

          input-field = [
            {
              monitor = "";
              size = "250, 50";
              outline_thickness = 3;
              outer_color = "rgb(217, 255, 59)";
              inner_color = "rgb(26, 21, 18)";
              font_color = "rgb(230, 213, 195)";
              fail_color = "rgb(166, 92, 59)";
              fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
              fail_transition = 300;
              fade_on_empty = false;
              placeholder_text = "Password...";
              dots_size = 0.2;
              dots_spacing = 0.64;
              dots_center = true;
              position = "0, 140";
              halign = "center";
              valign = "bottom";
            }
          ];

          label = [
            {
              monitor = "";
              text = "$TIME";
              font_size = 80;
              color = "rgb(217, 255, 59)";
              position = "0, -80";
              halign = "center";
              valign = "top";
            }
            {
              monitor = "";
              text = "Current Layout : $LAYOUT";
              color = "rgb(217, 255, 59)";
              font_size = 14;
              position = "0, 20";
              halign = "center";
              valign = "bottom";
            }
          ];
        };
      };
    })
  ];
}
