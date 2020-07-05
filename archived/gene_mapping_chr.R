library(biomaRt)
library(dplyr)
library(foreach)
library(intervals)

# setwd("~/UM/Biostatistics/Temporary_RA")
# i <- Sys.getenv("SLURM_ARRAY_TASK_ID")

mart <- useMart(biomart = "ensembl", dataset = "hsapiens_gene_ensembl")

# allfields = listAttributes(mart)

transcripts = read.table("transcripts.rpkm.tsv", stringsAsFactors = FALSE,
                         colClasses = c(rep("character", 1), rep("NULL", 86)),
                         header=TRUE)

extractID = function(fullid){
  unlist(strsplit(fullid, "[.]"))[1]
}

transcript_noversion = sapply(transcripts$transcript, extractID) %>% unname()

result = getBM(attributes = c("ensembl_gene_id", "ensembl_transcript_id", 
                               "chromosome_name", "transcript_start", "transcript_end",
                               "external_gene_name"),
                filters = "ensembl_transcript_id",
                values = transcript_noversion,
                mart = mart) 

result$transcript_start = ifelse(result$transcript_start>1e5, 
                                 result$transcript_start-1e5,
                                 1)
result$transcript_end = result$transcript_end+1e5

id_chr_match = result %>% select(ensembl_transcript_id, chromosome_name)
id_chr_match$ensembl_transcript_id = transcripts$transcript

match_filename = paste0("unionrange/ID_chr_match.csv")

write.csv(id_chr_match, match_filename, row.names=FALSE, quote=FALSE)

allchrs = c(seq(1,22),c("X","Y"))

foreach(chr=allchrs) %do%{
  subset = result %>% filter(chromosome_name==chr) %>% 
    select(chromosome_name, transcript_start, transcript_end)
  # range set union
  idf <- Intervals(subset[,2:3])
  chrunion <- as.data.frame(interval_union(idf))
  rowsub = nrow(chrunion)
  chrunion$chrid = rep(chr, rowsub)
  chrunion$rname = paste0(rep("R", rowsub), 1:rowsub)
  # move the column position
  chrunion = chrunion %>% select(chrid, everything())
  filename = paste0("unionrange/chr", chr, "_range.txt")
  write.table(chrunion, file=filename, row.names = FALSE, col.names = FALSE, 
              quote=FALSE)
  invisible(chr)
} 



