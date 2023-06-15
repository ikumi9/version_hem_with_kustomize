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

# Path to the Chart.yaml file
chart_path="./charts/elasticsearch/Chart.yaml"

# Call the function to get the version number
version=$(get_version_number "$chart_path")

echo "$version"
# ################## INCREMENT VERSION #####################
increment_type='patch'

# Split the version number into its components
IFS='.' read -ra version_parts <<<"$version"

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

# Validate the arguments
if [ -z "$version" ]; then
    echo "Usage: $0 <version> [<increment>]"
    exit 1
fi

# ################## INCREMENT VERSION END #####################

# ################## UPDATE VERSION IN FILE  #####################
CHART_PATH="./charts/elasticsearch/Chart.yaml"

# Check if the file exists
if [ -f "$CHART_PATH" ]; then
    # Update the version number in Chart.yaml using sed
    sed -i .bak "s/version: .*/version: $new_version/" "$CHART_PATH"
    echo "Chart.yaml updated with new version: $new_version"
else
    echo "Chart.yaml not found at $CHART_PATH"
    exit 1
fi
# ################## UPDATE VERSION IN FILE END #####################

export ChartVersion=new_version

kustomize build . --enable-helm
