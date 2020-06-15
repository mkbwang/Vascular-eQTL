library(dplyr)

i <- Sys.getenv("SLURM_ARRAY_TASK_ID")

sids = read.table("transformed_rpkm.txt", nrows=1, stringsAsFactors=FALSE) %>% as.vector()
transcripts = read.table("transformed_rpkm.txt",nrows=1, skip=i, stringsAsFactors = FALSE) %>% as.vector()

# a names vector with the transcript value and sample id
names(transcripts) = sids

# read in the fam file whose phenotype to be changed
filename = paste(c("subset", "renal", i), collapse="_")
famname = paste0("cleaned_genotypes/", filename, ".fam")

famdata = read.table(famname, sep="", header=FALSE, stringsAsFactors=FALSE)

# read in the subset_indv_renal.txt file
referencefile = read.table("subset_indv_renal.txt", sep="", header=FALSE, stringsAsFactors=FALSE)


# replace the sixth column , which is the phenotype

famdata$V6 = unlist(transcripts[referencefile$V7])

# write back the data

write.table(famdata, famname, row.names=FALSE, col.names=FALSE, quote=FALSE)







