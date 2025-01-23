# documentation for using UKB RAP
## Implementing GBA1 Gauchian pipellne on UKB-RAP
this script is implemented in beluga.
make sure you've installed dxpy using pip
and login to your UKB-RAP account

# for dx
## it can be installed as described here https://documentation.dnanexus.com/downloads
# do this if your dx command doesnt work well
export PATH="$HOME/.local/bin:$PATH"

# WHAT DID THE SCRIPTS DO
1. create a docker image for Gauchian pipeline - build_docker.sh and Dockerfile.
2. find data on UKB-RAP and overlap sample IDs with samples of interest - GBA_pipeline.part1.sh
    - it basically takes a sample list file. and create commands for them. 100 samples are grouped together and they will be submitted together
3. subset IDs into prefix x batches (UKB-RAP manages the cram files by the first two digits in their ID. e.g. 10xxxxx is in the folder of 10). and it is cheaper to run multiple jobs for 100 samples. - GBA_pipeline.part1.sh & create_job_submission.py
4. create commands for these batches. there are 845 batches in total - create_job_submission.py
5. upload manifest files to UKB-RAP - GBA_pipeline.part1.sh
6. submit them (submission_command.txt)
this script can be improved. I dont know how to avoid using the swiss army knife when using the docker file. I didn't use their app at all. it was used to fill the command line


# download genes from WGS/WES pvcf data (under development)
update:

2025-01-21
- try ttyd in the future
    - it is a terminal

2025-01-08
- scripts for WGS data are optimized. there is a helper file (graphtyper_pvcf_cooridnates.csv) which has the coordinate for each batch file. 
1. the script (identify_batch_files) locate the batch file by the genes' position. then all batch files will be summarized into *.batch.txt with their directories on UKB RAP.
2. call_variant_WGS.sh uploads the bed file to UKB RAP and iterate each batch file in *.batch.txt to submit jobs.
3. download each file 

note:
1. there is a tradeoff when you wanna reduce the cost. subsetting the data by variants or samples makes it longer. and the final data is smaller. I dont know which costs more (download or using resource). keep the analysis simple and download the output. we won't use much resource.


2024-10-03
the current scripts need to optimized.
UKB-RAP stores genes into different batch files. the info for each batch file is stored somewhere. you can find the coordinates for each gene. my scripts simply iterate all batch files and take the genes (inefficient). this works on both WGS and WES data


