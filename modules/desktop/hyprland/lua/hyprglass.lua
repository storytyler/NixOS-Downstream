if hl.plugin.hyprglass then
	local hg = hl.plugin.hyprglass

	hg.config({
		enabled = 1,
		default_theme = "dark",
		default_preset = "subtle",

		blur_strength = 2.0,
		refraction_strength = 0.6,
		chromatic_aberration = 0.5,
		glass_opacity = 1.0,
		edge_thickness = 0.06,
		tint_color = 0x8899aa22,

		dark = {
			brightness = 0.82,
			contrast = 0.90,
			saturation = 0.80,
			adaptive_dim = 0.4,
		},

		light = {
			brightness = 1.12,
			adaptive_boost = 0.4,
		},

		layers = { enabled = 1 },
	})

	hg.layer("waybar", { preset = "subtle", mask_threshold = 0.05 })
	hg.layer("swaync", { preset = "subtle" })
	hg.layer("rofi", { preset = "clear" })

	hl.window_rule({ match = { fullscreen = true }, tag = "+hyprglass_disabled" })
end
