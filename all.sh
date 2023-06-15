#!/bin/bash

# Variables
CHART_PATH="./charts/elasticsearch/Chart.yaml"
VERSION_SCRIPT="./get_version.sh"
INCREMENT_SCRIPT="./increment_version.sh"

# Function to get the version number
get_version() {
    echo "Getting version number..."
    version=$("$VERSION_SCRIPT")
    echo "Version: $version"
}

# Function to increment the version
increment_version() {
    echo "Incrementing version..."
    version=$("$VERSION_SCRIPT")
    increment_type=${1:-patch}
    new_version=$("$INCREMENT_SCRIPT" "$version" "$increment_type")
    echo $new_version
}

update_chart_file_with_new_version() {

    local file_path="$CHART_PATH"
    local new_version=$(increment_version)
    echo "NEW=> $new_version"

    # Check if the file exists
    if [ -f "$file_path" ]; then
        # Update the version number in Chart.yaml using sed
        sed -e 's/version: \([0-9]\+\.[0-9]\+\.[0-9]\)/version: $new_version/g' "$file_path"
        echo "Chart.yaml updated with new version: $new_version"
    else
        echo "Chart.yaml not found at $file_path"
        exit 1
    fi

}
# Function to call get_version and increment_version
run() {
    get_version
    echo ""
    increment_version "$1"
    update_chart_file_with_new_version
}

# Validate the increment argument
validate_increment() {
    if [ -z "$1" ]; then
        increment_type="patch"
    else
        increment_type="$1"
    fi
}

# Add execute permission to the scripts
chmod +x "$VERSION_SCRIPT"
chmod +x "$INCREMENT_SCRIPT"

# Main script

# Default target
run

# Command line arguments
if [ "$1" == "run" ]; then
    validate_increment "$2"
    run "$increment_type"
elif [ "$1" == "get_version" ]; then
    get_version
elif [ "$1" == "increment_version" ]; then
    validate_increment "$2"
    increment_version "$increment_type"
else
    # echo "Usage: $0 [run | get_version | increment_version | run <increment_type>]"
    exit 1
fi
