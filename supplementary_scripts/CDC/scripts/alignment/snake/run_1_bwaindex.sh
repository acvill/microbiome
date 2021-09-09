#$ -S /bin/bash
#$ -N protindex
#$ -e /workdir/users/agk85/CDC/prodigal/log/protindex_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/prodigal/log/protindex_$JOB_ID.out
#$ -t 4-6
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=25G
#$ -q short.q@cbsubrito2

#make bwa indexes for mapping to

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/PatientDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/mapping/metagenomes/references
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/prodigal/log/protindex_$JOB_ID_${NAME}.out

PROTS=$WRK/prodigal/metagenomes/combined_prots/${NAME}_nr.fna

echo start index ${NAME} `date` >> $LOG 2>&1

cd $OUT
/programs/bwa-0.7.8/bwa index -a bwtsw -p ${NAME}_nr $PROTS

echo end index ${NAME} `date` >> $LOG 2>&1

