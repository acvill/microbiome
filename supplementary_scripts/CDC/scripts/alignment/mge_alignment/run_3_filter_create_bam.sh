#$ -S /bin/bash
#$ -N sam2bam_mge
#$ -V
#$ -o /workdir/users/agk85/CDC/mapping/log/sam2bam_mge_$JOB_ID.out #Location for stdout
#$ -e /workdir/users/agk85/CDC/mapping/log/sam2bam_mge_$JOB_ID.err #Location for stderr
#$ -wd /workdir/users/agk85/CDC/mapping
#$ -l h_vmem=85G
#$ -t 8-34
#$ -q long.q@cbsubrito2

#This script will filter sam file at 90% and then it will convert to bam file

#Set directories
WRK=/workdir/users/agk85/CDC
OUT=$WRK/mapping/metagenomes/bwa_mge_alignments

#Create design file of file names
LIST=$WRK/MetaDesign_rerun.txt
DESIGN=$(sed -n "${SGE_TASK_ID}p" $LIST)
NAME=`basename "$DESIGN"`

#Profile path to samtools
export PATH=/programs/samtools-1.3.2/bin:$PATH

echo `date` $NAME
# Align
cd $OUT
SAM=${NAME}.sam
#This filters sam file with some stringent rules
perl /workdir/scripts/filterSamByIdentity.pl $SAM 99 0 0 1 1 > ${NAME}.filtered.sam

#This converts sam file to a bam file
samtools view -b ${NAME}.filtered.sam > ${NAME}.filtered.bam

#This gives us flagstat values for filtered 
samtools flagstat ${NAME}.filtered.bam > flagstats/${NAME}_filter_flagstats.txt

echo `date` $NAME finished
