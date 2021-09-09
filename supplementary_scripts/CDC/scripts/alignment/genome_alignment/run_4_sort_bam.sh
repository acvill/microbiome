#$ -S /bin/bash
#$ -N sort_bam
#$ -V
#$ -o /workdir/users/agk85/CDC/mapping/log/sort_bam_$JOB_ID.out #Location for stdout
#$ -e /workdir/users/agk85/CDC/mapping/log/sort_bam_$JOB_ID.err #Location for stderr
#$ -wd /workdir/users/agk85/CDC/mapping
#$ -l h_vmem=40G
#$ -t 5-8
#$ -q long.q@cbsubrito2

#This script will sort BWA alignments that have been filtered and then produces necessary files for rpkm script

#Set directories
WRK=/workdir/users/agk85/CDC
OUT=$WRK/mapping/genomes/bwa_alignments
FLAGSTATS=$OUT/flagstats

#Create design file of file names
LIST=$WRK/MetaDesign_isomap.txt
DESIGN=$(sed -n "${SGE_TASK_ID}p" $LIST)
NAME=`basename "$DESIGN"`
LIST=$WRK/GenomeDesign_isomap.txt
DESIGN=$(sed -n "${SGE_TASK_ID}p" $LIST)
ISOLATE=`basename "$DESIGN"`

#BWA mem takes the prefix of the header files
#If you have never run this before with a specific reference, you need to index the reference first. Refer to "run_create_bwa_index.qsub"
# /programs/bwa-0.7.8/bwa index -a bwtsw -p B320-1s B320-1s_scaffolds.fasta

echo `date` $NAME begin
# Align
cd $OUT
rm ${NAME}_${ISOLATE}.sam
rm ${NAME}_${ISOLATE}.filtered.sam
#This removes secondary and supplementary alignments then sorts the bam file
/programs/samtools-1.3.2/bin/samtools view -h -F 0x900 ${NAME}_${ISOLATE}.filtered.bam | /programs/samtools-1.3.2/bin/samtools sort -m 10G -O BAM --threads 4 -o ${NAME}_${ISOLATE}.sorted.bam -T ${NAME}_${ISOLATE}
#This indexes the bam file
/programs/samtools-1.3.2/bin/samtools index ${NAME}_${ISOLATE}.sorted.bam
#This creates an indexed stats file for rpkm-ing
/programs/samtools-1.3.2/bin/samtools idxstats ${NAME}_${ISOLATE}.sorted.bam > ${NAME}_${ISOLATE}.idxstats.txt
#This creates a depth file for rpkm-ing
/programs/samtools-1.3.2/bin/samtools depth -a ${NAME}_${ISOLATE}.sorted.bam > ${NAME}_${ISOLATE}.depth.txt
#This gets flagstats for sorted file
samtools flagstat ${NAME}_${ISOLATE}.sorted.bam > flagstats/${NAME}_${ISOLATE}_sorted_flagstats.txt

echo `date` $NAME finished
