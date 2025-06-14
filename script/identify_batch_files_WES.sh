#!/bin/bash

bed_file=$1


pathname=$(basename $bed_file .GRCh38.bed)
# use the helper file to identify the batch file
if [ ! -f ../helper_files/pvcf_blocks_transformed.csv ];then echo "the file pvcf_blocks_transformed.csv not present.";exit; fi 

temp_file=${pathname}.batch.txt.temp
rm $temp_file
rm ${pathname}.batch.WES.txt
chrs=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "X" "Y")

for chr in "${chrs[@]}"; do 
    dx_path="project-GvFxJ08J95KXx97XFz8g2X2g:/Bulk/Exome sequences/Population level exome OQFE variants, pVCF format - final release/"
    chr_name="chr$chr"
    
    # Select genes in bed files for this chr
    grep -w "$chr_name" "$bed_file" | cut -f2,3,4 | while read -r start end gene; do 
        echo "$chr $start $end $gene"
        
        # Subset the helper file
        ## start and end position for each WES is provided.
        batch_files=$(awk -F"," -v chr="$chr" -v start="$start" -v end="$end" \
        '$2 == chr && $4 >= start && $3 <= end { print $1 }' ../helper_files/pvcf_blocks_transformed.csv)
        echo $batch_files
        if [ -n "$batch_files" ]; then 
            # Loop over the batch_files correctly by splitting into lines
            while read -r file; do
                echo "$dx_path/$file" >> "$temp_file"
            done <<< "$batch_files"
        else 
            echo "There is no batch file captured. You need to check it!"
            exit 42
        fi

    done
done


# make sure there is no duplicated files
sort "$temp_file" | uniq > ${pathname}.batch.WES.txt

rm $temp_file

