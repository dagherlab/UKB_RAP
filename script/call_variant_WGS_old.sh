#!/bin/bash
# this script submit jobs batches by batches
# make sure the project is correct before you run it.
# the paths are in batch_file
# please subset data by samples. keep_sample is a txt file with family IDs on each line
read bed_file out batch_file keep_samples <<< $@




pathname=$(basename $bed_file .GRCh38.bed)
bed_file1=$(basename $bed_file)
dx mkdir -p temp

if dx ls "temp/$bed_file1" > /dev/null 2>&1; then
    echo "bed file $bed_file1 found, would u like to delete it? (y/n)"
    read answer
    if [[ "$answer" == "y" ]];then 
        dx rm temp/$bed_file1
        dx upload $bed_file --path temp/
    fi
else
    dx upload $bed_file --path temp/
fi 
if [ -n "$keep_samples" ];then sample_file=$(basename $keep_samples); fi
if ! dx ls "temp/$keep_samples" > /dev/null 2>&1; then
    echo "uploading sample file"
    dx upload $keep_samples --path temp/
fi 
# Iterate over each batch file and submit jobs
exec 3</dev/tty   # Open file descriptor 3 for keyboard input
answer_temp=N
while read -r file;do 
    file1=$(basename "$file")
    file2=$(basename "$file" .vcf.gz)
    # echo "$file1 $file2"
    if dx ls "$file" > /dev/null 2>&1; then
        # continue because file exits
        if dx ls "${out}/${file2}.subset.vcf.gz" > /dev/null 2>&1; then
            # skip the job if it doesn't exit (save some money)
            echo "${out}/${file2}.subset.vcf.gz found, then skipped"
        else 
            # subset data by sample IDs
            if [ -n "$keep_samples" ]; then
                echo "data will be subset by sample file $keep_samples"
                
                dx run app-swiss-army-knife --instance-type mem1_ssd1_v2_x8 -y -iin="$file" -iin="project-GvFxJ08J95KXx97XFz8g2X2g:temp/${sample_file}" -iin="${file}.tbi" -iin="project-GvFxJ08J95KXx97XFz8g2X2g:temp/${bed_file1}" -icmd="bcftools view --samples-file ${keep_samples} -Oz -o ${file2}.subset.vcf.gz -R ${bed_file1} $file1 --force-samples && tabix ${file2}.subset.vcf.gz" --destination ${out} --brief --priority high
            else 
                dx run app-swiss-army-knife --instance-type mem1_ssd1_v2_x8 -y -iin="$file" -iin="${file}.tbi" -iin="project-GvFxJ08J95KXx97XFz8g2X2g:temp/${bed_file1}" -icmd="bcftools view -Oz -o ${file2}.subset.vcf.gz -R ${bed_file1} $file1 && tabix ${file2}.subset.vcf.gz" --destination ${out} --brief --priority high
            fi 
            if [[ "$answer_temp" == "N" ]];then 
                echo "please wait for the completion of your first job on UKB-RAP and see if it works. if yes. please answer Y"
                echo "continue?(Y/n)"
                read -u 3 answer2
                if [[ "$answer2" != "Y" ]];then 
                    exit 42
                else
                    answer_temp=Y
                fi 
            fi
        fi
    else
        echo "file $file doesn't exit"
    fi
done < "$batch_file"
# you can download the files by "dx download [file]""

#use "dx find" jobs to view all running jobs 
#use "dx describe job-xxxx" to view the specified job
#"dx terminate job-xxxx"can terminate jobs
#"dx wait job-xxx" can allow us to run after the job is finished
