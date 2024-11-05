#!/bin/bash

stop_wake() {
    # End the Amphetamine session
    osascript -e 'tell application "Amphetamine" to end session'
    echo "Stopped wake process"
    rm -f "/tmp/caffeinate_end_time"
    exit 0
}

check_wake() {
    # Check if there is an active Amphetamine session
    session_active=$(osascript -e 'tell application "Amphetamine" to set sessionActiveTest to session is active' -e 'return sessionActiveTest')
    
    if [ "$session_active" = "true" ]; then
        # Get the remaining session time
        time_remaining=$(osascript -e 'tell application "Amphetamine" to set timeRemaining to session time remaining' -e 'return timeRemaining')
        hours=$((time_remaining / 3600))
        minutes=$(( (time_remaining % 3600) / 60 ))
        echo "Wake process active: ${hours}h ${minutes}m remaining"
    else
        echo "No wake process active"
    fi
    exit 0
}

# Handle stop and check commands
if [ "$1" = "stop" ]; then
    stop_wake
fi

if [ "$1" = "check" ]; then
    check_wake
fi

# Function to convert 12-hour time with AM/PM to 24-hour format
convert_to_24hr() {
  local time_string=$1
  if [[ $time_string == *"am" || $time_string == *"pm" ]]; then
    # Handle HHMMam/pm, HHHam/pm, HHam/pm, and Ham/pm formats
    if [[ ${#time_string} -eq 6 ]]; then
      # Four-digit format (e.g., 1130pm)
      date -j -f "%I:%M%p" "${time_string:0:2}:${time_string:2:2}${time_string: -2}" +"%H:%M"
    elif [[ ${#time_string} -eq 5 ]]; then
      # Three-digit format (e.g., 130pm)
      date -j -f "%I:%M%p" "${time_string:0:1}:${time_string:1:2}${time_string: -2}" +"%H:%M"
    elif [[ ${#time_string} -eq 4 ]]; then
      # Two-digit format (e.g., 11pm)
      date -j -f "%I%p" "${time_string:0:2}${time_string: -2}" +"%H:%M"
    else
      # Single-digit format (e.g., 1pm)
      date -j -f "%I%p" "${time_string:0:1}${time_string: -2}" +"%H:%M"
    fi
  else
    echo "Error: Invalid time format. Please use 'am' or 'pm' suffix."
    exit 1
  fi
}

# Parse input time
input_time=$1
if [[ ! $input_time =~ ^[0-9]{1,4}(am|pm)$ && "$input_time" != "stop" && "$input_time" != "check" ]]; then
  echo "Usage: wake <time>, e.g., 130am, 330pm, 1130pm, 11pm, or 1pm"
  echo "       wake stop    - to stop an active wake process"
  echo "       wake check   - to check status of wake process"
  exit 1
fi

# Current date and time
current_date=$(date +"%Y-%m-%d")
current_time=$(date +"%H:%M")

# Convert input to 24-hour format
formatted_input_time=$(convert_to_24hr "$input_time")

# Set minutes to 00 only for single-digit and two-digit formats (e.g., 1am, 11pm)
if [[ ${#input_time} -eq 3 || ${#input_time} -eq 4 ]]; then
    formatted_input_time="${formatted_input_time%:*}:00"
fi

# Calculate target datetime (considering it may be the next day if target time is earlier than current time)
if [[ $(date -j -f "%H:%M" "$formatted_input_time" +"%s") -le $(date -j -f "%H:%M" "$current_time" +"%s") ]]; then
  # Target time is the next day
  target_date_time=$(date -j -v+1d -f "%Y-%m-%d %H:%M" "$current_date $formatted_input_time" +"%s")
else
  # Target time is today
  target_date_time=$(date -j -f "%Y-%m-%d %H:%M" "$current_date $formatted_input_time" +"%s")
fi

# Calculate the duration in seconds and convert to minutes for Amphetamine
current_date_time=$(date +"%s")
duration=$((target_date_time - current_date_time))
duration_minutes=$((duration / 60))

# Save end time for later checks
echo "$target_date_time" > /tmp/caffeinate_end_time

# Run Amphetamine session with calculated minutes, disabling display sleep
osascript -e "tell application \"Amphetamine\" to start new session with options {duration:$duration_minutes, interval:minutes, displaySleepAllowed:false}"

# Notify user
echo "Keeping Mac awake for $((duration / 60)) minutes until $formatted_input_time."
