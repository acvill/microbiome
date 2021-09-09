#$ -S /bin/bash
#$ -N bwa_cdc
#$ -V
#$ -o /workdir/users/agk85/CDC/mapping/log/bwa_$JOB_ID.out #Location for stdout
#$ -e /workdir/users/agk85/CDC/mapping/log/bwa_$JOB_ID.err #Location for stderr
#$ -wd /workdir/users/agk85/CDC/mapping
#$ -l h_vmem=10G
#$ -t 60
#$ -q short.q@cbsubrito2

#This script will align data to a chosen reference as paired end reads using BWA

#Set directories
WRK=/workdir/users/agk85/CDC
OUT=$WRK/mapping/genomes/bwa_alignments
if [ ! -e $OUT ]; then mkdir -p $OUT; fi
FLAGSTATS=$OUT/flagstats
if [ ! -e $FLAGSTATS ]; then mkdir -p $FLAGSTATS; fi

#Create design file of file names
LIST=$WRK/MetaDesign_isomap.txt
DESIGN=$(sed -n "${SGE_TASK_ID}p" $LIST)
NAME=`basename "$DESIGN"`
LIST=$WRK/GenomeDesign_isomap.txt
DESIGN=$(sed -n "${SGE_TASK_ID}p" $LIST)
ISOLATE=`basename "$DESIGN"`

READ1=/workdir/data/CDC/metagenomes/merged/unzip/${NAME}.1.fastq
READ2=/workdir/data/CDC/metagenomes/merged/unzip/${NAME}.2.fastq

#BWA mem takes the prefix of the header files
#If you have never run this before with a specific reference, you need to index the reference first. Refer to "run_create_bwa_index.qsub"
# /programs/bwa-0.7.8/bwa index -a bwtsw -p B320-1s B320-1s_scaffolds.fasta
REF=$WRK/mapping/genomes/references/${ISOLATE}

# Align
cd $OUT

echo `date` ${NAME} start
# This is running BWA MEM with 4 threads and -a (all). refer to the BWA manual for options
bwa mem -a -t 4  $REF $READ1 $READ2 > ${NAME}_${ISOLATE}.sam
samtools view -bh ${NAME}_${ISOLATE}.sam  > ${NAME}_${ISOLATE}.temp.bam
samtools flagstat ${NAME}_${ISOLATE}.temp.bam > $FLAGSTATS/${NAME}_${ISOLATE}_prefilter_flagstats.txt
rm ${NAME}_${ISOLATE}.temp.bam

echo `date` ${NAME} finish
