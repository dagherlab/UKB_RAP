#!/bin/bash
#gene_list is simply a text file with gene name on each line
gene_list=$1
output=$2
pathname=$3
sleep_time=$4
download_output=$5
module load StdEnv/2020 scipy-stack/2020a python/3.8.10
# be careful with the reference file in map_genes.py.
python map_genes_GRCh38.py -i $gene_list -o $output -p $pathname
# before you run this command
## make sure your dx is setup
dx mkdir $pathname/
out=/$pathname/
bash call_variant_dx.sh $pathname.GRCh38.bed $out
sleep $4
mkdir -p $download_output
dx download $out/* -o $download_output
# then concatenate files by batches and chromosomes.
# and index them. details can be found in call_variants_UKBB_WES_pvcf.part2.sh

# when there are one or two genes. we can simply just index it like below
#command="module load StdEnv/2020 gcc/9.3.0 bcftools/1.16 && tabix UKB_WES_CLN5.vcf.gz"
#sbatch -c 10 --mem=30g -t 3:0:0 --wrap "$command" --account=def-adagher --out UKB_WES_CLN5_tabix.out