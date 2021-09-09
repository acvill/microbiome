#$ -S /bin/bash
#$ -N bwa_mge
#$ -V
#$ -o /workdir/users/agk85/CDC/mapping/log/bwa_mge_$JOB_ID.out #Location for stdout
#$ -e /workdir/users/agk85/CDC/mapping/log/bwa_mge_$JOB_ID.err #Location for stderr
#$ -wd /workdir/users/agk85/CDC/mapping
#$ -l h_vmem=60G
#$ -t 1-34
#$ -q short.q@cbsubrito2

#This script will align data to a chosen reference as paired end reads using BWA

#Set directories
WRK=/workdir/users/agk85/CDC
OUT=$WRK/mapping/metagenomes/bwa_mge_alignments
if [ ! -e $OUT ]; then mkdir -p $OUT; fi
FLAGSTATS=$OUT/flagstats
if [ ! -e $FLAGSTATS ]; then mkdir -p $FLAGSTATS; fi

#Create design file of file names
LIST=$WRK/MetaDesign_rerun.txt
DESIGN=$(sed -n "${SGE_TASK_ID}p" $LIST)
NAME=`basename "$DESIGN"`

READ1=/workdir/data/CDC/metagenomes/merged/${NAME}.1.fastq
READ2=/workdir/data/CDC/metagenomes/merged/${NAME}.2.fastq

gunzip ${READ1}.gz
gunzip ${READ2}.gz

#BWA mem takes the prefix of the header files
#If you have never run this before with a specific reference, you need to index the reference first. Refer to "run_create_bwa_index.qsub"
REF=$WRK/mapping/metagenomes/references/mge_nr

# Align
cd $OUT

echo `date` ${NAME} start
# This is running BWA MEM with 4 threads and -a (all). refer to the BWA manual for options
bwa mem -a -t 4  $REF $READ1 $READ2 > ${NAME}.sam
samtools view -bh ${NAME}.sam  > ${NAME}.temp.bam
samtools flagstat ${NAME}.temp.bam > $FLAGSTATS/${NAME}_prefilter_flagstats.txt
rm ${NAME}.temp.bam

gzip ${READ1}
gzip ${READ2}

echo `date` ${NAME} finish
