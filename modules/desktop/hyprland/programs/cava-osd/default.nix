{ ... }:
{
  home-manager.sharedModules = [
    (_: {
      xdg.configFile."cava/shaders/mirror.frag".text = ''
        #version 330

        in vec2 fragCoord;
        out vec4 fragColor;

        uniform float bars[512];
        uniform int bars_count;
        uniform vec3 u_resolution;
        uniform vec3 bg_color;
        uniform int gradient_count;
        uniform vec3 gradient_colors[8];

        void main() {
            float mirror_x = fragCoord.x < 0.5
                ? fragCoord.x * 2.0
                : (1.0 - fragCoord.x) * 2.0;

            int bar = int(bars_count * mirror_x);
            float bar_h = bars[bar];

            float y = fragCoord.y;

            if (y > bar_h) {
                fragColor = vec4(bg_color, 0.0);
            } else {
                bar_h = max(bar_h, 0.001);
                float t = clamp(y / bar_h, 0.0, 1.0);
                int ci = int(clamp(t * float(gradient_count - 1), 0.0, float(gradient_count - 1)));
                float y_min = float(ci) / float(gradient_count - 1);
                float y_max = float(ci + 1) / float(gradient_count - 1);
                float yr = (t - y_min) / (y_max - y_min);
                vec3 col = gradient_colors[ci] * (1.0 - yr) + gradient_colors[ci + 1] * yr;
                fragColor = vec4(col, 1.0);
            }
        }
      '';

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
