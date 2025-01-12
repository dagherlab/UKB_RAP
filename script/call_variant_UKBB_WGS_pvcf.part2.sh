#!/bin/bash


# index the file
# concatenate them
module load StdEnv/2020 gcc/9.3.0 bcftools/1.16
mkdir -p log/
for file in *vcf.gz;do
command="tabix $file"
sbatch -c 5 --mem=30g -t 3:0:0 --out log/$file.tabix.out --account=def-grouleau --wrap "$command"
done

# dynamically request resource based on file size and number of file in the merge list
## 
module load StdEnv/2020 gcc/9.3.0 bcftools/1.16 
# Iterate over chromosomes 1 to 22 and X
for chr in $(seq 1 22) X; do
    if ls ukb23374_c${chr}_b*.vcf.gz 1> /dev/null 2>&1; then
        # Create the merge list
        ls ukb23374_c${chr}_b*.vcf.gz | sort -t'b' -k2,2n > chr${chr}.merge.list

        # Count the number of files in the merge list
        file_count=$(wc -l < chr${chr}.merge.list)

        # Calculate the total size of the files in MB
        total_size_mb=$(awk '{cmd="du -m " $1; cmd | getline size; close(cmd); sum+=size} END {print sum}' chr${chr}.merge.list)

        # Convert size to GB and add a 20 GB buffer
        total_size_gb=$(( (total_size_mb + 1023) / 1024 ))  # Round up to nearest GB
        mem_requested=$((total_size_gb + 20))  # Add 20 GB buffer

        # Calculate the time required (40 minutes per file)
        time_minutes=$((file_count * 40))
        time_hours=$((time_minutes / 60))
        time_remaining_minutes=$((time_minutes % 60))

        # Format time as HH:MM:00 for sbatch
        time_requested=$(printf "%02d:%02d:00" $time_hours $time_remaining_minutes)

        # Define output file name
        out_name=ukb23374_c${chr}.vcf.gz
        rm $out_name
        # Create the command
        command="bcftools concat -f chr${chr}.merge.list -Oz -o ${out_name} && tabix ${out_name}"

        # Submit the job with dynamic time and memory
        sbatch -c 10 --mem=${mem_requested}g -t ${time_requested} --wrap "$command" --account=def-grouleau --output=UKB_WGS_chr${chr}_MERGE.out

        echo "Submitted job for chromosome ${chr} with ${file_count} files, memory requested: ${mem_requested}G, time requested: ${time_requested}"
    else
        echo "No files found for chromosome ${chr}, skipping."
    fi
done



