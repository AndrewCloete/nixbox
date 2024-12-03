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

mini_img() {
    local filepath="$1"
    extract_path_components "$filepath"
    magick "${filepath}" -quality 25 "${SPLIT_DIRECTORY}/${SPLIT_FILENAME}-mini.jpg"
}

mini_vid() {
    local filepath="$1"
    extract_path_components "$filepath"
    ffmpeg -i "${filepath}" -vf "scale=1280:720" -c:v libx264 -preset fast -crf 28 -c:a aac -b:a 64k -movflags +faststart "${SPLIT_DIRECTORY}/${SPLIT_FILENAME}-mini.mp4" 
}

alias lt="eza --tree --icons --git -L=3";
alias ltl="lt --long";
