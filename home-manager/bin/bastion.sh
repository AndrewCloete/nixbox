# Global variables for connection state
declare -g GKE_PROXY_PORT=""
declare -g GKE_BASTION_INSTANCE=""
declare -g GKE_OLD_PROXY=""

# Define cleanup function globally
function __gke_cleanup() {
    if [[ -n "$GKE_PROXY_PORT" ]]; then
        export HTTPS_PROXY="$GKE_OLD_PROXY"
        pkill -f "ssh.*$GKE_BASTION_INSTANCE.*$GKE_PROXY_PORT" >/dev/null 2>&1
        unset -f kubectl
        echo "Disconnected from cluster"
        GKE_PROXY_PORT=""
        GKE_OLD_PROXY=""
    fi
}

# Set global trap
trap __gke_cleanup EXIT

function gke_connect() {
    local usage="
Usage: gke_connect <cluster> <zone> <project> [--port <port>] [--instance <instance>]

Connect to a GKE cluster through a bastion host.

Arguments:
    cluster     The name of the GKE cluster
    zone        The zone/region where the cluster is located
    project     The GCP project ID
    --port      Optional: The local port to use for the proxy (default: 8888)
    --instance  Optional: The instance name (default: bastion)

Examples:
    gke_connect my-cluster europe-west1-c my-project
    gke_connect my-cluster europe-west1-c my-project --port 8889 --instance my-instance"

    # Show help if requested
    for arg in "$@"; do
        if [[ "$arg" == "--help" ]] || [[ "$arg" == "-h" ]]; then
            echo "$usage" >&2
            return 0
        fi
    done

    # Initialize defaults
    local port="8888"
    local instance="bastion"
    local cluster=""
    local zone=""
    local project=""

    # Parse arguments
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --port)
                port="$2"
                shift 2
                ;;
            --instance)
                instance="$2"
                shift 2
                ;;
            *)
                if [ -z "$cluster" ]; then
                    cluster="$1"
                elif [ -z "$zone" ]; then
                    zone="$1"
                elif [ -z "$project" ]; then
                    project="$1"
                else
                    echo "Error: Too many arguments" >&2
                    echo "$usage" >&2
                    return 1
                fi
                shift
                ;;
        esac
    done

    # Validate required parameters
    if [ -z "$cluster" ] || [ -z "$zone" ] || [ -z "$project" ]; then
        echo "Error: Missing required arguments" >&2
        echo "$usage" >&2
        return 1
    fi
    
    # Check if tunnel already exists
    if pgrep -f "ssh.*$instance.*:$port"; then
        echo "Error: Tunnel already exists. Please run gke_disconnect first."
        return 1
    fi

    # Check if the user has the correct IAM roles
    assigned_roles=$(gcloud projects get-iam-policy $project --flatten="bindings[].members" --filter="bindings.members:$(gcloud config get-value account)" --format="value(bindings.role)" 2>/dev/null)
    if echo "$assigned_roles" | grep -q "roles/iap.tunnelResourceAccessor" && \
        echo "$assigned_roles" | grep -q "roles/iam.roleViewer" && \
        echo "$assigned_roles" | grep -q "roles/iam.serviceAccountViewer" && \
        echo "$assigned_roles" | grep -q "roles/compute.osLogin"; then
        echo "User has required roles: roles/iap.tunnelResourceAccessor, roles/compute.osLogin, roles/iam.serviceAccountViewer, and roles/iam.roleViewer"
    else
        echo "WARNING: Missing roles:"
        [[ -z $(echo "$assigned_roles" | grep "roles/iap.tunnelResourceAccessor") ]] && echo "  - roles/iap.tunnelResourceAccessor"
        [[ -z $(echo "$assigned_roles" | grep "roles/iam.roleViewer") ]] && echo "  - roles/iam.roleViewer"
        [[ -z $(echo "$assigned_roles" | grep "roles/iam.serviceAccountViewer") ]] && echo "  - roles/iam.serviceAccountViewer"
        [[ -z $(echo "$assigned_roles" | grep "roles/compute.osLogin") ]] && echo "  - roles/compute.osLogin"
    fi

    bastion_sa=$(gcloud compute instances describe "$instance" \
    --zone "$zone" \
    --format="get(serviceAccounts.email)" \
    --project="${project}")

    if [ -z "$bastion_sa" ]; then
    echo "No service account is associated with the instance ${instance}."
    exit 1
    fi

    bastion_sa_members=$(gcloud iam service-accounts get-iam-policy "$bastion_sa" \
    --flatten="bindings[].members" \
    --filter="bindings.role:roles/iam.serviceAccountUser" \
    --format="value(bindings.members)" \
    --project="${project}")

    if echo "$bastion_sa_members" | grep -q "$(gcloud config get account)"; then
        echo "User $(gcloud config get account) has the serviceAccountUser role on service account $bastion_sa"
    else
        echo "WARNING: User $(gcloud config get account) does NOT have the serviceAccountUser role on service account $bastion_sa"
    fi
    
    # Store the original proxy settings globally
    GKE_OLD_PROXY="$HTTPS_PROXY"
    GKE_PROXY_PORT="$port"
    GKE_BASTION_INSTANCE="$instance"
    
    echo "Connecting to cluster $cluster in $zone..."
    
    # Get cluster credentials
    if ! gcloud container clusters get-credentials "$cluster" \
        --region="$zone" \
        --project="$project"; then
        echo "Error: Failed to get cluster credentials"
        return 1
    fi
    
    # Start SSH tunnel with keep-alive settings
    if ! gcloud compute ssh $instance \
        --tunnel-through-iap \
        --project="$project" \
        --zone="$zone" \
        --ssh-flag="-4 -L${port}:localhost:${port} -N -q -f -o ServerAliveInterval=60 -o ServerAliveCountMax=10"; then
        echo "Error: Failed to establish SSH tunnel"
        return 1
    fi

    # Set new proxy for kubectl
    function kubectl() {
        HTTPS_PROXY=localhost:$GKE_PROXY_PORT command kubectl "$@"
    }

    # Set new proxy for helm
    function helm() {
        HTTPS_PROXY=localhost:$GKE_PROXY_PORT command helm "$@"
    }

    # Set new proxy for helmfile
    function helmfile() {
        HTTPS_PROXY=localhost:$GKE_PROXY_PORT command helmfile "$@"
    }

    # Set new proxy for k9s
    function k9s() {
        HTTPS_PROXY=localhost:$GKE_PROXY_PORT command k9s "$@"
    }

    # TODO: Add more proxies here!
    
    echo "Connected! kubectl, helm, helmfile, and k9s commands are now proxied through the bastion host"
}

function gke_disconnect() {
    local usage="
Usage: gke_disconnect [--port <port>] [--instance <instance>]

Disconnect from the GKE cluster and clean up the SSH tunnel.

Arguments:
    --port      Optional: The port number to disconnect (default: ${GKE_PROXY_PORT:-8888})
    --instance  Optional: The bastion instance name (default: ${GKE_BASTION_INSTANCE:-bastion})"

    # Show help if requested
    for arg in "$@"; do
        if [[ "$arg" == "--help" ]] || [[ "$arg" == "-h" ]]; then
            echo "$usage" >&2
            return 0
        fi
    done

    # Initialize defaults from environment variables
    local port="${GKE_PROXY_PORT:-8888}"
    local instance="${GKE_BASTION_INSTANCE:-bastion}"

    # Parse arguments
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            --port)
                port="$2"
                shift 2
                ;;
            --instance)
                instance="$2"
                shift 2
                ;;
            *)
                echo "Error: Unknown argument $1" >&2
                echo "$usage" >&2
                return 1
                ;;
        esac
    done
    if pkill -f "ssh.*$instance.*$port"; then
        unset -f kubectl
        unset -f helm
        unset -f helmfile
        unset -f k9s
        GKE_PROXY_PORT=""
        GKE_OLD_PROXY=""
        echo "Disconnected from cluster"
    else
        echo "Error: No active connection found"
        return 1
    fi
}
