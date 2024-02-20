#!/bin/bash

#SBATCH --job-name=base.collect
#SBATCH --output=log/base.collect_%A_%a.out
#SBATCH --error=log/base.collect_%A_%a.err
#SBATCH --time=20-20:00:00
#SBATCH --ntasks=1
#SBATCH --mem=10G

i=$SLURM_ARRAY_TASK_ID; #SGE_TASK_ID
#if [ $i == 23 ]; then
#	i="X"
#fi
#if [ $i == 24 ]; then
#	i="Y"
#fi
flist=$1  ##per-base.bed.gz  list
fbedlist=$2 ## bed region
fout=$3 ## output folder	
fbed=$(tail -n+$i  $fbedlist |head -n 1)
perl  /share/pascal/Users/nz2274/PCGC/script/doc/doc_base_merge_percent.pl  $flist  $fbed $fout

#perl doc_base_merge.pl  ../doc_perbase.list  $fbed


