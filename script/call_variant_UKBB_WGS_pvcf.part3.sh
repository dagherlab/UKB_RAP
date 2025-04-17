#!/bin/bash

# Iterate over chromosomes 1 to 22 and X
module load StdEnv/2020 gcc/9.3.0 bcftools/1.16
# mkdir -p ../cem_merge/
# Iterate over chromosomes 1 to 22 and X
for chr in $(seq 1 22) X; do
    out_name=ukb23374_c${chr}.vcf.gz
    if [ ! -f ${out_name} ];then
    # Check if there are files for the chromosome
    if ls ukb23374_c${chr}_b*.vcf.gz 1> /dev/null 2>&1; then
        # Create the merge list
        ls ukb23374_c${chr}_b*.vcf.gz | sort -t'_' -k3.2n > chr${chr}.merge.list
        echo "Here are the sorted batch files for chromosome ${chr}:"
        #cat chr${chr}.merge.list
        echo "Please confirm the sorting is correct (yes or no):"
        answer=yes
        #read answer

        if [[ "$answer" == "yes" ]]; then 
            # Define output file name
            

            # Count the number of files
            file_count=$(wc -l < chr${chr}.merge.list)

            # If only one file, rename and index
            if [ $file_count -eq 1 ]; then
                single_file=$(head -n 1 chr${chr}.merge.list)
                echo "Only one file found for chromosome ${chr}. Renaming ${single_file} to ${out_name}."
                mv $single_file $out_name
                tabix $out_name
                continue
            fi

            # Time requested: 10 minutes per file + 1 hour base
            time_minutes=$((file_count * 2 + 60))
            time_hours=$((time_minutes / 60))
            time_remaining_minutes=$((time_minutes % 60))
            time_requested=$(printf "%02d:%02d:00" $time_hours $time_remaining_minutes)

            # Fixed memory allocation
            mem_requested=30

            # Create the command with multi-threading
            command="bcftools concat --naive -f chr${chr}.merge.list --threads 10 -Oz -o ${out_name} && echo 'concatenation done' && tabix ${out_name}"

            # Submit the job
            sbatch -c 10 --mem=${mem_requested}g -t ${time_requested} \
                --wrap "$command" \
                --account=def-grouleau \
                --output=UKB_WGS_chr${chr}_MERGE.out \
                --job-name=chr${chr}.WGS.bcftools

            echo "Submitted job for chromosome ${chr} with ${file_count} files, memory: ${mem_requested}G, time: ${time_requested}"
        else
            echo "Redo the sorting for merge list and resubmit the job."
        fi
    else
        echo "No files found for chromosome ${chr}, skipping."
    fi
    fi
done