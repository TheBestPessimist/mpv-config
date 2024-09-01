/*
    For this to work, you must also add the following config in `mpv.conf`:

    osd-on-seek=no
*/

mp.observe_property('seeking', 'native', function(_, seeking)
    if seeking then
        mp.command('script-message osc-show')
    end
end)
