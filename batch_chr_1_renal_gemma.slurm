#!/bin/bash

#SBATCH --job-name=wangmk_renal_chr_snp
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --ntasks-per-node=12
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=100MB
#SBATCH --array=1-7213
#SBATCH --time=12:00:00

cp cleaned_genotypes/chr_1_subset_renal.bed replace_pheno/chr_1_subset_renal_${SLURM_ARRAY_TASK_ID}.bed
cp cleaned_genotypes/chr_1_subset_renal.bim replace_pheno/chr_1_subset_renal_${SLURM_ARRAY_TASK_ID}.bim

Rscript pheno_rep_renal_chr1.R

gemma -bfile replace_pheno/chr_1_subset_renal_${SLURM_ARRAY_TASK_ID} -gk 1 \
 -o chr_1_subset_renal_${SLURM_ARRAY_TASK_ID}

gemma -bfile replace_pheno/chr_1_subset_renal_${SLURM_ARRAY_TASK_ID} -k \
 output/chr_1_subset_renal_${SLURM_ARRAY_TASK_ID}.cXX.txt -lmm 3 \
 -o chr_1_subset_renal_${SLURM_ARRAY_TASK_ID}

rm replace_pheno/chr_1_subset_renal_${SLURM_ARRAY_TASK_ID}.bed
rm replace_pheno/chr_1_subset_renal_${SLURM_ARRAY_TASK_ID}.bim


