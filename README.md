# CKTVVLC
### Extension for VLC Media Player to play local TV & Radio channels  


Simple Lua extension to implement live streaming of local tv and radio from in-house cable system

VLC addon files are copied to VLC’s directory depending upon the OS. It also depends upon which users you are going to make available the add-ons for. The default ones are:

For All Users

In Windows: Program Files\VideoLAN\VLC\lua\sd\
In Mac OS X: /Applications/VLC.app/Contents/MacOS/share/lua/sd/
In Linux: /usr/lib/vlc/lua/playlist/ or /usr/share/vlc/lua/sd/

For Current User

In Windows: %APPDATA%\vlc\lua\sd\
In Mac OS X: /Users/%your_name%/Library/Application Support/org.videolan.vlc/lua/sd/
In Linux: ~/.local/share/vlc/lua/sd/


