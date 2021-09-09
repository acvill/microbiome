#$ -S /bin/bash
#$ -N sam2bam_cdc
#$ -V
#$ -o /workdir/users/agk85/CDC/mapping/log/sam2bam_$JOB_ID.out #Location for stdout
#$ -e /workdir/users/agk85/CDC/mapping/log/sam2bam_$JOB_ID.err #Location for stderr
#$ -wd /workdir/users/agk85/CDC/mapping
#$ -l h_vmem=50G
#$ -t 5-8
#$ -q long.q@cbsubrito2

#This script will filter sam file at 90% and then it will convert to bam file

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

READ1=/workdir/data/CDC/metagenomes/merged/unzip/${NAME}.1.fastq
READ2=/workdir/data/CDC/metagenomes/merged/unzip/${NAME}.2.fastq

#BWA mem takes the prefix of the header files
#If you have never run this before with a specific reference, you need to index the reference first. Refer to "run_create_bwa_index.qsub"
# /programs/bwa-0.7.8/bwa index -a bwtsw -p B320-1s B320-1s_scaffolds.fasta
REF=$WRK/mapping/genomes/references/${ISOLATE}

#Path to samtools
export PATH=/programs/samtools-1.3.2/bin:$PATH

echo `date` $NAME
# Align
cd $OUT
SAM=${NAME}_${ISOLATE}.sam
#This filters sam file with some stringent rules
perl /workdir/scripts/filterSamByIdentity.pl $SAM 90 0 0 1 1 > ${NAME}_${ISOLATE}.filtered.sam

#This converts sam file to a bam file
samtools view -b ${NAME}_${ISOLATE}.filtered.sam > ${NAME}_${ISOLATE}.filtered.bam

#This gives us flagstat values for filtered 
samtools flagstat ${NAME}_${ISOLATE}.filtered.bam > flagstats/${NAME}_${ISOLATE}_filter_flagstats.txt

echo `date` $NAME finished
