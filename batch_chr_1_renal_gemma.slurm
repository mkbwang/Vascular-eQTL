#!/bin/bash

#SBATCH --job-name=wangmk_renal_chr_1
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --ntasks-per-node=12
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=100MB
#SBATCH --array=1-7213
#SBATCH --time=05:00:00


restriction=$(Rscript gene_mapping_chr1.R)

/net/wonderland/home/wangmk/plink  --bfile genotypes/imputepostqc_all_filter \
 	 --keep subset_indv_renal.txt $restriction \
 	  --make-bed --out replace_pheno/chr_1_subset_renal_${SLURM_ARRAY_TASK_ID}

Rscript pheno_rep_renal_chr1.R


gemma -bfile replace_pheno/chr_1_subset_renal_${SLURM_ARRAY_TASK_ID} -k \
 output/subset_renal_total.cXX.txt -lmm 3 \
 -o chr_1_subset_renal_${SLURM_ARRAY_TASK_ID}


