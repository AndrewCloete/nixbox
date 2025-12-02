funcs() {
    echo "fds: (f)ind and (s)ave to tmux clipboard"
    echo "fdv: (f)ind and (v)im a file"
    echo "cdg: (cd) to any file in the current (g)it repo"
    echo "cdt: (cd) to any file in the current (t)ree"
    echo "cdr: (cd) to the (r)oot of the current git project"
    echo "act: source .venv/bin/activate"
}
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

rgv() {
    local file
    file=$(rg "$1" -l | fzf)  

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

# (cd) to the (r)oot of the current git project
cdr() {
    cd "$(git rev-parse --show-toplevel)"
}

act() {
    source .venv/bin/activate
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


minv2() {
    local filepath="$1"
    extract_path_components "$filepath"
    ffmpeg -i "${filepath}" \
        -vf "scale=1920:1080" \
        -c:v libx264 \
        -preset medium \
        -crf 28 \
        -c:a aac \
        -b:a 64k \
        -movflags +faststart \
        "${SPLIT_DIRECTORY}/${SPLIT_FILENAME}-better-quality.mp4"
}

minv3 () {
        local filepath="$1"
        extract_path_components "$filepath"
        ffmpeg -i "${filepath}" -vf "scale=1920:1080" -c:v libx264 -preset veryfast -crf 23 -tune film -pix_fmt yuv420p -c:a aac -b:a 64k -movflags +faststart "${SPLIT_DIRECTORY}/${SPLIT_FILENAME}-mini.mp4"
}

minv_slow () {
        local filepath="$1"
        extract_path_components "$filepath"
        # Corrected: -preset faster and -tune animation for libx265
        ffmpeg -i "${filepath}" -c:v libx265 -preset faster -crf 23 -tune animation -pix_fmt yuv420p -tag:v hvc1 -c:a aac -b:a 64k -movflags +faststart "${SPLIT_DIRECTORY}/${SPLIT_FILENAME}-mini.mp4"
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


# K8s
alias kgp="kubectl get pods"
alias kcx="kubectl config set-context --current --namespace"


# Function to select a pod (compatible with Bash and Zsh)
function ksp() {

    kubectl get pods

    # Save the original Internal Field Separator (IFS)
    local old_ifs=$IFS
    # Set IFS to split only on newlines
    IFS=$'\n'

    # Read pod names into an array by splitting the command output on newlines
    local -a pods=($(kubectl get pods --no-headers -o custom-columns=NAME:.metadata.name))

    # Restore the original IFS
    IFS=$old_ifs

    # Check if any pods were found
    if [ ${#pods[@]} -eq 0 ]; then
        echo "❌ No pods found in the current namespace."
        return 1
    fi

    # Create an interactive menu using 'select'
    PS3="👉 Select a pod: "
    echo "Please select a pod to set as \$POD_NAME:"
    select pod_name in "${pods[@]}"; do
        if [ -n "$pod_name" ]; then
            export POD_NAME=$pod_name
            echo "✅ POD_NAME exported as: $POD_NAME"
            unset PS3
            break
        else
            echo "Invalid selection. Please try again."
        fi
    done
}

function kp() {
    echo ${POD_NAME}
}

function kdp() {
    kubectl describe pod ${POD_NAME}
}

function kl() {
    kubectl logs ${POD_NAME}
}

function klf() {
    kubectl logs ${POD_NAME} -f
}


last_files() {
    find . -type f -print0 | xargs -0 stat -c '%Y %n' | sort -rn | head -n $1 | cut -d' ' -f2-
}

function get_pod() {
  local PARTIAL_NAME="$1" # The first argument will be the partial name

  # Get the full name of the first running pod matching the partial name
  POD_FULL_NAME=$(kubectl get pods  --field-selector=status.phase=Running -o custom-columns=NAME:.metadata.name 2>/dev/null | \
                  grep "${PARTIAL_NAME}" | \
                  head -n 1)

  echo "$POD_FULL_NAME" # Output the found pod name
  
  # Return 0 for success, 1 for not found
  if [ -z "$POD_FULL_NAME" ]; then
    return 1
  else
    return 0
  fi
}


merge_vid() {
    DIR="${1:-.}"
    OUTPUT="${2:-output.mp4}"

    # Check dependencies
    if ! command -v ffmpeg &>/dev/null; then
      echo "Error: ffmpeg not found in PATH." >&2
      exit 1
    fi

    # Check directory
    if [[ ! -d "$DIR" ]]; then
      echo "Error: '$DIR' is not a directory." >&2
      exit 1
    fi

    # Create list file
    TMP_LIST="$(mktemp)"
    trap 'rm -f "$TMP_LIST"' EXIT

    # Find and sort video files (you can adjust extensions)
    find "$DIR" -maxdepth 1 -type f \
      \( -iname "*.mp4" -o -iname "*.mov" -o -iname "*.mkv" -o -iname "*.avi" \) \
      | sort | while read -r f; do
        # Escape single quotes for ffmpeg concat format
        printf "file '%s'\n" "$(realpath "$f" | sed "s/'/'\\\\''/g")" >> "$TMP_LIST"
      done

    # Ensure there are files
    if [[ ! -s "$TMP_LIST" ]]; then
      echo "Error: No video files found in $DIR" >&2
      exit 1
    fi

    echo "Merging videos listed in $TMP_LIST → $OUTPUT"
    ffmpeg -f concat -safe 0 -i "$TMP_LIST" -c copy "$OUTPUT"
    echo "✅ Merge complete: $OUTPUT"
}
