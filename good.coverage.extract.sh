#!/bin/bash

#SBATCH --job-name=good.coverage
#SBATCH --output=log/good.coverage_%A_%a.out
#SBATCH --error=log/good.coverage_%A_%a.err
#SBATCH --time=20-20:00:00
#SBATCH --ntasks=1
#SBATCH --mem=10G


zcat /share/vault/Users/nz2274/LABS/rare_coding/LABS2_data/coverage/LABS2.coverage.doc_perbase.bed.gz|awk 'BEGIN{FS="\t";OFS="\t"}{if($7 > 0.9 && $8 > 0.8){print}}'|cut -f 1-4 > /share/vault/Users/nz2274/LABS/rare_coding/LABS2_data/coverage/LABS2.TWIST.cov10gt0.9.cov15gt0.8.bed

bedtools merge  -i /share/vault/Users/nz2274/LABS/rare_coding/LABS2_data/coverage/LABS2.TWIST.cov10gt0.9.cov15gt0.8.bed > /share/vault/Users/nz2274/LABS/rare_coding/LABS2_data/coverage/LABS2.TWIST.cov10gt0.9.cov15gt0.8.merged.bed
