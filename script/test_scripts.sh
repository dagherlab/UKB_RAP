# Set your parameters
bed_file="cem_150.GRCh38.bed"    # Replace with your actual BED file name
index_file="../helper_files/graphtyper_pvcf_coordinates.csv"     # Replace with your actual index file name
out="your_output_directory"     # Replace with your actual output directory

# Create an empty list to hold the relevant batch files
relevant_batches=()

# Read the BED file line by line
while IFS=$'\t' read -r chr start end gene; do
  # Read the index file to locate relevant batch files
  while IFS=',' read -r file_name chromosome starting_position; do
    # Ensure chromosome matches and the range overlaps
    if [[ "$chr" == "chr$chromoso
    me" && "$end" -ge "$starting_position" && "$start" -le "$(($starting_position + 19999))" ]]; then
      relevant_batches+=("$file_name")
    fi
  done < "$index_file"
done < "$bed_file"

relevant_batches=($(echo "${relevant_batches[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))


echo $relevant_batches