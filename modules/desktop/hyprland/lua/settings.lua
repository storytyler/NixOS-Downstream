hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("NIXOS_OZONE_WL", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("OZONE_PLATFORM", "wayland")
hl.env("EGL_PLATFORM", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
-- hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_ENABLE_HIGHDPI_SCALING", "1")
hl.env("WLR_RENDERER_ALLOW_SOFTWARE", "1")
hl.env("NIXPKGS_ALLOW_UNFREE", "1")

hl.on("hyprland.start", function()
	hl.exec_cmd("cava-osd")
	hl.exec_cmd(wallpaper)
	hl.exec_cmd(bar)
	hl.exec_cmd("swaync")
	hl.exec_cmd("nm-applet --indicator")
	hl.exec_cmd("wl-paste --type text --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")
	hl.exec_cmd("rm '$XDG_CACHE_HOME/cliphist/db'")
	hl.exec_cmd(batterynotify)
	hl.exec_cmd("polkit-agent-helper-1")
	if wallpaperPicker == "skwd-wall" then
		hl.exec_cmd("skwd-daemon")
	end
end)

hl.config({
	input = {
		kb_layout = kbdLayout .. ",ru",
		kb_variant = kbdVariant .. ",",
		repeat_delay = 275,
		repeat_rate = 35,
		numlock_by_default = true,

		follow_mouse = 1,

		touchpad = {
			natural_scroll = false,
		},

		tablet = {
			output = "current",
		},

		sensitivity = 0,
		force_no_accel = true,
	},
	general = {
		gaps_in = 4,
		gaps_out = 9,
		border_size = 2,
		col = {
			active_border = {
				colors = { "rgba(cfd3dbff)", "rgba(8f8f8fff)" },
				angle = 45,
			},
			inactive_border = {
				colors = { "rgba(323232ff)", "rgba(1f1f1fff)" },
				angle = 45,
			},
		},
		resize_on_border = true,
		layout = "dwindle",
	},
	decoration = {
		shadow = {
			enabled = true,
			range = 0,
			render_power = 1,
			color = "rgba(00000000)",
		},
		rounding = 10,
		dim_special = 0.3,
		blur = {
			enabled = true,
			special = true,
			size = 2,
			passes = 2,
			brightness = 0.8,
			contrast = 1.0,
			new_optimizations = true,
			ignore_opacity = true,
			xray = false,
		},
	},
	group = {
		col = {
			border_active = {
				colors = { "rgba(ff6f3cff)", "rgba(b23a24ff)" },
				angle = 45,
			},
			border_inactive = {
				colors = { "rgba(3a2010cc)", "rgba(4a2810cc)" },
				angle = 45,
			},
			border_locked_active = {
				colors = { "rgba(ff6f3cff)", "rgba(b23a24ff)" },
				angle = 45,
			},
			border_locked_inactive = {
				colors = { "rgba(3a2010cc)", "rgba(4a2810cc)" },
				angle = 45,
			},
		},
	},
	render = {
		direct_scanout = 2, -- 0 = off, 1 = on, 2 = auto (on with content type 'game')
	},
	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
	},
	misc = {
		disable_hyprland_logo = true,
		mouse_move_focuses_monitor = true,
		swallow_regex = "^(Alacritty|kitty)$",
		enable_swallow = true,
		vrr = 2, -- 0=off, 1=on, 2=fullscreen only, 3=fullscreen games/media (replaces deprecated vfr)
	},
	xwayland = {
		force_zero_scaling = false,
	},
	dwindle = {
		preserve_split = true,
	}, -- pseudotile removed in 0.55.0
	master = {
		new_status = "master",
		new_on_top = true,
		mfact = 0.5,
	},
	binds = {
		workspace_back_and_forth = 0,
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})
