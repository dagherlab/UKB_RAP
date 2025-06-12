
# cpu
# module load StdEnv/2020 r/4.2.1

library(data.table)

#Read table with all fields
ukb <- as.data.frame(fread("/home/liulang/go_lab/GRCh37/ukbb/UKB_RAP//main.csv"))

#Write field of interest 189 is renamed to 22189
field <- c("20002","41270","20111","20110","20107","22001","22006","22009","22000","22189","34","21022","22021","22019","22027")

#Change into pattern recognisable by grep
pattern <- paste0("^","p",field,collapse = "|")

#Selct field of interest
ukb_filtered <- ukb[,c(1,grep(pattern,names(ukb)))]
# any missing field? (check this before you proceed)
expected_prefixes <- paste0("p", field)

# Identify actual column names in ukb that match any of the expected prefixes
matched <- sapply(expected_prefixes, function(prefix) any(grepl(paste0("^", prefix), names(ukb))))

# Find fields that are not present
missing_fields <- field[!matched]

# Print missing fields
print(missing_fields)
# 22189 is in population characteristic
pop_char = data.frame(fread("/home/liulang/go_lab/GRCh37/ukbb/UKB_RAP/UKB_online_follow_up.csv"))
towsend = pop_char[,c("eid","p22189")]


ukb_filtered = merge(ukb_filtered,towsend,by = "eid")
#Select PD self-reported (1262) and ICD10 code (32330):
#SELF-REPORT DATA
ukb_self <- ukb_filtered[,c(1,grep("^p20002",names(ukb_filtered)))]

PD_self <- ukb_self[which(apply(ukb_self[,-1],1,function(i){any(i == 1262)})),]$eid

#ICD10 DATA
ukb_ICD10 <- ukb_filtered[,c(1,grep("^p41270",names(ukb_filtered)))]
g20_rows <- grepl("\\bG20\\b", ukb_ICD10[, 2])


PD_ICD <- ukb_ICD10$eid[g20_rows]



#Example Code: PD <- union(PD_self, PD_ICD)
PD <- union(PD_self,PD_ICD)


# this one is not right!!!!
#Select proxy cases from father, mother, sibling, and exclude PD cases
ukb_proxy <- ukb_filtered[,c(1,grep("^p20111|^p20110|^p20107",names(ukb_filtered)))]
# PD_proxy_notexcluding_PD <- ukb_proxy[which(apply(ukb_proxy,1,function(i){any(i == 11)})),]$eid

has_11 <- apply(ukb_proxy[,-1], 1, function(row) {
  combined <- paste(row, collapse = "|")  # Combine all columns
  grepl("(?<!-)\\b11\\b", combined, perl = TRUE)             # Search for whole '11' word and avoid -
})

# Step 3: Extract matching eids
eids_with_11 <- ukb_proxy$eid[has_11]


PD_proxy <- setdiff(eids_with_11, PD)

#Select the rest as controls
PD_control <- setdiff(ukb_filtered$eid,union(PD_proxy,PD))

#Perform filter for samples with known issue (aneupleudy, missingness, het outlier) and relatedness (0 = no closer than 3rd degree relative) & ancestry filter (1 = causacian)
ukb_unrelated <- readLines("~/runs/go_lab/GRCh37/ukbb/ukbb_raw_data_no_cousins.txt")

ukb_filtered_unrelated <- ukb_filtered[ukb_filtered$eid %in% ukb_unrelated,]
ukb_filtered_unrelated_euro <- ukb_filtered_unrelated[ukb_filtered_unrelated$p22006 %in% 1,]
ukb_filtered_unrelated_euro_aneu <- ukb_filtered_unrelated_euro[!(ukb_filtered_unrelated_euro$p22019 %in% 1),]
ukb_filtered_unrelated_euro_aneu_miss <- ukb_filtered_unrelated_euro_aneu[!(ukb_filtered_unrelated_euro_aneu$p22027 %in% 1),]

#Add pc's
PC <- as.data.frame(fread("~/runs/go_lab/GRCh37/ukbb/pc_euro.txt"))
PC$IID <- NULL
names(PC)[1] <- "eid"

#Select covariates used in GWAS
covar_field <- c("22001","22000","22189","34","21022","22009")# PC is not included here

covar <- paste0("^","p",covar_field,collapse = "|")
ukb_covar <- ukb_filtered_unrelated_euro_aneu_miss[,c(1,grep(covar,names(ukb_filtered_unrelated_euro_aneu_miss)))]
ukb_covar_pc10 <- merge(ukb_covar[,c("eid","p34","p22189","p21022","p22000",'p22001')],PC)
#Rename covariates
names(ukb_covar_pc10) <- c("ID", "YearAtBirth", "Townsend", "AgeAtRecruit", "Batch", "Sex", "pc1", "pc2", "pc3", "pc4", "pc5", "pc6", "pc7", "pc8", "pc9", "pc10")
ukb_covar_pc10$Sex = ifelse(ukb_covar_pc10$Sex == 0, 2, ukb_covar_pc10$Sex) # to keep it consistent with plink format
#Save seperate covariate for each type of disorder(Tic, OCD, ADHD) and their respective  case and control

write.csv(ukb_covar_pc10[ukb_covar_pc10$ID %in% PD,], "~/go_lab/GRCh37/ukbb//ukbb_PD_covar.txt", quote = F, row.names = F)
write.csv(ukb_covar_pc10[ukb_covar_pc10$ID %in% PD_proxy,], "~/go_lab/GRCh37/ukbb//ukbb_PD_proxy_covar.txt", quote = F, row.names = F)
write.csv(ukb_covar_pc10[ukb_covar_pc10$ID %in% PD_control,], "~/go_lab/GRCh37/ukbb//ukbb_PD_control_covar.txt", quote = F, row.names = F)
