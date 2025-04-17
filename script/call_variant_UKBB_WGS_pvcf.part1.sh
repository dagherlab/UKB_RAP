#!/bin/bash
# if you wanna provide a bed file. name it with the format ${pathname}.GRCh38.bed
#gene_list is simply a text file with gene name on each line
# gene_list txt file of gene names on each line
# output output folder for bed files
# pathname name of the task
# sleep_time not important, waiting time if you are running this in screen
# download_output # output folder for all vcf files.
# keep_samples, sample file with sample ID on each line 

read gene_list output pathname sleep_time download_output keep_samples <<< $@
echo "gene_list:$gene_list; output:$output; pathway:$pathname; sleep_time:$sleep_time; download_output: $download_output; keep_samples:$keep_samples"

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
export PATH="$HOME/.local/bin:$PATH"

echo "confirm the bed file is ok"
echo "continue?(y/n)"
read answer 
if [[ "$answer" == "y" ]];then 
    # identify batch files covering the genes based on the bed file
    if [ ! -f ${pathname}.batch.txt ];then
        echo "identifying batch files associated with the genes"
        bash identify_batch_files.sh $pathname.GRCh38.bed
    else 
        echo "batch file found"
    fi
    echo "confirm the batch file is ok"
    echo "continue?(y/n)"
    read answer
    if [[ "$answer" == "y" ]];then 
        dx mkdir -p genes/$pathname/
        out=genes/$pathname/
        if [ ! -n ${keep_samples} ];then 
            bash call_variant_WGS.sh $pathname.GRCh38.bed $out ${pathname}.batch.txt
        else
            bash call_variant_WGS.sh $pathname.GRCh38.bed $out ${pathname}.batch.txt $keep_samples
        fi 
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

# Sajanth's 14 genes
# bash call_variant_UKBB_WGS_pvcf.part1.sh Sajanth.genelist.txt . Sajanth14 3h ~/scratch/genotype/UKBB_RAP/sajanth



# konstantin's 8 genes
# bash call_variant_UKBB_WGS_pvcf.part1.sh konstantin8.txt . konstantin8 1h ~/scratch/genotype/UKBB_RAP/konstantin8
bash download_dx.sh ~/scratch/genotype/UKBB_RAP/konstantin8/ konstantin8/

## cem 152 genes
# bash call_variant_UKBB_WGS_pvcf.part1.sh cem_152.txt . cem152 3h ~/scratch/genotype/UKBB_RAP/cem152/ cem_152_samples.txt > cem152.log
# GBA1 took half hour to finish and 0.03 euro without subsetting by samples
# subsetting by samples add 20 more mins to the analysis

# to download files
# we can 

## bash download_dx.sh ~/scratch/genotype/UKBB_RAP/cem152/ cem152/


## Leah's X chr genes
### there 400k samples in her case. I'm not gonna subset because it is longer if I subset. especially 400k
# bash call_variant_UKBB_WGS_pvcf.part1.sh X_genes_to_extract.txt . leah3 3h ~/scratch/genotype/UKBB_RAP/leah3/ > leah3.log


## Ziv's CPT1C and EPHB2
# bash call_variant_UKBB_WGS_pvcf.part1.sh lang_ziv.txt . lang2 3h ~/scratch/genotype/UKBB_RAP/lang2/ > lang2.log


## cem's 46 genes
### its list comes with 48 genes but gla and g6pd are in leah's request. So I delete them
# bash call_variant_UKBB_WGS_pvcf.part1.sh cem46.txt . cem46 3h ~/scratch/genotype/UKBB_RAP/cem46/ cem_152_samples.txt > cem46.log



# morvarid's tnf
# bash call_variant_UKBB_WGS_pvcf.part1.sh morvarid.txt . morvarid 3h ~/scratch/genotype/UKBB_RAP/morvarid/ > morvarid.log
# bash download_dx.sh ~/scratch/genotype/UKBB_RAP/morvarid/ morvarid/