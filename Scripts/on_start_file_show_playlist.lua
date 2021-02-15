function on_start_file_show_playlist()
    mp.command("script-message osc-playlist")
    -- mp.command("script-message osc-tracklist")
end


mp.register_event("file-loaded",
    function()
        mp.add_timeout(0.5, on_start_file_show_playlist)
    end
)
