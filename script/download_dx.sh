#!/bin/bash

## how to use
### bash download_dx.sh $destination_local $target_dir_dx

export PATH="$HOME/.local/bin:$PATH"

destination_dir=$1
dx_project="project-GvFxJ08J95KXx97XFz8g2X2g"
dx_folder=$2

# Ensure destination directory exists
mkdir -p "$destination_dir"

# List files in the DNAnexus folder
for file in $(dx ls "$dx_project:$dx_folder"); do
    # Check if the file already exists locally
    if [ ! -f "$destination_dir/$file" ]; then
        echo "Downloading $file..."
        dx download "$dx_project:$dx_folder/$file" -o "$destination_dir/$file"
    else
        echo "Skipping $file (already exists)"
    fi
done
