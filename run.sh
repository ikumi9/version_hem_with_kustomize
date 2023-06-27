#!/bin/bash

# Function to extract the version number from Chart.yaml
get_version_number() {
    local file_path=$1
    local version_number

    # Check if the file exists
    if [ -f "$file_path" ]; then
        # Extract the version number using awk
        version_number=$(awk '/^version:/ {print $2}' "$file_path")
        echo "$version_number"
    else
        echo "Chart.yaml not found at $file_path"
        exit 1
    fi
}

# Default values
update_version=true
release_type="patch"

# Process script arguments
for arg in "$@"; do
    case $arg in
    --update-version=*)
        update_version="${arg#*=}"
        ;;
    --release=*)
        release_type="${arg#*=}"
        ;;
    --chart-path=*)
        chart_path="${arg#*=}"
        ;;
    esac
done

# Call the function to get the version number
version=$(get_version_number "$chart_path")

if [ "$update_version" = true ]; then
    # Split the version number into its components
    IFS='.' read -ra version_parts <<<"$version"

    # Determine which part to increment and update it
    case $release_type in
    "major")
        ((version_parts[0]++))
        version_parts[1]=0
        version_parts[2]=0
        ;;
    "minor")
        ((version_parts[1]++))
        version_parts[2]=0
        ;;
    "patch")
        ((version_parts[2]++))
        ;;
    *)
        echo "Invalid release type. Please specify 'major', 'minor', or 'patch'."
        exit 1
        ;;
    esac

    # Join the version parts back together
    new_version=$(
        IFS='.'
        echo "${version_parts[*]}"
    )
else
    new_version="$version"
fi

echo "$new_version"

# Validate the arguments
if [ -z "$version" ]; then
    echo "Usage: $0 --chart-path=<path_to_chart> [--update-version=<true/false>] [--release=<major/minor/patch>]"
    exit 1
fi

# ################## UPDATE VERSION IN FILE  #####################

# Check if the file exists
if [ -f "$chart_path" ]; then
    # Update the version number in Chart.yaml using sed
    sed -i "s/^version: .*/version: $new_version/g" "$chart_path"
    echo "Chart.yaml updated with new version: $new_version"
else
    echo "Chart.yaml not found at $chart_path"
    exit 1
fi
# ################## UPDATE VERSION IN FILE END #####################

export ChartVersion="$new_version"

kustomize build . --enable-helm
