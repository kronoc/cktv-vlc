--[[
    Local TV & Radio Streaming with VLC 
    Authors: Conor Keegan and Christos Alexiou
]]--

streamingList = {
    {name = "Radio", url = "http://192.168.1.3/iptv/radio.m3u"}, 
    {name = "TV", url = "http://192.168.1.3/iptv/cktv.m3u"}, 
    {name = "BBC Only", url = "http://192.168.1.3/iptv/bbc.m3u"}, 
    {name = "RTE Only", url = "http://192.168.1.3/iptv/rte.m3u"}, 
    {name = "Christmas", url = "http://192.168.1.3/iptv/christmas.m3u"},
    
}

function descriptor() 
    return {
	    title = "Local TV & Radio" ; 
            version = "1.0.0" ; 
            author = "Conor Keegan and Christos Alexiou" ; 
            myurl = "http://conor.net"; 
            shortdesc = "Stream live TV and Radio from local sources"
	    description = "Stream live TV and Radio from local sources"
            capabililties = {"menu"}
        }
end

function activate() 
    dialog = vlc.dialog("Local TV & Radio") 
    list = dialog:add_list(1,3,4,1) 
    play_button = dialog:add_button("Play", click_play, 1, 4, 4, 1)
    -- adding the channels 
    for idx, details in ipairs(streamingList) do 
        list:add_value(details.name, idx) 
    end 

    dialog.show() 
end 

function click_play() 
    selecting = list:get_selection() 
    if(not selecting) then return 1 end 
    local selection = nil 
    for idx, selectedItem in pairs(selecting) do 
        selection = idx 
        break 
    end 
    details = streamingList[selection] 

    -- start stream 
    vlc.playlist.clear() 
    vlc.playlist.add() 
    vlc.playlist.play() 

end

function deactivate() 
end 

function close()
    vlc.deactivate() 
end 











