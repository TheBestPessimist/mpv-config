--[[
    For this to work, you must also add the following config in `mpv.conf`:

    osd-on-seek=no
 ]]
mp.observe_property('seeking', 'native', function(name, isSeeking)
    if isSeeking then
--         mp.command('script-message osc-show')
        mp.command('show-progress')
    end
end)
