library(dplyr)
library(foreach)
library(doParallel)
registerDoParallel(cores=4)

pos = read.table("GWAS/chr_1_subset_renal_1.assoc.txt", sep="",
                         colClasses = c(rep("NULL", 2), c("integer"), rep("NULL", 8)),
                         header=TRUE)

transcript_name = colnames(read.csv("processed_transcript/PC5_res_qq_renal_chr1.csv"))

aggregate_min_pval = foreach(i=1:7213, .combine = 'rbind', 
  .packages = "dplyr", .export = c("transcript_name")) %dopar% {
  filename = paste0("GWAS/chr_1_subset_renal_", i, ".assoc.txt")
  result = read.table(filename, sep="",
                         colClasses = c(rep("NULL", 2), c("integer"), rep("NULL", 7), c("numeric")),
                         header=TRUE)
  min_pval = result %>% slice(which.min(p_score))
  min_pval$transcript = transcript_name[i]
  if (i %% 100 == 0){
    cat(i, "transcripts read\n")
  }
  min_pval
}

write.csv(aggregate_min_pval, "GWAS/chr1_subset_renal_pval_min.csv", row.names=FALSE)
