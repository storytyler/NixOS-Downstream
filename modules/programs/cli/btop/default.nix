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
          color_theme = "ember-and-ash";
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
        themes.ember-and-ash = ''
          # Main background
          theme[main_bg]="#1b1a17"

          # Main text color
          theme[main_fg]="#f2e3d5"

          # Title color for boxes
          theme[title]="#ff6f3c"

          # Highlight color for keyboard shortcuts
          theme[hi_fg]="#ffe5d4"

          # Background color of selected item in processes box
          theme[selected_bg]="#2b1b18"

          # Foreground color of selected item in processes box
          theme[selected_fg]="#ff915e"

          # Color of inactive/disabled text
          theme[inactive_fg]="#4a3b36"

          # Color of text appearing on top of graphs
          theme[graph_text]="#ffb68f"

          # Background color of the percentage meters
          theme[meter_bg]="#2b1b18"

          # Misc colors for processes box
          theme[proc_misc]="#f2e3d5"

          # CPU, Memory, Network, Proc box outline colors
          theme[cpu_box]="#ff6f3c"
          theme[mem_box]="#d45d2f"
          theme[net_box]="#ff915e"
          theme[proc_box]="#c44428"

          # Box divider line and small boxes line color
          theme[div_line]="#4a3b36"

          # Temperature graph color
          theme[temp_start]="#8b2e1f"
          theme[temp_mid]="#d6452a"
          theme[temp_end]="#ff6f3c"

          # CPU graph colors
          theme[cpu_start]="#6e2f1a"
          theme[cpu_mid]="#ff6f3c"
          theme[cpu_end]="#ffb347"

          # Mem/Disk free meter
          theme[free_start]="#6e2f1a"
          theme[free_mid]="#ff6f3c"
          theme[free_end]="#ffb347"

          # Mem/Disk cached meter
          theme[cached_start]="#8c4a2f"
          theme[cached_mid]="#d45d2f"
          theme[cached_end]="#ff915e"

          # Mem/Disk available meter
          theme[available_start]="#d9a066"
          theme[available_mid]="#d45d4c"
          theme[available_end]="#B85746"

          # Mem/Disk used meter
          theme[used_start]="#9e8f70"
          theme[used_mid]="#d9a066"
          theme[used_end]="#e3b97f"

          # Download graph colors
          theme[download_start]="#ff915e"
          theme[download_mid]="#ffb347"
          theme[download_end]="#cc7a33"

          # Upload graph colors
          theme[upload_start]="#ff6f3c"
          theme[upload_mid]="#ff915e"
          theme[upload_end]="#ffb68f"

          # Process box color gradient
          theme[process_start]="#6e2f1a"
          theme[process_mid]="#c44428"
          theme[process_end]="#ff6f3c"
        '';
      };
    })
  ];
}
