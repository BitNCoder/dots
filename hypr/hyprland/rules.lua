-- Ignore maximization requests from apps
local supressMaximizeRule = hl.window_rule({
    name = "supress-maximize-events",
    match = {class = ".*"},
    suppress_event = "maximize"
})

-- supressMaximizeRule:set_enabled(false)

-- fix xwayland dragging issues
hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
	class = "^$",
	title = "^$",
	xwayland = true,
	float = true,
	fullscreen = false,
	pin = false
    },
    no_focus = true
})

-- fix opacity for zathura (pdf viewer)
hl.window_rule({
    match = {
	initial_title = "org.pwmt.zathura"
    },
    opaque = true
})


-- Setup ZEN workspace rules
hl.workspace_rule({
    workspace = "name:zen",
    gaps_in = 0,
    gaps_out = 0,
    no_shadow = true
})
hl.window_rule({
    match = {
	workspace = "name:zen"
    },

    opaque = true,
    no_anim = true,
    no_blur = true,
    no_shadow = true,
    rounding = 0
})
