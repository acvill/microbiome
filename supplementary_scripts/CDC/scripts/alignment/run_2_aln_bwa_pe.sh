#$ -S /bin/bash
#$ -N bwa_cdc
#$ -V
#$ -o /workdir/users/agk85/CDC/mapping/log/bwa_$JOB_ID.out #Location for stdout
#$ -e /workdir/users/agk85/CDC/mapping/log/bwa_$JOB_ID.err #Location for stderr
#$ -wd /workdir/users/agk85/CDC/mapping
#$ -l h_vmem=60G
#$ -t 1-34
#$ -q short.q@cbsubrito2

#This script will align data to a chosen reference as paired end reads using BWA

#Set directories
WRK=/workdir/users/agk85/CDC
OUT=$WRK/mapping/metagenomes/bwa_alignments
if [ ! -e $OUT ]; then mkdir -p $OUT; fi
FLAGSTATS=$OUT/flagstats
if [ ! -e $FLAGSTATS ]; then mkdir -p $FLAGSTATS; fi

#Create design file of file names
LIST=$WRK/MetaDesign_rerun.txt
DESIGN=$(sed -n "${SGE_TASK_ID}p" $LIST)
NAME=`basename "$DESIGN"`
PATIENT=$(echo $NAME | cut -d'-' -f1)

READ1=/workdir/data/CDC/metagenomes/${NAME}.1.fastq
READ2=/workdir/data/CDC/metagenomes/${NAME}.2.fastq

#BWA mem takes the prefix of the header files
#If you have never run this before with a specific reference, you need to index the reference first. Refer to "run_create_bwa_index.qsub"
REF=$WRK/mapping/metagenomes/references/${PATIENT}_nr

# Align
cd $OUT

echo `date` ${NAME} start
# This is running BWA MEM with 4 threads and -a (all). refer to the BWA manual for options
bwa mem -a -t 4  $REF $READ1 $READ2 > ${NAME}.sam
samtools view -bh ${NAME}.sam  > ${NAME}.temp.bam
samtools flagstat ${NAME}.temp.bam > $FLAGSTATS/${NAME}_prefilter_flagstats.txt
rm ${NAME}.temp.bam

echo `date` ${NAME} finish
