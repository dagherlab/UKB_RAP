#!/bin/bash
file=$1
keep_samples=$2
bed_file=$3

# module load StdEnv/2020 gcc/9.3.0 bcftools/1.16 # must be ignored if this is UKB RAP

name=$(basename $file .vcf.gz)

# workflow
## 1. subset vcf file by samples
## 2. label variants with DP<25/GQ<25 with missing genotype
## 3. split multiallelic variants - otherwise plink can't handle the multiallelic variants. you can remove them if you want
## 4. convert to plink file
## 5. do missingness filtering
## 6. convert back to vcf file

echo "subsetting samples"
bcftools view --threads 10 --samples-file ${keep_samples} -Oz -o ${name}.subset.vcf.gz -R ${bed_file} $file --force-samples 
tabix ${name}.subset.vcf.gz

# DP < 25/ GQ < 25 genotypes will be marked as missing in order
echo "label bad variants missing ./."
bcftools +setGT $file -Ou --threads 10 \
  -- -t q -n "." -i 'FMT/DP<25' \
| \
bcftools +setGT - -Ou --threads 10 \
  -- -t q -n "." -i 'FMT/GQ<25' \
|  \
bcftools view -Oz -o $name.DP25.GQ25.vcf.gz
## if you wanna see the changes
# bcftools query -f '%CHROM\t%POS[\t%GT:%DP:%GQ]\n' $name.DP25.GQ25.vcf.gz| head|cut -f1-10 -d":"

# split multiallelic variants
echo "splitting multiallelic variants"
bcftools norm --threads 5 -m -both -Oz -o $name.DP25.GQ25.split.vcf.gz $name.DP25.GQ25.vcf.gz

# convert to plink file and do 5% missingness filtering
## plink2 can handle multiallelic variants? 
echo "converting vcf to plink files"
if [[ "$name" == *"cX"* ]]; then
  # plink2 can't well handle chrX data without --split-par
  plink2 --vcf $name.DP25.GQ25.split.vcf.gz --split-par --make-bed --out $name.DP25.GQ25.split
else
  plink2 --vcf $name.DP25.GQ25.split.vcf.gz --vcf-half-call m --make-bed --out $name.DP25.GQ25.split
fi

plink2 --bfile $name.DP25.GQ25.split --geno 0.05 --make-bed --out $name.DP25.GQ25.MISS95.split
# reformat the ID column from chr:bp:SG/IG to chr:bp:A1:A2
awk 'BEGIN{OFS="\t"} {$2="chr"$1":"$4":"$5":"$6; print}' $name.DP25.GQ25.MISS95.split.bim > $name.DP25.GQ25.MISS95.split.renamed.bim
mv $name.DP25.GQ25.MISS95.split.renamed.bim $name.DP25.GQ25.MISS95.split.bim

# convert back to vcf file
plink2 --bfile $name.DP25.GQ25.MISS95.split --export vcf bgz id-paste=iid --out $name.DP25.GQ25.MISS95.split

tabix $name.DP25.GQ25.MISS95.split.vcf.gz