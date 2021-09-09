#$ -S /bin/bash
#$ -N masurca
#$ -V
#$ -t 2
#$ -e /workdir/users/agk85/CDC/masurca/log/masurca_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/masurca/log/masurca_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=64G
#$ -pe parenv 16
#$ -q short.q@cbsubrito2


#This script runs masurca on CDC genomes to assemble them as a comparison to SPADES.

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/GenomeDesign.txt
        NAME=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)

FQ1=/workdir/data/CDC/genomes/${NAME}.derep_1.adapter.fastq
FQ2=/workdir/data/CDC/genomes/${NAME}.derep_2.adapter.fastq

OUT=$WRK/masurca/${NAME}
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/masurca/log/${NAME}_$JOB_ID.out

echo start masurca $NAME `date` >> $LOG 2>&1
cd $OUT

#make configuration file using SPADES information
python /workdir/users/agk85/CDC/scripts/set_masurca_config.py $FQ1 $FQ2 $NAME

#Run masurca
/programs/MaSuRCA-3.2.1/bin/masurca ${NAME}_configuration.txt

./assemble.sh

echo done masurca $NAME `date` >> $LOG 2>&1
