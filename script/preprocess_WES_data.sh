# subset_vcf.sh

#!/bin/bash

# this is on dnanexus scripts/
set -euo pipefail

# Define variables
file1="$1"
keep_samples="$2"
bed_file1="$3"
output=$(basename "$file1" .vcf.gz)

tmp_vcf="$output.split.vcf.gz"

echo "splitting multiallelic files"
bcftools norm --threads 10 -m - -Oz -o "$tmp_vcf" "$file1"
tabix $tmp_vcf
echo "Running bcftools view..."
bcftools view --threads 10 --samples-file "$keep_samples" -Oz -o "${output}.subset.vcf.gz" -R "$bed_file1" "$tmp_vcf" --force-samples


echo "making PLINK files"
# add --vcf-half-call m to avoid half call.

plink --vcf "${output}.subset.vcf.gz" --vcf-half-call m --make-bed --out ${output}.subset 

rm $tmp_vcf
rm $tmp_vcf.tbi
rm ${output}.subset.vcf.gz


# how to test this script 
# open ttyd (https://ukbiobank.dnanexus.com/panx/tool/app/ttyd)
# /mnt/project/scripts/preprocess_WES_data.sh
# cut -f1 ~/lang/data/UKBB_RAP/pheno_UKBB_paper.tab|tail -n +2 > ~/scratch/UKB_PD.ID.txt
# dx upload ~/scratch/UKB_PD.ID.txt --path /temp/
# # it is a virtual env, Idk why they are not mounted in the env. but you have to install the app first
# apt install bcftools
# apt install putty-tools
# # we can't use projectID to specify file path in ttyd
# file="/mnt/project//Bulk/Exome sequences/Population level exome OQFE variants, pVCF format - final release//ukb23157_c10_b34_v1.vcf.gz"
# samples=/mnt/project/temp/UKB_PD.ID.txt 
# bed=/mnt/project/temp/COMMANDER23.GRCh38.bed 
# SCRIPTS=/mnt/project/scripts/preprocess_WES_data.sh 
# bash $SCRIPTS "$file" $samples $bed