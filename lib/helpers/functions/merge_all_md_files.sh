#!/bin/bash

# Get the directory of the current script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

merge_md_files() {
    local directory="$1"
    local output_file="$2"

    # Ensure the output directory exists
    mkdir -p "$(dirname "$output_file")"

    # Find all .md and .mdx files and merge them
    find "$directory" -type f \( -name "*.md" -o -name "*.mdx" \) | sort | while read -r md_file; do
        echo "Merging file: $md_file"  # Debugging line
        if [ -s "$md_file" ]; then
            echo "File $md_file has content."
            cat "$md_file" >> "$output_file"
            echo -e "\n\n" >> "$output_file"  # Add spacing between files
        else
            echo "File $md_file is empty or could not be read."
        fi
    done

    # Check if output file was created successfully
    if [ -s "$output_file" ]; then
        echo "Merged content written to $output_file"
    else
        echo "Error: The merged markdown file is empty."
        exit 1
    fi
}

merge_all_md_files() {
    local docs_folder="$1"
    local folder_path="$DIR/../../../work/$docs_folder"
    directory="$folder_path"
    output_file="$folder_path.md"
    merge_md_files "$directory" "$output_file"
}
