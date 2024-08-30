# documentation for using UKB RAP
## Implementing GBA1 Gauchian pipellne on UKB-RAP

# WHAT DID THE SCRIPTS DO
# 1. create a docker image for Gauchian pipeline
# 2. find data on UKB-RAP and overlap sample IDs with samples of interest
# 3. subset IDs into prefix x batches (UKB-RAP manages the cram files by the first two digits in their ID. e.g. 10xxxxx is in the folder of 10). and it is cheaper to run multiple jobs for 100 samples. 
# 4. create commands for these batches. there are 244 batches in total
# 5. submit them
# this script can be improved. I dont know how to avoid using the swiss army knife when using the docker file. I didn't use their app at all. it was used to fill the command line


## download genes from WGS/WES pvcf data (under development)
## the current scripts need to optimized.
## UKB-RAP stores genes into different batch files. the info for each batch file is stored somewhere. you can find the coordinates for each gene. my scripts simply iterate all batch files and take the genes (inefficient). this works on both WGS and WES data


