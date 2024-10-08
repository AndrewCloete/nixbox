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

fdcd() {
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

alias lt="eza --tree --icons --git -L=3";
alias ltl="lt --long";
