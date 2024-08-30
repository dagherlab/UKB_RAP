# WHAT I did here
# get IDs we are gonna analyze
# generate commands for these batches
# # set up 
# cut -d"," -f2 ../GBA_Gauchian/UKB_IDs_with_t1.csv|tail -n +2 >  
# ## select a group of test IDs
# grep "^10" ../GBA_Gauchian/UKB_ID.txt |head -n 10 > test_ID10.txt
export PATH=$PATH:/home/liulang/.local/bin
module load StdEnv/2020 python/3.8.10
rm submission_command.txt
# # Loop through unique two-digit prefixes
input_file=../GBA_Gauchian/UKB_ID.txt
awk '{print substr($0, 1, 2)}' "$input_file" | sort -u | while read prefix; do
    # Create files named IDXX.txt based on the prefix
    # if [ ! -f ../GBA_Gauchian/tmp_${prefix}.txt ];then
    #     grep "^$prefix" "$input_file" > "../GBA_Gauchian/UKB_ID${prefix}.txt"
    #     dx find data --path "/Bulk/Whole genome sequences/Whole genome CRAM files/${prefix}/" --name "*.cram" --delim > ../GBA_Gauchian/UKBRAP_${prefix}.txt
    #     grep -f ../GBA_Gauchian/UKB_ID${prefix}.txt ../GBA_Gauchian/UKBRAP_${prefix}.txt | cut -f4 | sed 's|.*/||' > ../GBA_Gauchian/manifest_${prefix}.txt
    #     grep -f ../GBA_Gauchian/UKB_ID${prefix}.txt ../GBA_Gauchian/UKBRAP_${prefix}.txt > ../GBA_Gauchian/tmp_${prefix}.txt
    #     echo "There are $(wc -l < ../GBA_Gauchian/UKB_ID${prefix}.txt) samples we want to analyze."
    #     echo "finally there are $(wc -l < ../GBA_Gauchian/manifest_${prefix}.txt) samples found in RAP"
    # fi 
    python create_job_submission.py ../GBA_Gauchian/tmp_${prefix}.txt 100 ${prefix} >> submission_command.txt
done
## uncomment this upload manifest files
# dx upload ../GBA_Gauchian/manifest_* --path IDs/

# There are 1001 samples we want to analyze.
# finally there are 439 samples found in RAP
# There are 925 samples we want to analyze.
# finally there are 406 samples found in RAP
# There are 918 samples we want to analyze.
# finally there are 412 samples found in RAP
# There are 937 samples we want to analyze.
# finally there are 468 samples found in RAP
# There are 863 samples we want to analyze.
# finally there are 387 samples found in RAP
# There are 942 samples we want to analyze.
# finally there are 431 samples found in RAP
# There are 916 samples we want to analyze.
# finally there are 428 samples found in RAP
# There are 907 samples we want to analyze.
# finally there are 392 samples found in RAP
# There are 875 samples we want to analyze.
# finally there are 399 samples found in RAP
# There are 895 samples we want to analyze.
# finally there are 416 samples found in RAP
# There are 937 samples we want to analyze.
# finally there are 443 samples found in RAP
# There are 934 samples we want to analyze.
# finally there are 437 samples found in RAP
# There are 925 samples we want to analyze.
# finally there are 444 samples found in RAP
# There are 965 samples we want to analyze.
# finally there are 459 samples found in RAP
# There are 943 samples we want to analyze.
# finally there are 439 samples found in RAP
# There are 901 samples we want to analyze.
# finally there are 428 samples found in RAP
# There are 898 samples we want to analyze.
# finally there are 400 samples found in RAP
# There are 969 samples we want to analyze.
# finally there are 443 samples found in RAP
# There are 897 samples we want to analyze.
# finally there are 415 samples found in RAP
# There are 955 samples we want to analyze.
# finally there are 445 samples found in RAP
# There are 949 samples we want to analyze.
# finally there are 435 samples found in RAP
# There are 919 samples we want to analyze.
# finally there are 418 samples found in RAP
# There are 914 samples we want to analyze.
# finally there are 433 samples found in RAP
# There are 957 samples we want to analyze.
# finally there are 431 samples found in RAP
# There are 904 samples we want to analyze.
# finally there are 420 samples found in RAP
# There are 913 samples we want to analyze.
# finally there are 412 samples found in RAP
# There are 941 samples we want to analyze.
# finally there are 421 samples found in RAP
# There are 950 samples we want to analyze.
# finally there are 430 samples found in RAP
# There are 888 samples we want to analyze.
# finally there are 434 samples found in RAP
# There are 897 samples we want to analyze.
# finally there are 397 samples found in RAP
# There are 903 samples we want to analyze.
# finally there are 401 samples found in RAP
# There are 895 samples we want to analyze.
# finally there are 413 samples found in RAP
# There are 898 samples we want to analyze.
# finally there are 398 samples found in RAP
# There are 910 samples we want to analyze.
# finally there are 428 samples found in RAP
# There are 954 samples we want to analyze.
# finally there are 456 samples found in RAP
# There are 942 samples we want to analyze.
# finally there are 463 samples found in RAP
# There are 924 samples we want to analyze.
# finally there are 428 samples found in RAP
# There are 963 samples we want to analyze.
# finally there are 438 samples found in RAP
# There are 932 samples we want to analyze.
# finally there are 411 samples found in RAP
# There are 943 samples we want to analyze.
# finally there are 431 samples found in RAP
# There are 902 samples we want to analyze.
# finally there are 415 samples found in RAP
# There are 961 samples we want to analyze.
# finally there are 448 samples found in RAP
# There are 928 samples we want to analyze.
# finally there are 445 samples found in RAP
# There are 925 samples we want to analyze.
# finally there are 423 samples found in RAP
# There are 888 samples we want to analyze.
# finally there are 397 samples found in RAP
# There are 896 samples we want to analyze.
# finally there are 423 samples found in RAP
# There are 957 samples we want to analyze.
# finally there are 430 samples found in RAP
# There are 957 samples we want to analyze.
# finally there are 451 samples found in RAP
# There are 897 samples we want to analyze.
# finally there are 380 samples found in RAP
# There are 910 samples we want to analyze.
# finally there are 410 samples found in RAP
# There are 266 samples we want to analyze.
# finally there are 106 samples found in RAP