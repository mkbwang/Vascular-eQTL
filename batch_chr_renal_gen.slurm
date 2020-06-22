#!/bin/bash

#SBATCH --job-name=wangmk_renal_chr_snp
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --ntasks-per-node=6
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=500MB
#SBATCH --array=1-22
#SBATCH --time=00:30:00

/net/wonderland/home/wangmk/plink  --bfile genotypes/imputepostqc_all_filter \
      --keep subset_indv_renal.txt --extract unionrange/chr${SLURM_ARRAY_TASK_ID}_range.txt --range \
      --make-bed --out cleaned_genotypes/chr_${SLURM_ARRAY_TASK_ID}_subset_renal

