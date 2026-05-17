-- Default: plug in any monitor
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = 1,
})

-- Station-Alpha monitors
hl.monitor({
	output = "desc:LG Electronics LG TV SSCR2 0x01010101",
	mode = "preferred",
	position = "auto",
	scale = 1.5,
})

-- Workspaces bound to monitors (find desc with: hyprctl monitors)
hl.workspace_rule({ workspace = "1", monitor = "desc:Dell Inc.XPS 2720 HH1178", default = true })
hl.workspace_rule({ workspace = "2", monitor = "desc:Dell Inc.XPS 2720 HH1178" })
hl.workspace_rule({ workspace = "3", monitor = "desc:Dell Inc.XPS 2720 HH1178" })
hl.workspace_rule({ workspace = "4", monitor = "desc:Dell Inc.XPS 2720 HH1178" })
hl.workspace_rule({ workspace = "5", monitor = "desc:LG Electronics LG TV SSCR2 0x01010101", default = true })
hl.workspace_rule({ workspace = "6", monitor = "desc:LG Electronics LG TV SSCR2 0x01010101" })
hl.workspace_rule({ workspace = "7", monitor = "desc:LG Electronics LG TV SSCR2 0x01010101" })
