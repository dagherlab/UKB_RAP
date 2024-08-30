#!/bin/bash
# this script submit jobs batches by batches in each chromosome
## so the resulting files from certain batches may not have any data. it is ok
bed_file=$1
out=$2
target_chromosomes=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "X" "Y" )
dx rm temp/$bed_file
dx upload $bed_file --path temp/
# Iterate over each chromosome in the target list
## identify the number of genes in the bed file.  dont submit jobs if there are no genes
for target_chromosome in "${target_chromosomes[@]}"; do
    chromosome="chr${target_chromosome}"
    # Temporary file to store the output for the current chromosome
    output_file="temp_gene_locations_${target_chromosome}.txt"
    echo "working on chromosome $chromosome"
    # Check if the output file already exists and remove it
    if [ -f "$output_file" ]; then
        rm "$output_file"
    fi
    ## note(I was too lazy to simplify the following script. actually they are not neccessary)
    # Read each line of the bed file
    while read -r line || [[ -n "$line" ]]; do
        # Extract the chromosome, start, and end positions
        chrom=$(echo "$line" | awk '{print $1}')
        start=$(echo "$line" | awk '{print $2}')
        end=$(echo "$line" | awk '{print $3}')

        # Check if the current line's chromosome matches the target chromosome
        if [ "$chrom" == "$chromosome" ]; then
            # Append the formatted string to the output file
            echo "$chrom:$start-$end" >> "$output_file"
        fi
    done < "$bed_file"

    # If the output file was created (meaning there were matches), display its contents
    line_count=$(wc -l < "$output_file")
    rm $output_file
    # Check if the line count is greater than 0
    if [ "$line_count" -gt 0 ]; then
        # count the batch and call the variant batch by batch on each chromosome
        batch_number=$(dx ls "project-GYpQ7KQJb3qV67g26PBqjgf6:/Bulk/Whole genome sequences/Population level WGS variants, pVCF format - interim 200k release/ukb24304_c${target_chromosome}_b*_v1.vcf.gz"|wc -l)
        # iterate each batch
        ## dx upload $output_file --path temp/
        for i in $(seq 0 $batch_number);do
            # you may wanna configure this command for a smaller instance
            dx run app-swiss-army-knife --instance-type mem1_ssd1_v2_x8 -y -iin="project-GYpQ7KQJb3qV67g26PBqjgf6:/Bulk/Whole genome sequences/Population level WGS variants, pVCF format - interim 200k release/ukb24304_c${target_chromosome}_b*_v1.vcf.gz" -iin="project-GYpQ7KQJb3qV67g26PBqjgf6:/Bulk/Whole genome sequences/Population level WGS variants, pVCF format - interim 200k release/ukb24304_c${target_chromosome}_b*_v1.vcf.gz.tbi" -iin="project-GYpQ7KQJb3qV67g26PBqjgf6:temp/${bed_file}" -icmd="bcftools view -Oz -o UKB_RAP_chr${target_chromosome}_b${i}_${bed_file}.vcf.gz -R ${bed_file} ukb24304_c${target_chromosome}_b${i}_v1.vcf.gz" --destination ${out} --brief
        done 
       
    fi
done
# you can download the files by "dx download [file]""

#use "dx find" jobs to view all running jobs 
#use "dx describe job-xxxx" to view the specified job
#"dx terminate job-xxxx"can terminate jobs
#"dx wait job-xxx" can allow us to run after the job is finished
