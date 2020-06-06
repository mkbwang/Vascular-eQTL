library(dplyr)

#read in data
info = read.csv("PedsTissue_SampleData.csv")

# filter out those with out IIDs
info = na.omit(info)

iids = unique(info$IID.GWAS)

fullfam = read.table("genotypes/imputepostqc_all_filter.fam", sep="\t", header=FALSE)

# filter step
subfam = fullfam %>% filter(V2 %in% iids)

# write the filtered individuals to another file
write.table(subfam, file="subset_indv.txt", row.names=FALSE, col.names=FALSE, quote=FALSE)

