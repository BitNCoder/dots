local terminal = "kitty"
local fileManager = "dolphin"
local menu = "wofi --show=drun"
local browser = "firefox"
local quickTerm = "kitten quick-access-terminal"


local mainMod = "SUPER"

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(quickTerm))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float())
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(browser))

-- lua rewrite of goto_zen.sh script
local function zen_mode()
    local active_workspace = hl.get_active_workspace()
    if active_workspace ~= nil and active_workspace.name == "zen" then
	hl.dispatch(hl.dsp.workspace.rename({workspace = active_workspace}))
    else -- the current workspace is not a zen workspace
	-- check if a zen workspace exists
	local workspaces = hl.get_workspaces()
	local zen_workspace = nil
	for i = 1,#workspaces do
	    if workspaces[i].name == "zen" then
		zen_workspace = workspaces[i]
		break
	    end
	end

	if zen_workspace ~= nil then -- we found a zen workspace, so focus it 
	    hl.dispatch(hl.dsp.focus({workspace = zen_workspace}))
	else -- we did not find a zen workspace, so make the current one zen
	    hl.dispatch(hl.dsp.workspace.rename({workspace=active_workspace, name="zen"}))
	end
    end

end
hl.bind(mainMod .. " + Z", function() zen_mode() end)


-- Focus Movement
hl.bind(mainMod .. " + H", hl.dsp.focus({direction = "left"}))
hl.bind(mainMod .. " + L", hl.dsp.focus({direction = "right"}))
hl.bind(mainMod .. " + K", hl.dsp.focus({direction = "up"}))
hl.bind(mainMod .. " + J", hl.dsp.focus({direction = "down"}))

-- Window Movement
hl.bind(mainMod .. " + ALT + H", hl.dsp.window.move({direction = "left"}))
hl.bind(mainMod .. " + ALT + L", hl.dsp.window.move({direction = "right"}))
hl.bind(mainMod .. " + ALT + K", hl.dsp.window.move({direction = "up"}))
hl.bind(mainMod .. " + ALT + J", hl.dsp.window.move({direction = "down"}))


-- Switch Workspaces
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({workspace = key}))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({workspace = key}))
end


-- fullscreen workspace
hl.bind(mainMod .. " + ALT + F", hl.dsp.window.fullscreen({mode = "fullscreen"}))
hl.bind(mainMod .. " + CTRL + F", hl.dsp.window.fullscreen({mode = "maximized"}))

-- scroll through existing workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({workspace = "e+1"}))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({workspace = "e-1"}))

-- Move/Resize windows
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), {mouse = true})
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), {mouse = true})


-- Three finger Gestures
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})



-- Multimedia keys for brightness and volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), {locked = true, repeating = true})
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-"), {locked = true, repeating = true})
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), {locked = true, repeating = true})
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), {locked = true, repeating = true})
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 5%+"), {locked = true, repeating = true})
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 5%-"), {locked = true, repeating = true})

-- Media control
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), {locked = true})
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), {locked = true})
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), {locked = true})
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), {locked = true})
