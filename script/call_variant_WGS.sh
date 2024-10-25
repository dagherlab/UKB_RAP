#!/bin/bash
# this script submit jobs batches by batches
# make sure the project is correct before you run it.
# the paths are in batch_file

bed_file=$1
out=$2
batch_file=$3

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

# Iterate over each batch file and submit jobs
cat $batch_file|while read -r file;do 
    file1=$(basename "$file")
    file2=$(basename "$file" .vcf.gz)
    # echo "$file1 $file2"
    if dx ls "$file" > /dev/null 2>&1; then
        # continue because file exits
        if dx ls "${out}/${file2}.subset.vcf.gz" > /dev/null 2>&1; then
            # skip the job if it doesn't exit (save some money)
            echo "${out}/${file2}.subset.vcf.gz found, then skipped"
        else 
            dx run app-swiss-army-knife --instance-type mem1_ssd1_v2_x8 -y -iin="$file" -iin="${file}.tbi" -iin="project-GvFxJ08J95KXx97XFz8g2X2g:temp/${bed_file1}" -icmd="bcftools view -Oz -o ${file2}.subset.vcf.gz -R ${bed_file1} $file1" --destination ${out} --brief --priority low
        fi
    else
        echo "file $file doesn't exit"
    fi
done
# you can download the files by "dx download [file]""

#use "dx find" jobs to view all running jobs 
#use "dx describe job-xxxx" to view the specified job
#"dx terminate job-xxxx"can terminate jobs
#"dx wait job-xxx" can allow us to run after the job is finished
