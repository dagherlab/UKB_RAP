# concatenate selected files belonging to the same chromosome together 
## gzip them and tabix them
salloc -c 20 --mem=40g -t 6:0:0 --account=def-adagher
module load StdEnv/2020 gcc/9.3.0 bcftools/1.16
for chr in {1..22} X Y;do
    rm chr${chr}.merge.list
    for file in *chr${chr}_b*.vcf.gz;do
        echo "working on $file"
        ## identify batch files with variants
        variant_number=$(bcftools query -f '%ID\n' ${file}| wc -l)
        if [ "$variant_number" -gt 0 ]; then
            tabix ${file}
            ### only concatenate files that have variants
            echo $file >> chr${chr}.merge.list
        fi
    done 
done


## (sorting consumes crazy memory)
for chr in $(seq 1 22) X;do
echo "submitting a job to merge WES UKB chr${chr}"
## do this by sbatch
out_name=UKB_WES_chr${chr}_cem.vcf.gz
out_name_sort="$(basename ${out_name} .vcf.gz).sort.vcf.gz"
command="module load StdEnv/2020 gcc/9.3.0 bcftools/1.16 && bcftools concat -f chr${chr}.merge.list -Oz -o ${out_name} && bcftools sort -Oz ${out_name} -o ${out_name_sort} && tabix ${out_name_sort}"
# the memory need to be changed for small data
# for data with around 10 gb. 600g ram is required (could be optimized)
sbatch -c 40 --mem=600g -t 6:0:0 --wrap "$command" --account=def-grouleau --out UKB_WES_chr${chr}_MERGE.out
echo "##############"
echo "##############"
echo "#############"
done