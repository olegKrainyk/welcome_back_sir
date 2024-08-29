osascript -e 'set volume output volume 60'

osascript -e 'tell application "Spotify"
    activate
    play track "spotify:playlist:11C834P6FgUoedLPsW9caq"
end tell'

# Ensure Docker Desktop is running
if ! pgrep -x "Docker" > /dev/null; then
    echo "Starting Docker Desktop..."
    open -a "Docker"
    # Wait for Docker to start
    while ! docker system info > /dev/null 2>&1; do
        sleep 1
    done
    echo "Docker is now running."
else
    echo "Docker already running."
fi

sleep 0.4

# Skip ahead 4 seconds in the currently playing song
osascript -e 'tell application "Spotify"
    set player position to 4
end tell'

sleep 0.2

# run chroma vector database
osascript -e 'tell application "Terminal"
    do script "docker run -p 8000:8000 -v /Users/whyiamthere/Desktop/oleychAI/databaseInput/:/chroma/chroma chromadb/chroma"
    set miniaturized of front window to true
    activate
end tell'

sleep 0.2

#run main ngrok
osascript -e 'tell application "Terminal"
    do script "ngrok authtoken <token_1>; ngrok http 3999;)"
    set miniaturized of front window to true
    activate
end tell'

sleep 0.2

#run instance ngrok
osascript -e 'tell application "Terminal"
    do script "ngrok authtoken <token_2>; ngrok http 3982;)"
    set miniaturized of front window to true
    activate
end tell'

sleep 0.2

# run media ngrok
osascript -e 'tell application "Terminal"
    do script "ngrok authtoken <token_3>; ngrok http 'file:/Users/whyiamthere/Desktop/startup/StayWithMe/phonecall/media/'"
    set miniaturized of front window to true
    activate
end tell'

sleep 0.2

# open terminal, go to folder, print welcome text
osascript -e 'tell application "Terminal"
    set currentTab to do script "dadyback"
    set current settings of currentTab to settings set "Homebrew"
    set bounds of front window to {100, 100, 1000, 500}
    activate
end tell'


sleep 2

echo "now try to extract them fool"
# extract ngrok urls
echo "now try to extract them fool"
curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"[^"]*' | cut -d '"' -f 4

curl -s http://localhost:4041/api/tunnels | grep -o '"public_url":"[^"]*' | cut -d '"' -f 4

curl -s http://localhost:4042/api/tunnels | grep -o '"public_url":"[^"]*' | cut -d '"' -f 4


# to implement -->>

# python3 run_multiple_instances.py
# export NGROK_URL=<ngrok_url>
# python3 streamtotwilio.py 3982




