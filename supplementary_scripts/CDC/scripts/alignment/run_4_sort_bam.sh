#$ -S /bin/bash
#$ -N sort_bam
#$ -V
#$ -o /workdir/users/agk85/CDC/mapping/log/sort_bam_$JOB_ID.out #Location for stdout
#$ -e /workdir/users/agk85/CDC/mapping/log/sort_bam_$JOB_ID.err #Location for stderr
#$ -wd /workdir/users/agk85/CDC/mapping
#$ -l h_vmem=50G
#$ -t 1-34
#$ -q long.q@cbsubrito2

#This script will sort BWA alignments that have been filtered and then produces necessary files for rpkm script

#Set directories
WRK=/workdir/users/agk85/CDC
OUT=$WRK/mapping/metagenomes/bwa_alignments

#Create design file of file names
LIST=$WRK/MetaDesign_rerun.txt
DESIGN=$(sed -n "${SGE_TASK_ID}p" $LIST)
NAME=`basename "$DESIGN"`

echo `date` $NAME begin
# Align
cd $OUT
rm ${NAME}.sam
rm ${NAME}.filtered.sam
#This removes secondary and supplementary alignments then sorts the bam file
/programs/samtools-1.3.2/bin/samtools view -h -F 0x900 ${NAME}.filtered.bam | /programs/samtools-1.3.2/bin/samtools sort -m 10G -O BAM --threads 4 -o ${NAME}.sorted.bam -T ${NAME}
#This indexes the bam file
/programs/samtools-1.3.2/bin/samtools index ${NAME}.sorted.bam
#This creates an indexed stats file for rpkm-ing
/programs/samtools-1.3.2/bin/samtools idxstats ${NAME}.sorted.bam > ${NAME}.idxstats.txt
#This creates a depth file for rpkm-ing
/programs/samtools-1.3.2/bin/samtools depth -a ${NAME}.sorted.bam > ${NAME}.depth.txt
#This gets flagstats for sorted file
samtools flagstat ${NAME}.sorted.bam > flagstats/${NAME}_sorted_flagstats.txt

echo `date` $NAME finished
