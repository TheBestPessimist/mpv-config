-- Source: https://gist.github.com/Hakkin/4f978a5c87c31f7fe3ae
-- Source: https://github.com/mpv-player/mpv/issues/4738#issuecomment-321298846
-- Source: https://github.com/Argon-/mpv-config/blob/master/scripts/betterchapters.lua#L20

-- betterchapters.lua
-- Loads the next or previous playlist entry if there are no more chapters in the seek direction.
-- To bind in input.conf, use: <keybind> script_binding <keybind name>
-- Keybind names: chapterplaylist-next, chapterplaylist-prev
-- Recommended to use with autoload.lua



local previous_direction = 0
function chapter_seek(direction)
    local chapters = mp.get_property_number("chapters")
    if chapters == nil then chapters = 0 end
    local chapter  = mp.get_property_number("chapter")
    if chapter == nil then chapter = 0 end

    if chapter+direction < 0 then
        if previous_direction <= -1 then
            mp.command("playlist_prev")
            mp.commandv("script-message", "osc-playlist")
            reset_previous_direction()
        else
            mp.osd_message("« Press again to move to Previous file.", 4)
            previous_direction = -1
            reset_previous_direction()
        end
    elseif chapter+direction >= chapters then
        if previous_direction >= 1 then
            mp.command("playlist_next")
            mp.commandv("script-message", "osc-playlist")
            reset_previous_direction()
        else
            mp.osd_message("» Press again to move to Next file.", 4)
            previous_direction = 1
            reset_previous_direction()
        end
    else
        mp.commandv("add", "chapter", direction)
        mp.commandv("script-message", "osc-chapterlist")
        reset_previous_direction()
    end
end

local previous_reset_timer = mp.add_timeout(1, function() end)
function reset_previous_direction()
    if previous_reset_timer:is_enabled() then
        previous_reset_timer:kill()
    end
    previous_reset_timer = mp.add_timeout(4, function() previous_direction = 0 end)
end


mp.add_key_binding(nil, "chapterplaylist-next", function() chapter_seek(1) end)
mp.add_key_binding(nil, "chapterplaylist-prev", function() chapter_seek(-1) end)
