osascript -e 'set volume output volume 60'

osascript -e 'tell application "Spotify"
    activate
    play track "spotify:playlist:11C834P6FgUoedLPsW9caq"
end tell'

sleep 1

# Skip ahead 60 seconds in the currently playing song
osascript -e 'tell application "Spotify"
    set player position to 4
end tell'

osascript -e 'tell application "Terminal"
    set currentTab to do script "dadyback"
    set current settings of currentTab to settings set "Homebrew"
    activate
end tell'
