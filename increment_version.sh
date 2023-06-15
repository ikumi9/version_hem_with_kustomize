#!/bin/bash

version=$1
increment=${2:-patch}

# Function to increment the version number
increment_version() {
    local current_version=$1
    local increment_type=$2

    # Split the version number into its components
    IFS='.' read -ra version_parts <<<"$current_version"

    # Determine which part to increment and update it
    case $increment_type in
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
        echo "Invalid increment type. Please specify 'major', 'minor', or 'patch'."
        exit 1
        ;;
    esac

    # Join the version parts back together
    new_version=$(
        IFS='.'
        echo "${version_parts[*]}"
    )
    echo "$new_version"
}

# Validate the arguments
if [ -z "$version" ]; then
    echo "Usage: $0 <version> [<increment>]"
    exit 1
fi

# Increment the version
new_version=$(increment_version "$version" "$increment")
echo "$new_version"
