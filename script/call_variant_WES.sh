#!/bin/bash

batch=$1
bed_file1=$(basename $2)
sample_file=$(basename $3)
destination_folder=$4
project_src="project-GvFxJ08J95KXx97XFz8g2X2g"

script_file=preprocess_WES_data.sh
while read -r file; do
  # Extract base filename without path
  file_name=$(basename "$file")
  echo $file_name
  # Submit job
  dx run app-swiss-army-knife \
    --instance-type mem1_ssd1_v2_x8 \
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
done < $batch