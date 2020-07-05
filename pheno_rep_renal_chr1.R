
library(dplyr)

i <- Sys.getenv("SLURM_ARRAY_TASK_ID") %>% as.integer()


transcripts = read.csv("processed_transcript/PC5_res_qq_renal_chr1_reordered.csv")

phenoi = transcripts[,i]

famname = paste0("replace_pheno/chr_1_subset_renal_", i, ".fam")

famdata = read.table(famname, sep="", header=FALSE, stringsAsFactors=FALSE)

famdata$V6 = phenoi

write.table(famdata, famname, row.names=FALSE, col.names=FALSE, quote=FALSE)
