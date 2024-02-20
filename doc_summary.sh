## # flist: bam/cram file list
## fbed: capture kit bed file
## fout: the output folder for tempary files
echo "cramlist bedfile outFolder"
cd /share/terra/Users/nz2274/Obesity/LABS2_data/coverage/
flist=$1
#fbed=$2
fbed=/share/terra/Projects/Obesity/LABS-2/resources/twist_comprehensive_exome_hg38.bed
fout=$2
n=$(wc -l $flist|awk '{print $1}')
nm=$(basename $flist)"."$(basename $fbed)
#jid=$(sbatch --array 1-$(wc -l $flist|cut -f 1 -d " ") script/depth_check.sh  $flist  $fbed $fout)
jid="3643656"
sbatch --dependency=afterok:$jid  script/qsub_collect_summary.sh  $fout  $nm.doc_summary.txt

#qsub -hold_jid $jid  /home/nz2274/Pipeline/NA_script/qsub_collect_summary.sh  $fout  $nm.doc_summary.txt"

flist_base=$nm.perbase.list
fpart_bed=$fbed.parted.bed.list
fout_doc=doc_part
mkdir $fout_doc
bed_folder=bed_regions
mkdir $bed_folder

#perl /home/nz2274/Pipeline/NA_script/splitBigFileToparts.pl $fbed 100
perl   $TERRA/Pipeline/NA_script/splitBigFileToparts.pl $fbed  $bed_folder/
#perl splitBigFileTosmall.pl  $bed  1000
cd ..
ls $bed_folder/*.bed >$fpart_bed
ls $fout/*base*gz > $flist_base
nn=$(wc -l $fpart_bed|awk '{print $1}')
j2=$(sbatch -a 1-$nn script/qsub_collect_base.sh  $flist_base $fpart_bed $fout_doc )

sbatch --dependency=afterok: $j2 script/log.sh

cat $fout_doc/*.1.bed.txt|sort -k1,1n -k2,2n -k3,3n > $nm.doc_perbase.anno.txt
for i in { 2..$nn }
do
egrep -v '^#' $fout_doc/*.$i.bed.txt|sort -k1,1n -k2,2n -k3,3n  >> $nm.doc_perbase.anno.txt
done



