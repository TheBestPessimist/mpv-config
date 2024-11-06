--[[
    Show OSC on Pause

Inspired from https://github.com/mpv-player/mpv/issues/6592
]]



function on_pause_show_osc(name, value)
	if value == true then
		mp.commandv('script-message','osc-visibility','always','no-osd')
	else
		mp.commandv('script-message','osc-visibility','auto','no-osd')
	end
end

mp.observe_property("pause", "bool", on_pause_show_osc)
