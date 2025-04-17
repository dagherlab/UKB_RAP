# Define the base directory for source files
base_dir="/mnt/project/Bulk/DRAGEN WGS/DRAGEN population level WGS variants, pVCF format [500k release]"
chr=chrX

for file in "$base_dir/$chr/"*; do
    # Extract the filename from the path
    filename=$(basename "$file")

    # Check if the file already exists in the dx folder "chrXY"
    if dx ls chrXY/"$filename" > /dev/null 2>&1; then
        echo "File $filename already exists, skipping."
        continue
    fi


    # Upload the file to the dx folder "chrXY"
    dx upload "$file" --destination chrXY/
done

base_dir="/mnt/project/Bulk/DRAGEN WGS/DRAGEN population level WGS variants, pVCF format [500k release]"
chr=chrY
for file in "$base_dir/$chr/"*; do
    # Extract the filename from the path
    filename=$(basename "$file")

    # Check if the file already exists in the dx folder "chrXY"
    if dx ls chrY/"$filename" > /dev/null 2>&1; then
        echo "File $filename already exists, skipping."
        continue
    fi


    # Upload the file to the dx folder "chrXY"
    dx upload "$file" --destination chrY/
done