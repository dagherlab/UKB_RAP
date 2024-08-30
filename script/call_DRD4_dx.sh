#!/bin/bash
# use ukb biobank to retrieve the sequence

# this script submit jobs cram by cram
## so the resulting files from certain batches may not have any data. it is ok
bed_file=$1
out=$2
target_chromosomes=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "X" "Y" )
dx rm temp/$bed_file
dx upload $bed_file --path temp/
# Iterate over each chromosome in the target list
## dx upload $output_file --path temp/
ref="project-GYpQ7KQJb3qV67g26PBqjgf6:/Bulk/Whole genome sequences/Exome OQFE CRAM files/helper_files/GRCh38_full_analysis_set_plus_decoy_hla.fa
for i in $(seq 0 $batch_number);do
    # you may wanna configure this command for a smaller instance
    dx run app-swiss-army-knife --instance-type mem1_ssd1_v2_x8 -y -iin="project-GYpQ7KQJb3qV67g26PBqjgf6:/Bulk/Exome sequences/Population level exome OQFE variants, pVCF format - final release/ukb23157_c${target_chromosome}_b${i}_v1.vcf.gz" -iin="project-GYpQ7KQJb3qV67g26PBqjgf6:/Bulk/Exome sequences/Population level exome OQFE variants, pVCF format - final release/ukb23157_c${target_chromosome}_b${i}_v1.vcf.gz.tbi" -iin="project-GYpQ7KQJb3qV67g26PBqjgf6:temp/${bed_file}" -icmd="bcftools view -Oz -o UKB_RAP_chr${target_chromosome}_b${i}_${bed_file}.vcf.gz -R ${bed_file} ukb23157_c${target_chromosome}_b${i}_v1.vcf.gz" --destination ${out} --brief
done 
# you can download the files by "dx download [file]""

#use "dx find" jobs to view all running jobs 
#use "dx describe job-xxxx" to view the specified job
#"dx terminate job-xxxx"can terminate jobs
#"dx wait job-xxx" can allow us to run after the job is finished


# demo
ref="project-GYpQ7KQJb3qV67g26PBqjgf6:/Bulk/Exome sequences/Exome OQFE CRAM files/helper_files/GRCh38_full_analysis_set_plus_decoy_hla.fa"
cram="project-GYpQ7KQJb3qV67g26PBqjgf6:/Bulk/Whole genome sequences/Whole genome CRAM files/10/1000601_23193_0_0.cram"
crai="project-GYpQ7KQJb3qV67g26PBqjgf6:/Bulk/Whole genome sequences/Whole genome CRAM files/10/1000601_23193_0_0.cram.crai"
out=/DRD4/
command="samtools view -b -T GRCh38_full_analysis_set_plus_decoy_hla.fa 1000601_23193_0_0.cram 'chr11:637269-640706' > DRD4.bam"
dx run app-swiss-army-knife --instance-type mem1_ssd1_v2_x8 -y -iin="$ref" -iin="$cram" -iin="$crai" -icmd="$command" --destination ${out} --brief
# get TR
module load StdEnv/2023 samtools/1.18
bam=/home/liulang/liulang/UKB_RAP/mayuri/DRD4.bam
ref=/lustre03/project/6004655/COMMUN/runs/senkkon/UKBB_DP/GRCh38_full_analysis_set_plus_decoy_hla.fa

name=$(basename $bam .bam)
samtools sort ${name}.bam -o ${name}_sorted.bam
samtools index ${name}_sorted.bam
module load StdEnv/2023 apptainer/1.2.4
# WGS file has a smaller bam on DRD4 than the file from WES?
# and is the method correct to retrieve the TR?
apptainer shell -B /lustre04/,/lustre03/,/home/liulang /home/liulang/liulang2/mayuri/repeat_number/GangSTR/str-toolkit_latest.sif
GangSTR --bam ${name}_sorted.bam --ref $ref --regions DRD4.bed --out DRD4