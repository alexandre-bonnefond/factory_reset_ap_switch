#!/bin/bash

# Path to your custom script
CUSTOM_SCRIPT="~/test.sh"

# Temporary file to keep track of button presses
TEMP_FILE="/tmp/power_button_press_count"

# Read the current timestamp
CURRENT_TIME=$(date +%s)

# Read the last recorded timestamp and press count
if [ -f $TEMP_FILE ]; then
	read LAST_PRESS_COUNT LAST_PRESS_TIME < $TEMP_FILE
else
	LAST_PRESS_COUNT=0
	LAST_PRESS_TIME=0
fi

# Calculate the time difference between the current and last press
TIME_DIFF=$((CURRENT_TIME - LAST_PRESS_TIME))

# Check if the time difference is less than 3 seconds
if [ $TIME_DIFF -le 1 ]; then
	# Ignore presses within 1 second to filter duplicates
	exit 0
elif [ $TIME_DIFF -le 3 ]; then
	# Increment the press count
	PRESS_COUNT=$((LAST_PRESS_COUNT + 1))
else
	# Reset the press count
	PRESS_COUNT=1
fi

# Update the temporary file with the new press count and timestamp
echo "$PRESS_COUNT $CURRENT_TIME" > $TEMP_FILE

# Check if the press count has reached 3
if [ $PRESS_COUNT -ge 3 ]; then
	# Reset the press count and run the custom script
	echo "0 $CURRENT_TIME" > $TEMP_FILE
	bash $CUSTOM_SCRIPT
fi

