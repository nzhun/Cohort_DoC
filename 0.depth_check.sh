#!/bin/bash

#SBATCH --job-name=mosdepth_generate
#SBATCH --output=log/depth_summary_%A_%a.out
#SBATCH --error=log/depth_summary_%A_%a.err
#SBATCH --time=20-20:00:00
#SBATCH --ntasks=1
#SBATCH --mem=10G



InpFil=$1  ## cram list
fbed=$2  ## capture kit
outpath=$3  ## output folder
fref="/share/terra/rsrc/hg38/ref/GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.fna.gz"


if [[ ! -e "${ArrNum}" ]]
then
    ArrNum=$SLURM_ARRAY_TASK_ID
 fi
        #set local variables
InpFil=`readlink -f $InpFil` #resolve absolute path to bam
BamFil=$(tail -n+$ArrNum $InpFil | head -n 1|awk '{print $1}')
#fbam=$(head -n $N $flist|tail -n 1)
fout=$(basename $BamFil|sed 's/.cram//g'|sed 's/.bam//g')
cmd="-f $fref"
if [[ "$BamFil"  == *bam  ]];then
 cmd=""
fi

#echo "mosdepth -f $fref -b $fbed -n -q -T 1,5,10,15,20,25,30,50 perSample/$fout  $BamFil"
echo "mosdepth $cmd  -b $fbed -T 0,1,5,10,15,20,25,30,50 $outpath/$fout  $BamFil "
 
mosdepth  $cmd  -b $fbed  -T 0,10,15,20,25,30 $outpath/$fout  $BamFil 

