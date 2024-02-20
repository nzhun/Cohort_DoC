#!/bin/bash

#SBATCH --job-name=collect_summary
#SBATCH --output=log/collect_summary_%A_%a.out
#SBATCH --error=log/collect_summary_%A_%a.err
#SBATCH --time=20-20:00:00
#SBATCH --ntasks=1
#SBATCH --mem=10G


folder=$1  ## depth folder
fout=$2  ## depth summary file
echo -e "ID\tMean\tMedian\t10\t15\t20" > $fout
for f in $(ls $folder/*.mosdepth.region.dist.txt); do stat=$(grep 'total' $f |awk 'BEGIN{s=0;d10=0;d15=0;d20=0;l=0;m=0;FS="\t";OFS="\t"}{ s=s+$2*($3-l);if($2>=10){d10=$3} if($2>=15){d15=$3} if($2>=20){d20=$3} if($3>=0.5 && l <0.5 ){m=$2;} l=$3;}END{print s,m,d10,d15,d20}'); bm=$(basename $f|sed 's/.mosdepth.region.dist.txt//g'); echo -e $bm"\t"$stat >> $fout; done

echo "output to ".$fout
