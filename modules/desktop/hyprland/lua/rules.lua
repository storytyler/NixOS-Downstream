-- Window rules (port from Harvey's working Lua config)
-- Adapted for our setup with Ember & Ash theme

-- Float Picture-in-Picture window for browsers
hl.window_rule({
	match = {
		title = "^(Picture-in-Picture)$",
		class = "^([Zz]en(-beta|-browser)?|[Ff]loorp|[Ff]irefox|[Cc]hromium)$",
	},
	float = true,
	pin = true,
})

-- Games tag
hl.window_rule({
	match = { tag = "games" },
	content = "game",
	sync_fullscreen = true,
	fullscreen = true,
	border_size = 0,
	no_shadow = true,
	no_blur = true,
	no_anim = true,
})
hl.window_rule({
	match = { content = "3" },
	tag = "+games",
})
hl.window_rule({
	match = { class = "^(steam_app.*|steam_app_\\d+)$" },
	tag = "+games",
})
hl.window_rule({
	match = { class = "^(gamescope)$" },
	tag = "+games",
})
hl.window_rule({
	match = { class = "(Waydroid)" },
	tag = "+games",
})
hl.window_rule({
	match = { class = "(osu!)" },
	tag = "+games",
})
