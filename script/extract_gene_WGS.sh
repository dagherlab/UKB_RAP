#!/bin/bash




# this script access pvcf files of WGS produced by GATK pipeline.
# 1. get bed files for all genes
# 2. access the helper file ../helper_files/graphtyper_pvcf_coordinates.csv to see where the gene is 
# 3. use swiss army tools to subset vcf files.
# 4. download them

# Set your parameters
bed_file="your_bed_file.bed"    # Replace with your actual BED file name
index_file="index_file.csv"     # Replace with your actual index file name
out="your_output_directory"     # Replace with your actual output directory

# Create an empty list to hold the relevant batch files
relevant_batches=()

# Read the BED file line by line
while IFS=$'\t' read -r chr start end gene; do
  # Read the index file to locate relevant batch files
  while IFS=',' read -r file_name chromosome starting_position; do
    # Ensure chromosome matches and the range overlaps
    if [[ "$chr" == "chr$chromosome" && "$end" -ge "$starting_position" && "$start" -le "$(($starting_position + 19999))" ]]; then
      relevant_batches+=("$file_name")
    fi
  done < "$index_file"
done < "$bed_file"

# Remove duplicates from the list of relevant batch files
relevant_batches=($(echo "${relevant_batches[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

# Display the list of relevant batch files
echo "The following batch files will be processed:"
for file_name in "${relevant_batches[@]}"; do
  echo "$file_name"
done

# Ask for user confirmation
read -p "Do you want to submit the jobs? (yes/no): " user_input


# Check the user's response
if [[ "$user_input" != "yes" ]]; then
  echo "Job submission canceled."
  exit 1
fi



project-GYpQ7KQJb3qV67g26PBqjgf6:/Bulk/Whole genome sequences/Whole genome GraphTyper joint call pVCF/
# Generate dx run commands for each relevant batch file
for file_name in "${relevant_batches[@]}"; do
  dx run app-swiss-army-knife --instance-type mem1_ssd1_v2_x2 -y \
    --project "project-GYpQ7KQJb3qV67g26PBqjgf6" \
    -iin="/Bulk/Whole genome sequences/Whole genome GraphTyper joint call pVCF/${file_name}" \
    -iin="/Bulk/Whole genome sequences/Whole genome GraphTyper joint call pVCF//${file_name}.tbi" \
    -iin="project-GYpQ7KQJb3qV67g26PBqjgf6:temp/${bed_file}" \
    -icmd="bcftools view -Oz -o UKB_RAP_${file_name%.vcf.gz}_${bed_file}.vcf.gz -R ${bed_file} ${file_name}" \
    --destination ${out} --brief --priority low
done

# Optional: Merge and sort all generated VCF files
vcf_files=$(ls UKB_RAP_*_${bed_file}.vcf.gz | tr '\n' ' ')
bcftools concat -Oz -o merged_sorted.vcf.gz ${vcf_files}
bcftools index merged_sorted.vcf.gz