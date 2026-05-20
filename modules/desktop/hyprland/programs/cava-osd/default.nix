{ ... }:
{
  home-manager.sharedModules = [
    (_: {
      # Mirror GLSL shader — bars mirrored left-to-right from center
      xdg.configFile."cava/shaders/mirror.frag".text = ''
        #version 120

        uniform int bars_count;
        uniform float bars[512];
        uniform vec3 gradient_colors[8];
        uniform vec2 u_resolution;
        uniform vec4 bg_color;

        void main() {
            vec2 fragCoord = gl_FragCoord.xy / u_resolution;

            // Mirror: both halves map to the full spectrum
            // 0.0 → 0.0 (left edge = center), 0.5 → 1.0 (center = edges)
            // 1.0 → 0.0 (right edge = center)
            float mirror_x = fragCoord.x < 0.5
                ? fragCoord.x * 2.0
                : (1.0 - fragCoord.x) * 2.0;

            int bar_index = int(bars_count * mirror_x);
            bar_index = clamp(bar_index, 0, 511);
            float bar_h = bars[bar_index];

            // y from bottom (0) to top (1)
            float y = 1.0 - fragCoord.y;

            if (y > bar_h) {
                gl_FragColor = bg_color;
            } else {
                bar_h = max(bar_h, 0.001);
                float t = clamp(y / bar_h, 0.0, 1.0);
                int ci = clamp(int(t * 7.0), 0, 7);
                gl_FragColor = vec4(gradient_colors[ci], 1.0);
            }
        }
      '';

      # Separate cava config for OSD mode (avoids conflict with terminal cava)
      xdg.configFile."cava/cava-osd.config".text = ''
        [general]
        framerate = 60
        sensitivity = 100
        autosens = 1

        [input]
        method = pulse

        [output]
        method = sdl_glsl
        channels = stereo
        # mono_option = left
        # Relative to config dir (~/.config/cava/)
        fragment_shader = shaders/mirror.frag

        [color]
        gradient = 1
        bg = true
        bg_color = '#1a1b26'
        gradient_color_1 = '#7aa2f7'
        gradient_color_2 = '#7dcfff'
        gradient_color_3 = '#9ece6a'
        gradient_color_4 = '#e0af68'
        gradient_color_5 = '#ff9e64'
        gradient_color_6 = '#f7768e'
        gradient_color_7 = '#bb9af7'
        gradient_color_8 = '#c0caf5'
      '';
    })
  ];
}
