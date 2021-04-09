--[[
    Show OSC on Pause

Inspired from https://github.com/mpv-player/mpv/issues/6592#issuecomment-488269456


Technical note:
For some reason `mp.command("no-osd set osd-level 0; script-message osc-visibility always; no-osd set osd-level 1")` does not work.
The OSC messages `OSC visibility: always/auto` are still displayed.
It's as if `no-osd set osd-level 0` runs after `script-message osc-visibility always` is run/displayed.
As a workaround, I have to run all the commands with an increasing delay.
Why? No idea. Bugs? `¯\_(ツ)_/¯`
--]]


function on_pause_show_osc(name, value)
    if value == true then
        delayed(0, "no-osd set osd-level 0")
        delayed(0.1, "script-message osc-visibility always")
        delayed(0.3, "no-osd set osd-level 1")
    else
        delayed(0, "no-osd set osd-level 0")
        delayed(0.1, "script-message osc-visibility auto")
        delayed(0.3, "no-osd set osd-level 1")
    end
end

function delayed(time, command)
   mp.add_timeout(time, function() mp.command(command) end)
end

mp.observe_property("pause", "bool", on_pause_show_osc)
