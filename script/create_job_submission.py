# HOW TO USE
# dx find data --path "/Bulk/Whole genome sequences/Whole genome CRAM files/10/" --name "*.cram" --delim > inputfile_10.txt
# grep -f test_ID10.txt inputfile_10.txt|cut -f4|sed 's|.*/||' > test_manifest.txt

# dx upload test_manifest.txt --path IDs/
# grep -f test_ID10.txt inputfile_10.txt > test_tmp.txt
# find data and subset them based on our IDs.
# prefix=1
# python create_job_submission.py inputfile.txt 100 $prefix> submission_command.txt
import sys
import math
import os

input_file=sys.argv[1]
batch_size=int(sys.argv[2])
prefix=int(sys.argv[3])


def _parse_dx_delim(delim_line):
    '''parse each list of delim output from dx find into NAME, ID, SIZE, and FOLDER'''
    id=delim_line[-1]
    split_path=delim_line[3].split('/')
    folder='/'+'/'.join(split_path[:-1])
    name=split_path[-1]
    #folder and name is not used in this example, but they can be useful for some scenerio
    return name,id,folder


out="GBA1/"
ID_file="IDs/test_manifest.txt"
ID_file2=os.path.basename(ID_file)
fd=open(input_file)
lines=fd.readlines()
sample_number=len(lines)
iin_files=''
input_number=0
number_of_batch = int(math.ceil(sample_number*1.0/batch_size))
for batch_number in range(number_of_batch):
    iin_files=''
    for member in range(batch_size):
        delim_line = lines[input_number].strip().split('\t')
        name, id, folder = _parse_dx_delim(delim_line)
        file=f"{folder}/{name}"
        iin_files += '-iin=\"{}\" -iin=\"{}.crai\" '.format(file,file)
        input_number+=1
        if input_number == sample_number:
            break

    print('dx run app-swiss-army-knife \
    --instance-type mem1_ssd1_v2_x8 \
    -iimage_file="dockers/Gauchian.tar.xz" \
    -icmd="gauchian -m {ID_file2} -g 38 -o {out} -p gba_{prefix}_{batch_number} --reference /app/GRCh38_full_analysis_set_plus_decoy_hla.fa" \
    --brief \
    --project "project-GYpQ7KQJb3qV67g26PBqjgf6" \
    --priority low \
    -y \
    -iin="{ID_file}" \
    {iin_files}'.format(ID_file=ID_file,ID_file2=ID_file2,out=out,iin_files=iin_files,prefix=prefix,batch_number=batch_number))