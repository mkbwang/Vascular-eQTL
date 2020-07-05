#!/bin/bash

#SBATCH --job-name=wangmk_renal_snp
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --ntasks-per-node=6
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=500MB
#SBATCH --array=1-5
#SBATCH --time=00:30:00

restriction=$(Rscript gene_mapping.R)

/net/wonderland/home/wangmk/plink  --bfile genotypes/imputepostqc_all_filter \
 	 --keep subset_indv_renal.txt $restriction \
 	  --make-bed --out cleaned_genotypes/subset_renal_$SLURM_ARRAY_TASK_ID

Rscript pheno_rep_renal.R

