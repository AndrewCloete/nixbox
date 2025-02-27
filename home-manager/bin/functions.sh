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
