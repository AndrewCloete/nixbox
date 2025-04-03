# (f)ind and (s)ave to tmux clipboard
fds() {
    local file
    file=$(fd "$1" | fzf)  

    if [[ -n "$file" ]]; then 
        echo "$file" | tmux load-buffer -
    else
        echo "No file selected"
    fi
}

# (f)ind and (v)im a file
fdv() {
    local file
    file=$(fd "$1" | fzf)  

    if [[ -n "$file" ]]; then 
        vim "$file"           
    else
        echo "No file selected"
    fi
}


# (cd) to any file in the current (g)it repo
cdg() {
    local file
    file=$(git ls-files | fzf) 

    if [[ -n "$file" ]]; then
        local dir
        dir=$(dirname "$file") 
        cd "$dir" || echo "Failed to change directory"
    else
        echo "No file selected"
    fi
}


# (cd) to any file in the current (t)ree
cdt() {
    local file
    file=$(fd "$1" | fzf) 

    if [[ -n "$file" ]]; then
        local dir
        dir=$(dirname "$file") 
        cd "$dir" || echo "Failed to change directory"
    else
        echo "No file selected"
    fi
}

extract_path_components() {
    local filepath="$1"
    SPLIT_DIRECTORY=$(dirname "$filepath")
    SPLIT_FILENAME=$(basename "$filepath" | sed 's/\.[^.]*$//')
    SPLIT_EXTENSION="${filepath##*.}"
}

# Minify image
mini() {
    local filepath="$1"
    extract_path_components "$filepath"
    magick "${filepath}" -quality $2 "${SPLIT_DIRECTORY}/${SPLIT_FILENAME}-mini.jpg"
}


# Scale down image preserving transparency (if applicable)
scalei() {
    local filepath="$1"
    local scale_factor="$2"
    extract_path_components "$filepath"

    magick "$filepath" -resize "$((100/scale_factor))%" \
           "${SPLIT_DIRECTORY}/${SPLIT_FILENAME}-mini.${SPLIT_EXTENSION}"
}


# Minify video
minv() {
    local filepath="$1"
    extract_path_components "$filepath"
    ffmpeg -i "${filepath}" -vf "scale=1280:720" -c:v libx264 -preset fast -crf 28 -c:a aac -b:a 64k -movflags +faststart "${SPLIT_DIRECTORY}/${SPLIT_FILENAME}-mini.mp4" 
}

minv_med() {
    local filepath="$1"
    extract_path_components "$filepath"
    local output_filepath="${SPLIT_DIRECTORY}/${SPLIT_FILENAME}-chat.mp4"
    # Target resolution (720p)
    local target_width=1280
    local target_height=720

    echo "Compressing (Chat Optimized): $filepath -> $output_filepath"

    # Notes on settings:
    # -vf scale: Resizes to fit within 1280x720, keeping aspect ratio. Crucial for size reduction.
    # -preset medium: Good balance of speed and compression efficiency. 'fast' is quicker but less efficient.
    # -tune animation: Often good for screen recordings, may help general video too. Remove if causing issues.
    # -crf 26: Adjust this value! Higher = smaller file/lower quality (try 27, 28). Lower = larger file/better quality (try 25, 24). 26 is a middle ground.
    # -b:a 96k: Decent audio for chat. Can reduce to 64k for smaller files if audio is just simple voice.
    # -r <fps>: Uncomment and set (e.g., -r 20) to reduce frame rate for further size savings if motion isn't critical.

    ffmpeg -i "${filepath}" \
        -vf "scale=w=${target_width}:h=${target_height}:force_original_aspect_ratio=decrease,setsar=1" \
        -c:v libx264 \
        -preset medium \
        -tune animation \
        -crf 26 \
        -pix_fmt yuv420p \
        -c:a aac \
        -b:a 96k \
        -movflags +faststart \
        "${output_filepath}"
        # Optional: Reduce frame rate (e.g., -r 20 or -r 15) for significant size reduction
        # -r 20 \

    if [[ $? -eq 0 ]]; then
        echo "Chat Optimized Compression successful: ${output_filepath}"
    else
        echo "Error during Chat Optimized Compression."
        return 1
    fi
}


trimv() {
    local filepath="$1"
    extract_path_components "$filepath"
    # e.g. 00:01:00 
    ffmpeg -ss "$2" -to "$3" -i "${filepath}" -c copy "${SPLIT_DIRECTORY}/${SPLIT_FILENAME}-trim.${SPLIT_EXTENSION}" 
}

notify() {
  osascript -e "display notification \"$1\" with title \"Notify\""
}

alias lt="eza --tree --icons --git -L=3";
alias ltl="lt --long";
