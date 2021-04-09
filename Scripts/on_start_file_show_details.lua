--[[
Always show the playlist.
If there are chapters, also show the chapterlist.

Detail: 3.1 is (osd-duration + 100 millis). My osd-duration is 3000.
 ]]
function on_start_file_show_details()
    mp.command("script-message osc-playlist")

    local chapters = mp.get_property_number("chapters")
    if chapters == nil then chapters = 0 end
    if chapters > 0 then
        mp.add_timeout(3.1, function() mp.commandv("script-message", "osc-chapterlist") end)
    end
end

mp.register_event("file-loaded", function() mp.add_timeout(0.5, on_start_file_show_details) end)
