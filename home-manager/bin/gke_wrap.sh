GKE_PORT=8888
# Set new proxy for kubectl
function kubectl() {
    HTTPS_PROXY=localhost:$GKE_PORT command kubectl "$@"
}

# Set new proxy for helm
function helm() {
    HTTPS_PROXY=localhost:$GKE_PORT command helm "$@"
}

# Set new proxy for helmfile
function helmfile() {
    HTTPS_PROXY=localhost:$GKE_PORT command helmfile "$@"
}

# Set new proxy for k9s
function k9s() {
    HTTPS_PROXY=localhost:$GKE_PORT command k9s "$@"
}
