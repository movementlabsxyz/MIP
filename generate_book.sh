#!/usr/bin/env bash

# Exit script on error
set -e

# Variables
GITHUB_OWNER="movementlabsxyz"
GITHUB_REPO="MIP"
API_URL="https://api.github.com"

# Use GITHUB_TOKEN from environment variable for authentication
AUTH_HEADER="Authorization: token $GITHUB_TOKEN"  # Remove hardcoded token

# Check if jq is installed
if ! command -v jq >/dev/null 2>&1; then
    echo "jq not found. Please install jq to run this script."
    exit 1
fi

# Remove src folder if it exists
rm -rf src

# Create src folder
mkdir -p src

# Generate book.toml file with the correct title and GitHub repository
cat >book.toml <<EOL
[book]
title = "MIP"

[output.html]
smart-punctuation = true
no-section-label = true
git-repository-url = "https://github.com/movementlabsxyz/MIP"
site-url = "/MIP/"

[output.html.search]
heading-split-level = 0

[output.html.playground]
runnable = false
EOL

# Clone MIP repository
rm -rf MIP_repo
git clone --mirror https://github.com/movementlabsxyz/MIP.git MIP_repo

cd MIP_repo

# Fetch all branches
git fetch --all

# Get list of branches
branches=$(git for-each-ref --format='%(refname:short)' refs/heads/)

cd ..

# Function to URL-encode a string using jq
urlencode() {
    local string="${1}"
    local encoded
    encoded=$(jq -rn --arg str "$string" '$str|@uri')
    echo "${encoded}"
}

# Function to sanitize titles for folder names
sanitize_title_for_folder() {
    local title="$1"
    title="${title// /_}"                # Replace spaces with underscores
    title="${title//[\\\`*()#\+!|\/]/}"  # Remove specific special characters
    echo "$title"
}

# Function to sanitize titles for use in SUMMARY.md
sanitize_title_for_summary() {
    local title="$1"
    title="${title//\\/}"      # Remove backslashes
    title="${title//\`/}"      # Remove backticks
    title="${title//\"/}"      # Remove double quotes
    title="${title//\[/}"      # Remove [
    title="${title//\]/}"      # Remove ]
    title="${title//\(/}"      # Remove (
    title="${title//\)/}"      # Remove )
    title="${title//:/ -}"     # Replace colon with hyphen
    title="${title//\*/}"      # Remove asterisks
    title="${title//\$/}"      # Remove dollar signs
    title="${title//_/ }"      # Replace underscores with spaces
    title="${title//\{/}"      # Remove {
    title="${title//\}/}"      # Remove }
    title="${title//</}"       # Remove <
    title="${title//>/}"       # Remove >
    echo "$title"
}

# Initialize README and SUMMARY.md
initialize_glossary_and_summary() {
    mkdir -p glossary_parts
    echo "# Welcome to the Movement Network MIP Book" > src/README.md
    echo "" >> src/README.md
    echo "# Summary" > src/SUMMARY.md
    echo "" >> src/SUMMARY.md
}

# Initialize associative arrays to collect entries and approved MIP/MD numbers
declare -A entries_readme
declare -A entries_summary
declare -A approved_mips   # To store approved MIP numbers
declare -A approved_mds    # To store approved MD numbers

# Function to process README files
process_readme_files() {
    local base_path="$1"
    local category="$2"
    local type="$3"
    local mip_number="$4"
    local branch="$5"

    local folder="$base_path/$type/$type-$mip_number"
    if [ -d "$folder" ] && [ -f "$folder/README.md" ]; then
        readme_title=$(grep -m 1 '^# ' "$folder/README.md" | sed 's/^# //')
        [ -z "$readme_title" ] && readme_title="$folder"
        relative_path="${folder#src/}"

        # For links in README.md (homepage), point to the directory
        link_path_readme="$relative_path/index.html"
        # For links in SUMMARY.md (sidebar), point to the README.md file
        link_path_summary="$relative_path/README.md"

        # Create a unique key
        entry_key="$category|$type|$mip_number|$branch"

        # Store entries for Approved and Review
        entries_readme["$entry_key"]="- [$readme_title]($link_path_readme)"
        entries_summary["$entry_key"]="- [$readme_title]($link_path_summary)"

        # If this is the Approved category, store the MIP/MD number to prevent duplicates in Review
        if [ "$category" == "Approved" ]; then
            if [ "$type" == "MIP" ]; then
                approved_mips["$mip_number"]=1
            elif [ "$type" == "MD" ]; then
                approved_mds["$mip_number"]=1
            fi
        fi
    fi
}

# Function to process the main branch (Approved category)
process_main_branch() {
    local branch="main"
    local category="Approved"

    mkdir -p "src/$category/$branch"
    branch_temp_dir=$(mktemp -d)
    echo "Created temp directory for main branch: $branch_temp_dir"

    if ! git --git-dir=MIP_repo --work-tree="$branch_temp_dir" checkout -f "$branch"; then
        echo "Error: Failed to checkout main branch"
        rm -rf "$branch_temp_dir"
        exit 1  # Cannot proceed without the main branch
    fi

    for type in "MD" "MIP"; do
        local type_lower=$(echo "$type" | tr '[:upper:]' '[:lower:]')
        local type_upper="$type"
        local type_dir="$branch_temp_dir/$type_lower"
        if [ ! -d "$type_dir" ]; then
            echo "Directory $type_dir does not exist in main branch. Skipping."
            continue
        fi

        for folder in "$type_dir"/*; do
            folder_name=$(basename "$folder")

            # Skip folders named md-0 or mip-0
            if [[ "$folder_name" == "${type_lower}-0" ]]; then
                echo "Skipping folder $folder_name in main branch because it is ${type_upper}-0."
                continue
            fi

            # Skip folders that do not match the expected pattern
            if [[ ! "$folder_name" =~ ^${type_lower}-[0-9]+$ ]]; then
                echo "Skipping folder $folder_name in main branch because it does not match the expected naming convention."
                continue
            fi

            # Extract the MIP/MD number
            mip_number=$(echo "$folder_name" | grep -o '[0-9]\+')

            # Check if mip_number is empty
            if [ -z "$mip_number" ]; then
                echo "Skipping folder $folder_name in main branch because it does not contain a valid MIP/MD number."
                continue
            fi

            # Process folder if it contains a README.md
            if [ -d "$folder" ] && [ -f "$folder/README.md" ]; then
                # Copy folder to the Approved category in src
                mkdir -p "src/$category/$branch/$type"
                cp -r "$folder" "src/$category/$branch/$type/$folder_name"

                # Process the README files for main and sidebar links
                process_readme_files "src/$category/$branch" "$category" "$type" "$mip_number" "$branch"
            fi
        done
    done

    rm -rf "$branch_temp_dir"
}

# Function to copy content from a branch, processing all MIP/MD directories
copy_branch_content() {
    local branch="$1"
    local category="$2"


    # Check if the branch is associated with a draft PR
    branch_url_encoded=$(urlencode "$branch")
    pr_info=$(curl -s -H "$AUTH_HEADER" "$API_URL/repos/$GITHUB_OWNER/$GITHUB_REPO/pulls?head=$GITHUB_OWNER:$branch_url_encoded&state=open")

    # Check if there's a PR
    pr_count=$(echo "$pr_info" | jq '. | length')

    if [ "$pr_count" -eq 0 ]; then
        echo "No open PR associated with branch $branch. Skipping."
        return  # Skip to the next branch
    fi

    # Check if the PR is a draft
    is_draft=$(echo "$pr_info" | jq '.[0].draft')

    if [ "$is_draft" == "true" ]; then
        echo "Branch $branch is associated with a draft PR. Skipping."
        return  # Skip to the next branch
    fi

    mkdir -p "src/$category/$branch"
    branch_temp_dir=$(mktemp -d)
    echo "Created temp directory for branch $branch: $branch_temp_dir"

    if ! git --git-dir=MIP_repo --work-tree="$branch_temp_dir" checkout -f "$branch"; then
        echo "Error: Failed to checkout branch $branch"
        rm -rf "$branch_temp_dir"
        return  # Skip to the next branch
    fi

    for type in "MD" "MIP"; do
        local type_lower=$(echo "$type" | tr '[:upper:]' '[:lower:]')
        local type_upper="$type"
        local type_dir="$branch_temp_dir/$type_lower"
        if [ ! -d "$type_dir" ]; then
            echo "Directory $type_dir does not exist in branch $branch. Skipping."
            continue
        fi

        for folder in "$type_dir"/*; do
            folder_name=$(basename "$folder")

            # Skip folders named md-0 or mip-0
            if [[ "$folder_name" == "${type_lower}-0" ]]; then
                echo "Skipping folder $folder_name in branch $branch because it is ${type_upper}-0."
                continue
            fi

            # Skip folders that do not match the expected pattern
            if [[ ! "$folder_name" =~ ^${type_lower}-[0-9]+$ ]]; then
                echo "Skipping folder $folder_name in branch $branch because it does not match the expected naming convention."
                continue
            fi

            # Extract the MIP/MD number
            mip_number=$(echo "$folder_name" | grep -o '[0-9]\+')

            # Check if mip_number is empty
            if [ -z "$mip_number" ]; then
                echo "Skipping folder $folder_name in branch $branch because it does not contain a valid MIP/MD number."
                continue
            fi

            # Skip entry if it's already in Approved
            if [ "$type" == "MIP" ] && [[ "${approved_mips["$mip_number"]}" == 1 ]]; then
                echo "Skipping MIP-$mip_number in branch $branch because it already exists in Approved."
                continue
            elif [ "$type" == "MD" ] && [[ "${approved_mds["$mip_number"]}" == 1 ]]; then
                echo "Skipping MD-$mip_number in branch $branch because it already exists in Approved."
                continue
            fi

            # Process folder if it contains a README.md
            if [ -d "$folder" ] && [ -f "$folder/README.md" ]; then
                # Copy folder to the Review category in src
                mkdir -p "src/$category/$branch/$type"
                cp -r "$folder" "src/$category/$branch/$type/$folder_name"

                # Process the README files for main and sidebar links
                process_readme_files "src/$category/$branch" "$category" "$type" "$mip_number" "$branch"
            fi
        done
    done

    rm -rf "$branch_temp_dir"
}

initialize_glossary_and_summary

# Process main branch (Approved category)
process_main_branch

# Process other branches (Review category)
for branch in $branches; do
    echo "Processing branch: $branch"
    if [ "$branch" = "main" ]; then
        continue  # Already processed main branch
    fi

    # Process all MIPs/MDs in the branch
    copy_branch_content "$branch" "Review"
done

# Write the collected entries to README.md and SUMMARY.md
for category in "Approved" "Review"; do
    echo "Processing category: $category"
    sanitized_category_name=$(sanitize_title_for_summary "$category")

    echo "Approved mips: ${!approved_mips[@]}"
    echo "Approved mds: ${!approved_mds[@]}"

    echo "## $category" >> src/README.md
    echo "" >> src/README.md
    echo "- [$sanitized_category_name](README.md)" >> src/SUMMARY.md

    # clear existing arrays to avoid duplicates
    unset md_entries_readme
    unset mip_entries_readme
    unset md_entries_summary
    unset mip_entries_summary

    # Initialize arrays to collect entries
    declare -a md_entries_readme
    declare -a mip_entries_readme
    declare -a md_entries_summary
    declare -a mip_entries_summary

    # Collect entries for this category
    for key in "${!entries_readme[@]}"; do
        IFS='|' read -r entry_category type mip_number branch <<< "$key"
        if [ "$entry_category" == "$category" ]; then
        echo "Processing entry: $key"
            # Skip entries in Review category if the MIP/MD number is already in Approved
            if [ "$category" == "Review" ]; then
                if [ "$type" == "MIP" ] && [[ "${approved_mips[$mip_number]}" == 1 ]]; then
                    echo "Skipping MIP-$mip_number in Review because it already exists in Approved."
                    continue
                elif [ "$type" == "MD" ] && [[ "${approved_mds[$mip_number]}" == 1 ]]; then
                    echo "Skipping MD-$mip_number in Review because it already exists in Approved."
                    continue
                fi
            fi
            if [ "$type" == "MD" ]; then
                md_entries_readme+=("${entries_readme[$key]}")
                md_entries_summary+=("${entries_summary[$key]}")
            else
                mip_entries_readme+=("${entries_readme[$key]}")
                mip_entries_summary+=("${entries_summary[$key]}")
            fi
        fi
    done

    echo "MD entries for $category: ${md_entries_readme[@]}"
    echo "MIP entries for $category: ${mip_entries_readme[@]}"

    # Sort the entries using natural sort (version sort) for correct ordering
    IFS=$'\n' md_entries_readme=($(sort -V <<<"${md_entries_readme[*]}"))
    IFS=$'\n' mip_entries_readme=($(sort -V <<<"${mip_entries_readme[*]}"))
    IFS=$'\n' md_entries_summary=($(sort -V <<<"${md_entries_summary[*]}"))
    IFS=$'\n' mip_entries_summary=($(sort -V <<<"${mip_entries_summary[*]}"))
    unset IFS

    # Add MIPs to README.md and SUMMARY.md
    if [ ${#mip_entries_readme[@]} -gt 0 ]; then
        echo "### MIPs" >> src/README.md
        for entry in "${mip_entries_readme[@]}"; do
            echo "$entry" >> src/README.md
        done

        echo "  - [MIPs](README.md)" >> src/SUMMARY.md
        for entry in "${mip_entries_summary[@]}"; do
            if [[ "$entry" == "- "* ]]; then
                link_line="${entry#- }"
                link_text="${link_line%%]*}"
                link_text="${link_text#\[}"
                link_url="${link_line##*\(}"
                link_url="${link_url%\)}"
                echo "    - [$link_text]($link_url)" >> src/SUMMARY.md
            fi
        done
    fi

    # Add MDs to README.md and SUMMARY.md
    if [ ${#md_entries_readme[@]} -gt 0 ]; then
        echo "### MDs" >> src/README.md
        for entry in "${md_entries_readme[@]}"; do
            echo "$entry" >> src/README.md
        done

        echo "  - [MDs](README.md)" >> src/SUMMARY.md
        for entry in "${md_entries_summary[@]}"; do
            if [[ "$entry" == "- "* ]]; then
                link_line="${entry#- }"
                link_text="${link_line%%]*}"
                link_text="${link_text#\[}"
                link_url="${link_line##*\(}"
                link_url="${link_url%\)}"
                echo "    - [$link_text]($link_url)" >> src/SUMMARY.md
            fi
        done
    fi

    echo "" >> src/README.md
    echo "" >> src/SUMMARY.md
done

# Build the book
if ! mdbook build; then
    echo "Error: mdbook failed to build. Please check the SUMMARY.md for syntax errors."
    exit 1
fi