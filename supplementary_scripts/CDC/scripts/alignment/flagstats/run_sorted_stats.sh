#$ -S /bin/bash
#$ -N filter_stats
#$ -V
#$ -o /workdir/users/agk85/CDC/mapping/log/stats3_$JOB_ID.out
#$ -e /workdir/users/agk85/CDC/mapping/log/stats3_$JOB_ID.err
#$ -t 1-34
#$ -wd /workdir/users/agk85/CDC
#$ -q short.q@cbsubrito2

#This script will calculate basic alignment stats using samtools

#Set directories
WRK=/workdir/users/agk85/CDC #Your directory
OUT=$WRK/mapping/metagenomes/bwa_alignments
	 if [! -e $OUT]; then mkdir -p $OUT; fi

#Create design file of file names
LIST=$WRK/MetaDesign_rerun.txt
	DESIGN=$(sed -n "${SGE_TASK_ID}p" $LIST)
	NAME=`basename "$DESIGN"`

cd $OUT
#The location of your BAM files
BAM=${NAME}.sorted.bam

#Provide path to samtools
export PATH=/programs/samtools-1.3.2/bin:$PATH

samtools flagstat $BAM > ${NAME}_sorted_flagstats.txt
