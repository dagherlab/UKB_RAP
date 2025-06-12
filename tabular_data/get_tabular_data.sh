# get all field names
dx extract_dataset project-GvFxJ08J95KXx97XFz8g2X2g:record-Gzf082QJB0k8bF6ByK1xzfb1 -ddd --delimiter ","
# The above command will generate 3 *.csv files, and the *.dataset.data_dictionary.csv 
# file contains full information about all available data-fields 
# (the field names are in the second column called name).

# use merge_data.r to merge all data
module load r/4.2.1
# 2025.04.19 (didn't merge the assessment center)
srun -c 10 --mem=20g -t 3:0:0 --account=def-grouleau Rscript merge_data.r andrew.csv cem.csv jianmei2.csv jianmei.csv lydia.csv Lang.csv  main
cp main.* UKB_assessment_center.csv ~/go_lab/GRCh37/ukbb/UKB_RAP/
cp main.* UKB_assessment_center.csv ~/liulang2/data/


# 2025.04.17
Rscript merge_data.r /home/liulang/lang/UKB_RAP/tabular_data/jianmei2.csv /home/liulang/liulang2/data/lydia.csv /home/liulang/liulang2/data/jianmei.csv /home/liulang/liulang2/data/andrew.csv /home/liulang/go_lab/GRCh37/ukbb/UKB_RAP/main
Rscript merge_data.r ~/go_lab/GRCh37/ukbb/UKB_RAP/main.csv  ~/go_lab/GRCh37/ukbb/UKB_RAP/cem.csv ~/scratch/main
chgrp rrg-grouleau-ac /home/liulang/go_lab/GRCh37/ukbb/UKB_RAP/*

file="Cohort_Browser.data_dictionary.csv"
export PATH="$HOME/.local/bin:$PATH"

# PUT FIELDS IN DIFFERENT ENTITIY TO DIFFERENT FILES!!!
# eid is available in all entities. so specify it in table exporter!!!
# use my previous configuration to download data!!
# COMMANDER results
echo "eid" > field_name_commander.txt
grep -E 'id=42018($|[^0-9])' "$file" |cut -f2 -d, >> field_name_commander.txt
grep -E 'id=42022($|[^0-9])' "$file" |cut -f2 -d, >> field_name_commander.txt
grep -E 'id=42024($|[^0-9])' "$file" |cut -f2 -d, >> field_name_commander.txt
grep -E 'id=42028($|[^0-9])' "$file" |cut -f2 -d, >> field_name_commander.txt
grep -E 'id=42030($|[^0-9])' "$file" |cut -f2 -d, >> field_name_commander.txt
grep -E 'id=42032($|[^0-9])' "$file" |cut -f2 -d, >> field_name_commander.txt
grep -E 'id=42034($|[^0-9])' "$file" |cut -f2 -d, >> field_name_commander.txt
grep -E 'id=42036($|[^0-9])' "$file" |cut -f2 -d, >> field_name_commander.txt

# jianmei 5
echo "eid" > field_name_jianmei5.txt
echo "p90016" >> field_name_jianmei5.txt

# jianmei 4

echo "eid" > field_name_jianmei4.txt
grep "Acceleration average" "$file" |cut -f2 -d, >>field_name_jianmei4.txt


# jianmei3
echo "eid" > field_name_jianmei3.txt
grep "Assessment centre" "$file" |cut -f2 -d, >>field_name_jianmei3.txt



#cem
field_file=field_name_cem.txt
echo "eid" > $field_file
cut -f1 -d":" cem.txt |while read field;do 
grep -E "id=${field}($|[^0-9])" "$file" | cut -f2 -d, >> $field_file
done



# jianmei 2
echo "eid" > field_name_jianmei2.txt
grep -E 'id=12188($|[^0-9])' "$file" |cut -f2 -d, >> field_name_jianmei2.txt
grep -E 'id=42030($|[^0-9])' "$file" |cut -f2 -d, >> field_name_jianmei2.txt
grep -E 'id=42032($|[^0-9])' "$file" |cut -f2 -d, >> field_name_jianmei2.txt



# Questionaire from Han Yong
echo "eid" > field_name_online_follow_up.txt

grep "Baseline characteristics" "$file" |cut -f2 -d, >>field_name_online_follow_up.txt
grep "Online follow-up" "$file" |cut -f2 -d, >>field_name_online_follow_up.txt
# get corresponding field name and coding
grep "Baseline characteristics" "$file"  > data_coding_online_follow_up.txt
grep "Online follow-up" "$file" > data_coding_online_follow_up.txt

grep -f<(cut -f5 -d, data_coding_online_follow_up.txt|sort|uniq) Cohort_Browser.codings.csv > UKB_online_followup.coding.csv


# Andrew
echo "eid" > field_name_andrew.txt
grep -E 'id=1160($|[^0-9])' "$file" |cut -f2 -d, >> field_name_andrew.txt
grep -E 'id=1170($|[^0-9])' "$file" |cut -f2 -d, >> field_name_andrew.txt
grep -E 'id=1180($|[^0-9])' "$file" |cut -f2 -d, >> field_name_andrew.txt
grep -E 'id=1190($|[^0-9])' "$file" |cut -f2 -d, >> field_name_andrew.txt
grep -E 'id=1200($|[^0-9])' "$file" |cut -f2 -d, >> field_name_andrew.txt
grep -E 'id=1210($|[^0-9])' "$file" |cut -f2 -d, >> field_name_andrew.txt
grep -E 'id=1220($|[^0-9])' "$file" |cut -f2 -d, >> field_name_andrew.txt
dx upload field_name_andrew.txt tabular_data/

# Jianmei
echo "eid" > field_name_jianmei.txt
grep -E 'id=53($|[^0-9])' "$file" |cut -f2 -d, >> field_name_jianmei.txt 
grep -E 'id=131022($|[^0-9])' "$file" |cut -f2 -d, >> field_name_jianmei.txt
grep -E 'id=42032($|[^0-9])' "$file" |cut -f2 -d, >> field_name_jianmei.txt
grep -E 'id=40001($|[^0-9])' "$file" |cut -f2 -d, >> field_name_jianmei.txt
grep -E 'id=40002($|[^0-9])' "$file" |cut -f2 -d, >> field_name_jianmei.txt
grep -E 'id=41270($|[^0-9])' "$file" |cut -f2 -d, >> field_name_jianmei.txt
grep -E 'id=41280($|[^0-9])' "$file" |cut -f2 -d, >> field_name_jianmei.txt

grep olink_instance_0 "$file" |cut -f2 -d, > file_name_olink.txt
grep olink_instance_2 "$file" |cut -f2 -d, > file_name_olink2.txt
grep olink_instance_3 "$file" |cut -f2 -d, > file_name_olink3.txt

# tail -n +2 category_210.txt|cut -f1 | while read line; do 
#     echo $line 
#     grep -E "id=${line}($|[^0-9])" "$file"|cut -f2 -d,
# done 

dx upload field_name_jianmei.txt tabular_data/
# Lydia
grep 'id=20002' "$file" |cut -f2 -d, >> field_name.txt 
grep 'id=131022' "$file" |cut -f2 -d, >> field_name.txt
grep 'id=53' "$file" |cut -f2 -d, >> field_name.txt
grep 'id=46' "$file" |cut -f2 -d, >> field_name.txt
grep 'id=47' "$file" |cut -f2 -d, >> field_name.txt





# put fields of interest in field_name.txt and upload
# Step 2. Collect all data-field names of interest, 
# and write them into a field_name.txt file. 
# The file should have 1 column, and each line has only 1 data-field name. 
# The file above should contain only data-fields in the same Entity 
# (e.g. "participant", "olink_instance_0", etc). 
# Data–fields in different Entities should be written in separate files. 
# The value to use for Entity can be found in the first column of the .dataset.data_dictionary.csv 
# file called entity (Note: this is not the same as entity_title found in the entity_dictionary.csv file)

dx upload field_name.txt --destination  project-GvFxJ08J95KXx97XFz8g2X2g:tabular_data/

# use table exporter and follow https://dnanexus.gitbook.io/uk-biobank-rap/working-on-the-research-analysis-platform/accessing-data/accessing-phenotypic-data
