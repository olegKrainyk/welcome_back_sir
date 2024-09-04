# 2 separate scripts in same shortcut

# ------------------------------------------------------------------------------------------------------------
PIDS=$(ps aux | grep -E "run_multiple_instances.py|streamtotwilio.py" | grep -v grep | awk '{print $2}')

# Check if we found any PIDs
if [ -z "$PIDS" ]; then
  echo "No matching processes found."
else
  # Kill the processes
  for PID in $PIDS; do
    kill -9 $PID
    echo "Killed process with PID: $PID"
  done
fi

sleep 0.3

# ------------------------------------------------------------------------------------------------------------
osascript -e 'tell application "Terminal"
    do script "docker stop <process_id>; killall ngrok;" 
end tell'

sleep 0.3
