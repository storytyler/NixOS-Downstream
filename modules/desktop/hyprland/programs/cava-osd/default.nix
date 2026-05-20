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

        const vec4 tokyo_bg = vec4(0.102, 0.106, 0.149, 1.0);

        void main() {
            vec2 fragCoord = gl_FragCoord.xy / u_resolution;

            float mirror_x = fragCoord.x < 0.5
                ? fragCoord.x * 2.0
                : (1.0 - fragCoord.x) * 2.0;

            int bar_index = int(clamp(bars_count * mirror_x, 0.0, 511.0));
            float bar_h = bars[bar_index];

            float y = 1.0 - fragCoord.y;

            if (y > bar_h) {
                gl_FragColor = tokyo_bg;
            } else {
                bar_h = max(bar_h, 0.001);
                float t = clamp(y / bar_h, 0.0, 1.0);
                int ci = int(clamp(t * 7.0, 0.0, 7.0));
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
        # cava prepends shaders/ — so this resolves to shaders/mirror.frag
        fragment_shader = mirror.frag

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
