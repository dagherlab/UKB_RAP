folders=$(dx ls --folders --brief "project-GvFxJ08J95KXx97XFz8g2X2g:/Bulk/Brain MRI/Connectomes/")


#!/bin/bash
# field_number=31022

for field_number in 31022 31023 31026 31024 31025 31020 31021 31027 31028;do 
# connectome_number="60"
dst_folder="connectome/${field_number}"
dx mkdir $dst_folder

for connectome_number in $folders;do 

# Set parameters
project_src="project-GvFxJ08J95KXx97XFz8g2X2g"
src_folder="/Bulk/Brain MRI/Connectomes/${connectome_number}"
# List all files in the source folder
echo "the number of files under field $field_number"
echo $(dx ls "${project_src}:${src_folder}/*${field_number}*"|wc -l)
file_list=$(dx ls "${project_src}:${src_folder}/*${field_number}*")
# Initialize input flags
input_flags=""
copy_cmd=""

# Build input and copy commands
for file in $file_list; do
  input_flags+=" -iin='${project_src}:${src_folder}/${file}'"
  name=$(basename ${file} .zip)
  copy_cmd+="cp ${file} ${name}_project45551.zip; "
done

# Submit the job
eval dx run app-swiss-army-knife \
  ${input_flags} \
  --destination="${dst_folder}" \
  --instance-type mem1_ssd1_v2_x4 \
  --brief \
  --yes \
  -icmd="'${copy_cmd}'"
done
done



# zip all folders
for field_number in 31022 31023 31026 31024 31025 31020 31021 31027 31028;do 
# connectome_number="60"
dst_folder="connectome/${field_number}"
project_src="project-GvFxJ08J95KXx97XFz8g2X2g"
cmd=tar -czf "${ARCHIVE_OUTPUT_DIR}/${archive_name}" -C "$BASE_DIR" "$folder_name"
eval dx run app-swiss-army-knife \
  ${input_flags} \
  --destination="${dst_folder}" \
  --instance-type mem1_ssd1_v2_x4 \
  --brief \
  --yes \
  -icmd="'${copy_cmd}'"