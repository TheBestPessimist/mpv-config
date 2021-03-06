-- Source: https://gist.github.com/Hakkin/4f978a5c87c31f7fe3ae
-- Source: https://github.com/mpv-player/mpv/issues/4738#issuecomment-321298846
-- Source: https://github.com/Argon-/mpv-config/blob/master/scripts/betterchapters.lua#L20

-- betterchapters.lua
-- Loads the next or previous playlist entry if there are no more chapters in the seek direction.
-- Recommended to use with autoload.lua which is enabled by default in mpv.

-- How to use
-- Keybind names: chapterplaylist-next, chapterplaylist-prev
--
-- To bind in input.conf, use:
-- PGUP       script-binding chapterplaylist-prev
-- PGDWN      script-binding chapterplaylist-next


local default_reset_timeout = 5
local previous_desired_chapter = 0

function chapter_seek(direction)
    local chapters = mp.get_property_number("chapters")
    if chapters == nil then chapters = 0 end
    local chapter = mp.get_property_number("chapter")
    if chapter == nil then chapter = 0 end

    local desired_chapter = chapter + direction
    if desired_chapter < 0 then
        if previous_desired_chapter <= -1 then
            mp.command("playlist_prev")
            mp.commandv("script-message", "osc-playlist")
            reset_previous_desired_chapter()
        else
            mp.osd_message("« Press again to move to Previous file.", default_reset_timeout)
            previous_desired_chapter = -1
            reset_previous_desired_chapter()
        end
    elseif desired_chapter >= chapters then
        if previous_desired_chapter >= 1 then
            mp.command("playlist_next")
            mp.commandv("script-message", "osc-playlist")
            reset_previous_desired_chapter()
        else
            mp.osd_message("» Press again to move to Next file.", default_reset_timeout)
            previous_desired_chapter = 1
            reset_previous_desired_chapter()
        end
    else
        mp.commandv("add", "chapter", direction)
        reset_previous_desired_chapter()
        mp.add_timeout(0.2, function() mp.commandv("script-message", "osc-chapterlist") end)
    end
end

local active_reset_timer = mp.add_timeout(0.001, function() end)
function reset_previous_desired_chapter()
    if active_reset_timer:is_enabled() then
        active_reset_timer:kill()
    end
    active_reset_timer = mp.add_timeout(default_reset_timeout, function() previous_desired_chapter = 0 end)
end

mp.add_key_binding(nil, "chapterplaylist-next", function() chapter_seek(1) end)
mp.add_key_binding(nil, "chapterplaylist-prev", function() chapter_seek(-1) end)
