
library(dplyr)

i <- Sys.getenv("SLURM_ARRAY_TASK_ID") %>% as.numeric()


transcripts = read.csv("processed_transcript/PC5_res_qq_renal_chr1_reordered.csv")

phenoi = transcripts[,i]

famname = "cleaned_genotypes/chr_1_subset_renal.fam"

famdata = read.table(famname, sep="", header=FALSE, stringsAsFactors=FALSE)

famdata$V6 = phenoi

outname = paste0("replace_pheno/chr_1_subset_renal_", i, ".fam")

write.table(famdata, outname, row.names=FALSE, col.names=FALSE, quote=FALSE)
