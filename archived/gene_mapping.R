#!/usr/bin/env Rscript

library(biomaRt)

i <- Sys.getenv("SLURM_ARRAY_TASK_ID")

mart <- useMart(biomart = "ensembl", dataset = "hsapiens_gene_ensembl")

# allfields = listAttributes(mart)

transcripts = read.csv("processed_transcripts",nrows=1)

t_name = toString(transcripts[1])

transcript_noversion = unlist(strsplit(t_name, "[.]"))[1]

result = getBM(attributes = c("ensembl_gene_id", "ensembl_transcript_id", 
                               "chromosome_name", "transcript_start", "transcript_end",
                               "external_gene_name"),
                filters = "ensembl_transcript_id",
                values = transcript_noversion,
                mart = mart,
                useCache = FALSE) 

restriction = paste(c("--chr", result$chromosome_name, "--from-bp", 
                      result$transcript_start - 1e5, "--to-bp", 
                      result$transcript_end + 1e5), collapse = " ")
cat(restriction)

