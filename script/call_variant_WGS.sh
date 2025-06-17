#!/bin/bash
# example: bash call_variant_WGS.sh COMMANDER23.batch.txt COMMANDER23.GRCh38.bed /lustre03/project/6004655/COMMUN/runs/lang/Commander/data/Filter_ID.txt genes/COMMANDER23_QC
batch=$1
bed_file_local=$2
sample_file_local=$3
destination_folder=$4
project_src="project-GvFxJ08J95KXx97XFz8g2X2g"
script_file=preprocess_WGS_data.sh
bed_file1=$(basename $bed_file_local)
sample_file=$(basename $sample_file_local)

if dx ls "temp/${bed_file1}" > /dev/null 2>&1; then
    echo "bed file found on UKB RAP"
else 
    echo "uploading the bed file"
    dx upload $bed_file_local --path temp/
fi
if dx ls "temp/${sample_file}" > /dev/null 2>&1; then
    echo "sample file found on UKB RAP"
else 
    dx upload $sample_file_local --path temp/
fi

read -p "Do you want to submit ONE job to test? (y/n): " choice

if [[ "$choice" == "y" ]]; then
  # Submit only the first job
  first_file=$(head -n 1 "$batch")
  file_name=$(basename "$first_file")

  dx run app-swiss-army-knife \
    --instance-type mem1_ssd1_v2_x4 \
    --priority high \
    -y \
    -iin="${first_file}" \
    -iin="${first_file}.tbi" \
    -iin="${project_src}:temp/${sample_file}" \
    -iin="${project_src}:temp/${bed_file1}" \
    -iin="${project_src}:scripts/${script_file}" \
    --destination="${destination_folder}" \
    --brief \
    -icmd="bash ${script_file} ${file_name} ${sample_file} ${bed_file1}"

  exit 0
fi

# User chose "no", check if first job's output already exists
first_file=$(head -n 1 "$batch")
file_name=$(basename "$first_file" .vcf.gz)
output_file="${file_name}.subset.DP25.GQ25.MISS95.split.vcf.gz"


if dx ls "${destination_folder}/${output_file}" > /dev/null 2>&1; then
  echo "Output for first job $output_file already exists. Skipping first line."
  tail -n +2 "$batch" | while read -r file; do
    file_name=$(basename "$file")
    dx run app-swiss-army-knife \
      --instance-type mem1_ssd1_v2_x4 \
      --priority high \
      -y \
      -iin="${file}" \
      -iin="${file}.tbi" \
      -iin="${project_src}:temp/${sample_file}" \
      -iin="${project_src}:temp/${bed_file1}" \
      -iin="${project_src}:scripts/${script_file}" \
      --destination="${destination_folder}" \
      --brief \
      -icmd="bash ${script_file} ${file_name} ${sample_file} ${bed_file1}"
  done
else
  echo "Output for first job not found. Submitting from first line."
  while read -r file; do
    file_name=$(basename "$file")
    dx run app-swiss-army-knife \
      --instance-type mem1_ssd1_v2_x4 \
      --priority high \
      -y \
      -iin="${file}" \
      -iin="${file}.tbi" \
      -iin="${project_src}:temp/${sample_file}" \
      -iin="${project_src}:temp/${bed_file1}" \
      -iin="${project_src}:scripts/${script_file}" \
      --destination="${destination_folder}" \
      --brief \
      -icmd="bash ${script_file} ${file_name} ${sample_file} ${bed_file1}"
  done < "$batch"
fi
