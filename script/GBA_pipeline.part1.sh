# WHAT I did here
# get IDs we are gonna analyze
# generate commands for these batches
## this is for lydia's project
# # set up 
# cut -d"," -f2 ../GBA_Gauchian/UKB_IDs_with_t1.csv|tail -n +2 > ../GBA_Gauchian/UKB_ID.txt 
# ## select a group of test IDs
# grep "^10" ../GBA_Gauchian/UKB_ID.txt |head -n 10 > test_ID10.txt
## previous ../GBA_Gauchian/ is renamed to ../GBA_Gauchian_lydia/
## this is for cem's project
# his sample is cem_152_samples.txt

export PATH=$PATH:/home/liulang/.local/bin
module load StdEnv/2020 python/3.8.10
rm submission_command.txt
# # Loop through unique two-digit prefixes
# input_file=../GBA_Gauchian/UKB_ID.txt
# input_file=cem_152_samples.txt
input_file=~/runs/lang/data/GBA1_Gauchian_UKB/qinjm.csv
# subset by Caucasian
dos2unix $input_file
output_folder=../GBA_Gauchian_QJM
# grep -f<(cut -f1 /home/liulang/go_lab/GRCh37/ukbb/pc_euro.txt) $input_file > $output_folder/imaging_euro_ID.txt 
input_file=$output_folder/imaging_euro_ID.txt 
mkdir -p $output_folder
awk '{print substr($0, 1, 2)}' "$input_file" | sort -u | while read prefix; do
    # Create files named IDXX.txt based on the prefix
    if [ ! -f $output_folder/tmp_${prefix}.txt ];then
        grep "^$prefix" "$input_file" > "$output_folder/UKB_ID${prefix}.txt"
        # dragen and gatk, which one?
        if [ ! -f $output_folder/UKBRAP_${prefix}.txt ];then
        dx find data --path "/Bulk/GATK and GraphTyper WGS/Whole genome GATK CRAM files and indices [500k release]//${prefix}/" --name "*.cram" --delim > $output_folder/UKBRAP_${prefix}.txt # IDs available on UKB RAP
        fi
        # dx find data --path "/Bulk/DRAGEN WGS/Whole genome CRAM files (DRAGEN) [500k release]//${prefix}/" --name "*.cram" --delim > ../$output_folder/UKBRAP_${prefix}.txt # IDs available on UKB RAP
        grep -f $output_folder/UKB_ID${prefix}.txt $output_folder/UKBRAP_${prefix}.txt | cut -f4 | sed 's|.*/||' > $output_folder/manifest_${prefix}.txt # OVERLAP
        grep -f $output_folder/UKB_ID${prefix}.txt $output_folder/UKBRAP_${prefix}.txt > $output_folder/tmp_${prefix}.txt
        echo "There are $(wc -l < $output_folder/UKB_ID${prefix}.txt) samples we want to analyze."
        echo "finally there are $(wc -l < $output_folder/manifest_${prefix}.txt) samples found in RAP"
    fi 
    python create_job_submission.py $output_folder/tmp_${prefix}.txt 100 ${prefix} >> submission_command.txt
done
## uncomment this upload manifest files
# dx mkdir -p IDs/
# dx upload $output_folder/manifest_* --path IDs/


# There are 1689 samples we want to analyze.
# finally there are 1680 samples found in RAP
# There are 1609 samples we want to analyze.
# finally there are 1601 samples found in RAP
# There are 1594 samples we want to analyze.
# finally there are 1589 samples found in RAP
# There are 1643 samples we want to analyze.
# finally there are 1636 samples found in RAP
# There are 1661 samples we want to analyze.
# finally there are 1656 samples found in RAP
# There are 1631 samples we want to analyze.
# finally there are 1625 samples found in RAP
# There are 1685 samples we want to analyze.
# finally there are 1681 samples found in RAP
# There are 1551 samples we want to analyze.
# finally there are 1547 samples found in RAP
# There are 1647 samples we want to analyze.
# finally there are 1645 samples found in RAP
# There are 1667 samples we want to analyze.
# finally there are 1654 samples found in RAP
# There are 1721 samples we want to analyze.
# finally there are 1713 samples found in RAP
# There are 1668 samples we want to analyze.
# finally there are 1661 samples found in RAP
# There are 1649 samples we want to analyze.
# finally there are 1638 samples found in RAP
# There are 1601 samples we want to analyze.
# finally there are 1596 samples found in RAP
# There are 1645 samples we want to analyze.
# finally there are 1641 samples found in RAP
# There are 1621 samples we want to analyze.
# finally there are 1616 samples found in RAP
# There are 1630 samples we want to analyze.
# finally there are 1620 samples found in RAP
# There are 1638 samples we want to analyze.
# finally there are 1631 samples found in RAP
# There are 1623 samples we want to analyze.
# finally there are 1613 samples found in RAP
# There are 1690 samples we want to analyze.
# finally there are 1684 samples found in RAP
# There are 1619 samples we want to analyze.
# finally there are 1613 samples found in RAP
# There are 1703 samples we want to analyze.
# finally there are 1696 samples found in RAP
# There are 1616 samples we want to analyze.
# finally there are 1610 samples found in RAP
# There are 1630 samples we want to analyze.
# finally there are 1620 samples found in RAP
# There are 1609 samples we want to analyze.
# finally there are 1602 samples found in RAP
# There are 1651 samples we want to analyze.
# finally there are 1648 samples found in RAP
# There are 1645 samples we want to analyze.
# finally there are 1634 samples found in RAP
# There are 1606 samples we want to analyze.
# finally there are 1600 samples found in RAP
# There are 1658 samples we want to analyze.
# finally there are 1646 samples found in RAP
# There are 1639 samples we want to analyze.
# finally there are 1635 samples found in RAP
# There are 1703 samples we want to analyze.
# finally there are 1694 samples found in RAP
# There are 1675 samples we want to analyze.
# finally there are 1670 samples found in RAP
# There are 1618 samples we want to analyze.
# finally there are 1610 samples found in RAP
# There are 1602 samples we want to analyze.
# finally there are 1594 samples found in RAP
# There are 1622 samples we want to analyze.
# finally there are 1614 samples found in RAP
# There are 1636 samples we want to analyze.
# finally there are 1629 samples found in RAP
# There are 1583 samples we want to analyze.
# finally there are 1571 samples found in RAP
# There are 1564 samples we want to analyze.
# finally there are 1552 samples found in RAP
# There are 1633 samples we want to analyze.
# finally there are 1631 samples found in RAP
# There are 1650 samples we want to analyze.
# finally there are 1639 samples found in RAP
# There are 1641 samples we want to analyze.
# finally there are 1632 samples found in RAP
# There are 1592 samples we want to analyze.
# finally there are 1585 samples found in RAP
# There are 1641 samples we want to analyze.
# finally there are 1635 samples found in RAP
# There are 1658 samples we want to analyze.
# finally there are 1655 samples found in RAP
# There are 1606 samples we want to analyze.
# finally there are 1598 samples found in RAP
# There are 1638 samples we want to analyze.
# finally there are 1633 samples found in RAP
# There are 1593 samples we want to analyze.
# finally there are 1591 samples found in RAP
# There are 1652 samples we want to analyze.
# finally there are 1645 samples found in RAP
# There are 1627 samples we want to analyze.
# finally there are 1619 samples found in RAP
# There are 1609 samples we want to analyze.
# finally there are 1599 samples found in RAP
# There are 417 samples we want to analyze.
# finally there are 417 samples found in RAP