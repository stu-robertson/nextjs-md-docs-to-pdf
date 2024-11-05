#!/bin/bash

# Get the directory of the current script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Check if the docs folder exists on the remote repository
clone_docs_folder() {
    local repo_owner="vercel"
    local repo_name="next.js"
    local docs_folder="$1"

    # Check if the 'docs' folder exists in the repository
    local response=$(curl --head -s -o /dev/null -w "%{http_code}" "https://api.github.com/repos/$repo_owner/$repo_name/contents/docs")
    
    if [ "$response" = "200" ]; then
        echo "The 'docs' folder exists in the remote repository."
        start_clone_docs_folder "$docs_folder"
    else
        echo "The 'docs' folder does not exist in the remote repository."
        exit 1  # Exit with an error if the 'docs' folder isn't found
    fi
}

# Clone the docs folder using sparse checkout
start_clone_docs_folder() {
    local folder_path="$DIR/../../../work"
    local docs_folder="$1"

    # Ensure the work directory exists
    mkdir -p "$folder_path"

    # Clone directly into the work directory
    git clone https://github.com/vercel/next.js.git "$folder_path/next.js" --depth 1 --filter=blob:none --sparse

    # Check if cloning was successful
    if [ ! -d "$folder_path/next.js" ]; then
        echo "Error: Cloning the repository failed."
        exit 1
    fi

    # Navigate to the cloned repository and set up sparse checkout
    cd "$folder_path/next.js" || { echo "Error: Unable to navigate to $folder_path/next.js"; exit 1; }
    git sparse-checkout init --cone
    git sparse-checkout set docs

    # Move the docs folder to the desired location and clean up
    mv ./docs "../$docs_folder" && cd "$folder_path" && rm -rf next.js

    # Check if the docs folder was moved successfully
    if [ -d "$folder_path/$docs_folder" ]; then
        echo "Docs folder cloned successfully into $folder_path/$docs_folder"
    else
        echo "Error: Docs folder was not cloned successfully."
        exit 1
    fi
}

