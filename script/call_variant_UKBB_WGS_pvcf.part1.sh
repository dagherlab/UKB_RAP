#!/bin/bash
#gene_list is simply a text file with gene name on each line
gene_list=$1
output=$2 # output folder for bed file
pathname=$3
sleep_time=$4
download_output=$5 # output folder for all vcf files.
module load StdEnv/2020 scipy-stack/2020a python/3.8.10
# be careful with the reference file in map_genes.py.
if [ ! -f ${pathname}.GRCh38.bed ];then
    srun -c 2 --mem=10g -t 1:0:0 --account=def-grouleau python map_genes_GRCh38.py -i $gene_list -o $output -p $pathname
else
    echo "bed file found"
fi 
# before you run this command
## make sure your dx is setup
## check this to select project https://documentation.dnanexus.com/user/projects/project-navigation
# dx select project-GvFxJ08J95KXx97XFz8g2X2g
## and make sure the bed file contains all the genes you want
echo "confirm the bed file is ok"
echo "continue?(y/n)"
read answer 
if [[ "$answer" == "y" ]];then 
    # identify batch files covering the genes based on the bed file
    if [ ! -f ${pathname}.batch.txt ];then
        bash identify_batch_files.sh $pathname.GRCh38.bed
    else 
    echo "batch file found"
    fi
    echo "confirm the batch file is ok"
    echo "continue?(y/n)"
    read answer
    if [[ "$answer" == "y" ]];then 
        dx mkdir -p $pathname/
        out=/$pathname/
        bash call_variant_WGS.sh $pathname.GRCh38.bed $out ${pathname}.batch.txt
        exit
        sleep $4
        mkdir -p $download_output
        echo "looks like it is completed, do you wanna download them (y/n)"
        read answer
        if [[ "$answer" == "y" ]];then 
            dx download $out/* -o $download_output
        else
            echo "quit downloading. you need to manually download them by running dx download $out/* -o $download_output"
        fi
    else 
        echo "batch file not good, check your bed files and re-run identify_batch_files.sh"
        exit 42
    fi 
    # then concatenate files by batches and chromosomes.
    # and index them. details can be found in call_variants_UKBB_WES_pvcf.part2.sh

    # when there are one or two genes. we can simply just index it like below
    #command="module load StdEnv/2020 gcc/9.3.0 bcftools/1.16 && tabix UKB_WES_CLN5.vcf.gz"
    #sbatch -c 10 --mem=30g -t 3:0:0 --wrap "$command" --account=def-adagher --out UKB_WES_CLN5_tabix.out
else
    echo "bed file not good, check your gene names and re-run this"
    rm $pathname.GRCh38.bed
    exit 42
fi 


# what have been done
## cem 152 genes
# bash call_variant_UKBB_WGS_pvcf.part1.sh cem_152.txt . cem152 3h ~/scratch/genotype/UKBB_RAP/cem152/ > cem152.log
# GBA1 took half hour to finish and 0.03 euro