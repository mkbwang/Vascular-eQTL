library(dplyr)

#read in data
info = read.csv("PedsTissue_SampleData.csv", stringsAsFactors=FALSE)

# filter out those with out IIDs
info = na.omit(info)

# measurements of renal tissues
renal_info = info %>% filter(tissue=="renal")

# individual IDs
iids = renal_info$IID.GWAS

# sample IDs
sample_ids = renal_info$sampleID
names(sample_ids) = iids

fullfam = read.table("genotypes/imputepostqc_all_filter.fam", sep="\t", header=FALSE, stringsAsFactors=FALSE)

# filter step
subfam = fullfam %>% filter(V2 %in% iids)


# add a column with the corresponding sample IDs
subfam$sampleID = NA
subfam$sampleID = sample_ids[subfam$V2]


# write the filtered individuals to another file
write.table(subfam, file="subset_indv_renal.txt", row.names=FALSE, col.names=FALSE, quote=FALSE)

