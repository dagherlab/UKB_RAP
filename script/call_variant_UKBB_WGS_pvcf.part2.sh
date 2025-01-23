#!/bin/bash


# index the file
# concatenate them
module load StdEnv/2020 gcc/9.3.0 bcftools/1.16
mkdir -p log/
for file in *vcf.gz;do
    command="tabix $file"
    if [ ! -f $file.tbi ];then
        sbatch -c 5 --mem=30g -t 3:0:0 --out log/$file.tabix.out --account=def-grouleau --wrap "$command"
    else 
        echo "index file found, skipped"
    fi
done


