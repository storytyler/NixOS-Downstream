{ pkgs, ... }:
{
  home-manager.sharedModules = [
    (_: {
      programs.btop = {
        enable = true;
        package = pkgs.btop.override {
          rocmSupport = true;
          cudaSupport = true;
        };
        settings = {
          color_theme = "monochrome-planet";
          show_gpu_info = "on";
          cpu_sensor = "auto";
          vim_keys = true;
          rounded_corners = true;
          proc_tree = false;
          show_uptime = true;
          show_coretemp = true;
          show_disks = true;
          only_physical = true;
          io_mode = true;
          io_graph_combined = false;
        };
        themes.monochrome-planet = ''
          # Main background — empty for terminal transparency
          theme[main_bg]=""

          # Main text color
          theme[main_fg]="#cfd3db"

          # Title color for boxes
          theme[title]="#3c728c"

          # Highlight color for keyboard shortcuts
          theme[hi_fg]="#cfd3db"

          # Background color of selected item in processes box
          theme[selected_bg]="#323232"

          # Foreground color of selected item in processes box
          theme[selected_fg]="#cfd3db"

          # Color of inactive/disabled text
          theme[inactive_fg]="#6b6b6b"

          # Color of text appearing on top of graphs
          theme[graph_text]="#8f8f8f"

          # Background color of the percentage meters
          theme[meter_bg]="#323232"

          # Misc colors for processes box
          theme[proc_misc]="#8f8f8f"

          # CPU, Memory, Network, Proc box outline colors
          theme[cpu_box]="#cfd3db"
          theme[mem_box]="#cfd3db"
          theme[net_box]="#cfd3db"
          theme[proc_box]="#cfd3db"

          # Box divider line and small boxes line color
          theme[div_line]="#323232"

          # Temperature graph color
          theme[temp_start]="#6acfff"
          theme[temp_mid]="#74e91c"
          theme[temp_end]="#c31700"

          # CPU graph colors
          theme[cpu_start]="#6acfff"
          theme[cpu_mid]="#74e91c"
          theme[cpu_end]="#c31700"

          # Mem/Disk free meter
          theme[free_start]="#6acfff"
          theme[free_mid]="#74e91c"
          theme[free_end]="#c31700"

          # Mem/Disk cached meter
          theme[cached_start]="#6acfff"
          theme[cached_mid]="#74e91c"
          theme[cached_end]="#c31700"

          # Mem/Disk available meter
          theme[available_start]="#6acfff"
          theme[available_mid]="#74e91c"
          theme[available_end]="#c31700"

          # Mem/Disk used meter
          theme[used_start]="#6acfff"
          theme[used_mid]="#74e91c"
          theme[used_end]="#c31700"

          # Download graph colors
          theme[download_start]="#6acfff"
          theme[download_mid]="#74e91c"
          theme[download_end]="#c31700"

          # Upload graph colors
          theme[upload_start]="#6acfff"
          theme[upload_mid]="#74e91c"
          theme[upload_end]="#c31700"

          # Process box color gradient
          theme[process_start]="#6acfff"
          theme[process_mid]="#74e91c"
          theme[process_end]="#c31700"
        '';
      };
    })
  ];
}
