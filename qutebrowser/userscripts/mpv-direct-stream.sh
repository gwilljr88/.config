#!/bin/bash
# This script extracts the direct stream URL from the HTML's JavaScript variable.
# We are using Bash syntax and calling qutebrowser externally to get the output.

# 1. Use jseval to extract the 1080p stream URL from the stream_data JSON structure.
#    We fall back to 720p if 1080p is empty, or finally to m3u8 playlist if available.
#    The JS: stream_data['1080p'] is a list, so we take the first element [0].
JS_CODE="
    var data = stream_data['1080p'][0] || stream_data['720p'][0] || stream_data['m3u8'][0]; 
    if (data) {
        // MPV can handle the m3u8 playlist directly, or the mp4 URL.
        console.log(data);
    } else {
        console.log('');
    }
"

# 2. Execute the JavaScript and capture the output using the shell-safe method.
#    We call qutebrowser externally to get the output back to the script.
VIDEO_URL=$(qutebrowser --temp-basedir --backend webengine --target current :jseval "$JS_CODE" 2>/dev/null)

# 3. Clean up the output (remove surrounding quotes from jseval's output if present)
VIDEO_URL=$(echo "$VIDEO_URL" | sed 's/^"//;s/"$//')

# 4. Check if a valid URL was extracted and launch MPV
if [[ -n "$VIDEO_URL" && "$VIDEO_URL" != "undefined" ]]; then
    # Use $QUTE_URL as the referrer for the CDN and detach MPV
    SPAWN_CMD="spawn --detach mpv --referrer=\"$QUTE_URL\" \"$VIDEO_URL\""

    # Send the spawn command back to qutebrowser's FIFO pipe for execution
    echo "$SPAWN_CMD" >>"$QUTE_FIFO"
else
    # Show an error message
    echo "message-error 'MPV Script: Could not find a valid stream URL in stream_data.'" >>"$QUTE_FIFO"
fi
