#!/bin/bash

#SBATCH --job-name=wangmk_snp_subsetting
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --ntasks-per-node=6
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=500MB
#SBATCH --array=1-10
#SBATCH --time=00:30:00

restriction=$(Rscript gene_mapping.R)

/net/wonderland/home/wangmk/plink  --bfile genotypes/imputepostqc_all_filter \
 	 --keep subset_indv.txt $restriction \
 	  --make-bed --out cleaned_genotypes/subset_$SLURM_ARRAY_TASK_ID
