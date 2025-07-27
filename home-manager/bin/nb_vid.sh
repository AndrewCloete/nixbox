#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 <youtube_video_url>"
    echo "Example: $0 https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    exit 1
}

# Check if a URL is provided
if [ -z "$1" ]; then
    usage
fi

YOUTUBE_URL="$1"

# YouTube oEmbed endpoint
# Note: The format parameter is crucial for getting JSON.
OEMBED_BASE_URL="https://www.youtube.com/oembed?url="
OEMBED_FULL_URL="${OEMBED_BASE_URL}${YOUTUBE_URL}&format=json"

echo "Fetching information for: $YOUTUBE_URL"

# Make the curl request and pipe the output to jq for parsing
# -s: Silent mode (don't show progress or error messages)
# -S: Show errors if present (useful in combination with -s)
# -L: Follow redirects
# --fail: Fail silently (no output) on server errors (HTTP 4xx or 5xx)
JSON_RESPONSE=$(curl -sSL --fail "${OEMBED_FULL_URL}")

# Check if curl command was successful
if [ $? -ne 0 ]; then
    echo "Error: Could not fetch data from YouTube oEmbed endpoint."
    echo "Please ensure the URL is valid and you have an active internet connection."
    echo "If the error persists, YouTube's oEmbed endpoint might be temporarily unavailable or has changed."
    exit 1
fi

# Extract title and author_name (channel name) using jq
VIDEO_TITLE=$(echo "${JSON_RESPONSE}" | jq -r '.title')
CHANNEL_NAME=$(echo "${JSON_RESPONSE}" | jq -r '.author_name')

# Check if extraction was successful (jq returns null or empty string if key not found)
if [ -z "${VIDEO_TITLE}" ] || [ "${VIDEO_TITLE}" == "null" ]; then
    echo "Error: Could not extract video title. The oEmbed response might be incomplete or malformed."
    exit 1
fi

if [ -z "${CHANNEL_NAME}" ] || [ "${CHANNEL_NAME}" == "null" ]; then
    echo "Error: Could not extract channel name. The oEmbed response might be incomplete or malformed."
    exit 1
fi


OUT_DIR="/Users/user/Workspace/journals/notebook/obsidian_nb/TOC/Videos"


MULTILINE_STRING="""---
channel: [[${CHANNEL_NAME}]]
url: ${YOUTUBE_URL}
---
#Videos

![${VIDEO_TITLE}](${YOUTUBE_URL})

"""

echo $VIDEO_TITLE
echo "$MULTILINE_STRING"

OUT_FILE="${OUT_DIR}/${VIDEO_TITLE}.md"
if [ -f "$OUT_FILE" ]; then
    echo "Error: File '$OUT_FILE' already exists. Exiting."
    exit 1
fi

echo "${MULTILINE_STRING}" > "${OUT_FILE}"


exit 0
