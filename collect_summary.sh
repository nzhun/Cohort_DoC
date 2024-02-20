fd=$1   ### folder include depth region output
fout=$2  ## prefix for the region summary output 
echo -e "ID\tMean\tMedian\t10\t15\t20" > ${fout}_region_summary.txt
for f in $(ls $fd/*.mosdepth.region.dist.txt); do stat=$(grep 'total' $f |awk 'BEGIN{s=0;d10=0;d15=0;d20=0;l=0;m=0;FS="\t";OFS="\t"}{ s=s+$2*($3-l);if($2>=10){d10=$3} if($2>=15){d15=$3} if($2>=20){d20=$3} if($3>=0.5 && l <0.5 ){m=$2;} l=$3;}END{print s,m,d10,d15,d20}'); bm=$(basename $f|sed 's/.mosdepth.region.dist.txt//g'); echo -e $bm"\t"$stat >> ${fout}_region_summary.txt; done
