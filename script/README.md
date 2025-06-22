# How to use
liulang@beluga4:~/lang/UKB_RAP/script$ bash call_variant_UKBB_WGS_pvcf.part1.sh DAGLB.txt . DAGLB ~/scratch/genotype/UKBB_RAP/DAGLB_QC /lustre03/project/6004655/COMMUN/runs/lang/Commander/data/Filter_ID.txt
gene_list:DAGLB.txt; output:.; pathway:DAGLB; download_output: /home/liulang/scratch/genotype/UKBB_RAP/DAGLB_QC; keep_samples:/lustre03/project/6004655/COMMUN/runs/lang/Commander/data/Filter_ID.txt
bed file found # a bed file will be created by gencode if it doesnt exist
confirm the bed file is ok
continue?(y/n)
y
batch file found # a batch file will be created by the coordinate file if it doesnt exist
confirm the batch file is ok
continue?(y/n)
y
bed file:DAGLB.GRCh38.bed genes/DAGLB/ batch file:DAGLB.batch.txt, keep_samples:/lustre03/project/6004655/COMMUN/runs/lang/Commander/data/Filter_ID.txt
bed file found on UKB RAP # it will be uploaded if it doesnt exist in temp/ on the platform
sample file found on UKB RAP # same as above
Do you want to submit ONE job to test? (y/n): y # you must let it submit one job to test if the instance is ok. because it may fail due to insufficient memory
job-J192qz8J95KXvFZYp0qZJjb0 # job ID on the platform. you can kill it by dx terminate <job-id>
if you chose yes and submitted one job to test. please enter y to rerun the program after you confirm the result (y/n) # enter yes to submit remaining jobs