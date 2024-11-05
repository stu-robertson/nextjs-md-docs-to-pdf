#!/bin/bash

# Get the directory of the current script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Check if the folder already exists
check_docs_folder_exists() {
    local docs_folder="$1"
    local display_global_info="$2"
    local flag="EMPTY"
    local folder_path="$DIR/../../../work/$docs_folder"

    if [ -d "$folder_path" ]; then
        echo -e "A folder with the same name already exists: \e[94m$docs_folder\e[0m"
        echo -e "\n"
        echo "Would you like to remove the existing folder and start with a new clone?"

        select yn in "Yes" "No"; do
            case $yn in
                Yes )
                    rm -rf "$folder_path"
                    rm -rf "$folder_path.md"
                    flag="DELETED"
                    break
                    ;;
                No )
                    flag="CONTINUE"
                    break
                    ;;
            esac
        done
    else
        flag="NOT_EXIST"
    fi

    if [ "$flag" = "NOT_EXIST" ]; then
        "$display_global_info" "Docs folder does not exist" "yes"
    fi

    if [ "$flag" = "DELETED" ]; then
        "$display_global_info" "Docs folder removed successfully" "yes"
        # Ensure that the directory is fully removed before proceeding
        while [ -d "$folder_path" ]; do
            sleep 1  # Wait until the folder is fully deleted
        done
    fi

    if [ "$flag" = "DELETED" ] || [ "$flag" = "NOT_EXIST" ]; then
        mkdir -p "$folder_path"  # Ensure directory is re-created for cloning
        "$display_global_info" "Clone the docs" "yes"
        return 1  # Indicate the folder has been deleted or doesn't exist
    else
        return 2  # Indicate the folder already exists and should not be cloned again
    fi
}
