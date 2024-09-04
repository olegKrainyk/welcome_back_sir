osascript -e 'set volume output volume 60'

osascript -e 'tell application "Spotify"
    activate
    play track "spotify:playlist:<playlist_id>"
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
    do script "docker start <process_id>"
    set miniaturized of front window to true
    activate
end tell'

sleep 0.2

#run main ngrok
osascript -e 'tell application "Terminal"
    do script "ngrok authtoken <token1>; ngrok http 3999;"
    set miniaturized of front window to true
    activate
end tell'

sleep 0.2

#run instance ngrok
osascript -e 'tell application "Terminal"
    do script "ngrok authtoken <token2>; ngrok http 3982;"
    set miniaturized of front window to true
    activate
end tell'

sleep 0.2

# run media ngrok
osascript -e 'tell application "Terminal"
    do script "ngrok authtoken <token3>; ngrok http 'file:/Users/whyiamthere/Desktop/startup/StayWithMe/phonecall/media/'"
    set miniaturized of front window to true
    activate
end tell'

sleep 0.2

# open terminal, go to folder, print welcome text
osascript -e 'tell application "Terminal"
    set currentTab to do script "staywithme && dadyback"
    set current settings of currentTab to settings set "Homebrew"
    set bounds of front window to {100, 100, 1000, 500}
    activate
end tell'


osascript -e 'tell application "Terminal"
    set targetWindow to first window whose custom title is "chroma_db"
    set miniaturized of front window to true
    activate
end tell'


sleep 1

# Update the .env file with the new URLs
ENV_FILE_PATH=~/Desktop/startup/StayWithMe/.env

# remove temporary .env copies
cd ~/Desktop/startup/StayWithMe/
rm .!*!.env

NGROK_SERVER_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o '"public_url":"[^"]*' | cut -d '"' -f 4)
NGROK_INSTANCE_URL=$(curl -s http://localhost:4041/api/tunnels | grep -o '"public_url":"[^"]*' | cut -d '"' -f 4)
NGROK_MEDIA_URL=$(curl -s http://localhost:4042/api/tunnels | grep -o '"public_url":"[^"]*' | cut -d '"' -f 4)

sed -i '' "s|^NGROK_SERVER_URL=.*|NGROK_SERVER_URL=$NGROK_SERVER_URL|" $ENV_FILE_PATH
sed -i '' "s|^NGROK_INSTANCE_URL=.*|NGROK_INSTANCE_URL=$NGROK_INSTANCE_URL|" $ENV_FILE_PATH
sed -i '' "s|^NGROK_MEDIA_URL=.*|NGROK_MEDIA_URL=$NGROK_MEDIA_URL|" $ENV_FILE_PATH

sleep 1

osascript -e 'tell application "Terminal"
    do script "staywithme && python3 run_multiple_instances.py"
    set miniaturized of front window to true
    activate
end tell'

sleep 0.2

osascript -e 'tell application "Terminal"
    do script "staywithme && python3 streamtotwilio.py 3982"
    set miniaturized of front window to true
    activate
end tell'

# to implement -->>
# window internal names
