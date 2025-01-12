#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"

# Input file containing the commands
commands_file="submission_command.txt"

# Loop through each line in the commands file
while IFS= read -r command; do
    # Extract the output file name from the -p parameter
    output_file=$(echo "$command" | grep -oP '(?<=-p )[^\s]+' | awk '{print $1".tsv"}')

    # Check if the output file exists
    if dx ls "GBA1/$output_file" > /dev/null 2>&1; then
        echo "Output file '$output_file' already exists. Skipping..."
    else
        echo "Output file '$output_file' not found. Running command..."
        eval "$command"
    fi
done < "$commands_file"


# dont run the first one. it's finished