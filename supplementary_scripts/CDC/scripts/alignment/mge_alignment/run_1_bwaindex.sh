#$ -S /bin/bash
#$ -N mgeindex
#$ -e /workdir/users/agk85/CDC/tables/log/mgeindex_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/tables/log/mgeindex_$JOB_ID.out
#$ -t 1
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=2G
#$ -q short.q@cbsubrito2

#make bwa indexes for mapping to

WRK=/workdir/users/agk85/CDC
#DESIGN_FILE=$WRK/tables/metagenomes/TypeDesign.txt
#        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
#        NAME=`basename "$DESIGN"`

OUT=$WRK/mapping/metagenomes/references
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/tables/log/mgeindex_$JOB_ID.out

PROTS=$WRK/tables/metagenomes/mge_99_nr.fna

echo start index `date` >> $LOG 2>&1

cd $OUT
/programs/bwa-0.7.8/bwa index -a bwtsw -p mge_nr $PROTS

echo end index `date` >> $LOG 2>&1

