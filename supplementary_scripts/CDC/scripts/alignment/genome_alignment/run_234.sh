#$ -S /bin/bash
#$ -N bwa_cdc
#$ -V
#$ -o /workdir/users/agk85/CDC/mapping/log/bwa_$JOB_ID.out #Location for stdout
#$ -e /workdir/users/agk85/CDC/mapping/log/bwa_$JOB_ID.err #Location for stderr
#$ -wd /workdir/users/agk85/CDC/mapping
#$ -l h_vmem=40G
#$ -t 78-227
#$ -tc 10
#$ -q long.q@cbsubrito2

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
REF=$WRK/mapping/genomes/references/${ISOLATE}

export PATH=/programs/samtools-1.3.2/bin:$PATH
# Align
cd $OUT

echo `date` ${NAME} begin mapping
# This is running BWA MEM with 4 threads and -a (all). refer to the BWA manual for options
bwa mem -a -t 4  $REF $READ1 $READ2 > ${NAME}_${ISOLATE}.sam
samtools view -bh ${NAME}_${ISOLATE}.sam  > ${NAME}_${ISOLATE}.temp.bam
samtools flagstat ${NAME}_${ISOLATE}.temp.bam > $FLAGSTATS/${NAME}_${ISOLATE}_prefilter_flagstats.txt
rm ${NAME}_${ISOLATE}.temp.bam

echo `date` ${NAME} finished mapping

#This script will filter sam file at 90% and then it will convert to bam file

echo `date` $NAME begin filter
# Align
cd $OUT
SAM=${NAME}_${ISOLATE}.sam
#This filters sam file with some stringent rules
perl /workdir/scripts/analysing_alignments/filterSamByIdentity.pl $SAM 90 0 0 1 1 > ${NAME}_${ISOLATE}.filtered.sam

#This converts sam file to a bam file
samtools view -b ${NAME}_${ISOLATE}.filtered.sam > ${NAME}_${ISOLATE}.filtered.bam

#This gives us flagstat values for filtered 
samtools flagstat ${NAME}_${ISOLATE}.filtered.bam > flagstats/${NAME}_${ISOLATE}_filter_flagstats.txt

echo `date` $NAME finished filter

echo `date` $NAME begin sorting
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
rm ${NAME}_${ISOLATE}.filtered.bam
echo `date` $NAME finished sorting
