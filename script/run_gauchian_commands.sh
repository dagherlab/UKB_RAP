#!/bin/bash

# Input file containing the commands
commands_file="commands.txt"

# Loop through each line in the commands file
while IFS= read -r command; do
    # Extract the output file name from the -p parameter
    output_file=$(echo "$command" | grep -oP '(?<=-p )[^\s]+' | awk '{print $1".tsv"}')

    # Check if the output file exists
    if [ -f "$output_file" ]; then
        echo "Output file '$output_file' already exists. Skipping..."
    else
        echo "Output file '$output_file' not found. Running command..."
        eval "$command"
    fi
done < "$commands_file"


# dont run the first one. it's finished