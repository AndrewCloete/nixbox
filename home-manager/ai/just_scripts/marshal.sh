#!/usr/bin/env bash
set -euo pipefail

target="$1"
sha=$(git rev-parse --short HEAD)
# context: short SHA is deliberate — scraper tooling only needs to identify the
# version, not do full commit lookups. Full SHA would be wasteful in frontmatter.
ts=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# --- Select constitution / skill items ---
defaults_items=""
while IFS= read -r f; do
    if awk 'BEGIN{n=0} /^---/{n++; next} n>1{exit} /^default: true$/{found=1} END{exit !found}' "$f"; then
        defaults_items="${defaults_items:+$defaults_items,}$f"
    fi
done < <(find constitutions skills -name "*.md" | sort)

items=$(find constitutions skills -name "*.md" | sort \
    | gum choose --no-limit \
        --header "Select items to marshal to '$target'" \
        ${defaults_items:+--selected="$defaults_items"})

# --- Select vendor stubs ---
all_vendor_labels=$(yq -r '.[] | .id + ": " + .description' config/vendors.yaml)
default_vendor_labels=$(yq -r '.[] | select(.default == true) | .id + ": " + .description' config/vendors.yaml \
    | paste -sd ',' -)

selected_vendors=$(echo "$all_vendor_labels" \
    | gum choose --no-limit \
        --header "Select vendor entrypoints (stubs pointing to AGENTS.md)" \
        ${default_vendor_labels:+--selected="$default_vendor_labels"})

# --- Write constitution / skill items ---
if [ -z "$items" ]; then
    echo "No items selected — skipping constitutions and skills."
else
    while IFS= read -r item; do
        dest="$target/$item"
        mkdir -p "$(dirname "$dest")"
        {
            printf -- '---\n'
            printf 'source_sha: %s\n' "$sha"
            printf 'marshalled_at: %s\n' "$ts"
            printf -- '---\n\n'
            awk 'BEGIN{n=0} /^---/{n++; next} n<2{next} {print}' "$item"
        } > "$dest"
        echo "marshalled: $item -> $dest"
    done <<< "$items"
fi

# context: AGENTS.md is written unconditionally — it is the vendor-agnostic
# canonical entrypoint that all vendor stubs redirect to. Making it optional
# would break the DRY contract: stubs would point to a file that may not exist.
# --- Write canonical AGENTS.md (always) ---
agents_dest="$target/AGENTS.md"
{
    printf -- '---\n'
    printf 'source_sha: %s\n' "$sha"
    printf 'marshalled_at: %s\n' "$ts"
    printf -- '---\n\n'
    cat templates/entrypoint.md
} > "$agents_dest"
echo "marshalled: AGENTS.md -> $agents_dest"

# --- Write vendor stubs ---
if [ -n "$selected_vendors" ]; then
    while IFS= read -r label; do
        vendor_id=$(echo "$label" | cut -d: -f1)
        vendor_file=$(yq -r ".[] | select(.id == \"$vendor_id\") | .file" config/vendors.yaml)
        vendor_desc=$(yq -r ".[] | select(.id == \"$vendor_id\") | .description" config/vendors.yaml)
        dest="$target/$vendor_file"
        mkdir -p "$(dirname "$dest")"
        printf '# %s\n\nRead `AGENTS.md` for AI agent instructions before starting any task.\n' \
            "$vendor_desc" > "$dest"
        echo "marshalled: $vendor_file -> $dest"
    done <<< "$selected_vendors"
fi
