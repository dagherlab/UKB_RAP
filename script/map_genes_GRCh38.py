## map gene names to their coordinates (GRCh38)
#module load python/3.8.10 scipy-stack/2020a
#step1
print("loading packages")
import argparse
import pandas as pd
import warnings
warnings.filterwarnings('ignore')
parser = argparse.ArgumentParser()
parser.add_argument("-o","--output")
parser.add_argument("-i","--input")
parser.add_argument("-p","--name")

args = parser.parse_args()

path = args.input
with open(path,"r") as f:
    genes = f.read().strip()
genes = genes.split("\n")
# remove duplicates
uniq = list(set(genes))
if len(uniq) != len(genes):
    print("duplicated genes found, they will be removed")
    genes = uniq
pathname = args.name

#ok I don't wanna manually retrieve the coordinates for each gene
#get gff file and see if I can retrieve it
### check the reference genome before you read them
## GRCh38 (uncomment this for GRCh38)
ref=pd.read_csv("~/runs/lang/reference/gencode.v47.annotation.gtf",sep = "\t",skiprows=5,header=None)
## GRCh37 (uncomment this for GRCh37)
# ref=pd.read_csv("~/runs/go_lab/gencode/gencode.v40lift37.annotation.gtf",sep = "\t",skiprows=5,header=None)

ref.columns = ["seqname","source","feature","start","end","score","strand","frame","attribute"]
ref = ref[ref.feature == "gene"]#only gene is the one we are looking at
##retrieve coordinates for genes
def get_gene_name(s):
    s = s.split(";")
    temp = list(map(lambda x: x.startswith(" gene_name"), s))
    s = pd.Series(s)
    gene_name = s[temp].iloc[0].split()[1].strip('"')
    return gene_name


ref["gene_name"] = list(map(lambda x: get_gene_name(x),ref.attribute))
ref = ref[["seqname","start","end","gene_name"]]
ref.columns = ["chr","start","end","gene"]


##get all genes and their coordinates
all = genes
all_df = ref[ref.gene.isin(set(all))]


check = set(all) ^ set(list(all_df.gene))
if len(check) == 0:
    print("all the genes have been identified in gencode, you are good")
else:
    print("please check your input gene list and see if the following gene names are valid")
    print(check)


#make bed files
p = pathname
out = args.output
print("the results bed file")
print(all_df)
# all_df.to_csv(f"{out}/{p}.GRCh37.bed",sep = "\t", index=False, header=None)
all_df.to_csv(f"{out}/{p}.GRCh38.bed",sep = "\t", index=False, header=None)