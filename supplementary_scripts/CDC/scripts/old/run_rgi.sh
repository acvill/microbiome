#$ -S /bin/bash
#$ -N card
#$ -e /workdir/users/agk85/CDC/card/log/rgi_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/card/log/rgi_$JOB_ID.out
#$ -t 1-19
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 8
#$ -l h_vmem=16G
#$ -q short.q@cbsubrito2

# Goal is to identify ARG from idba generated scaffolds
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/card/metagenomes/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/card/log/rgi_${NAME}_$JOB_ID.out
SCF=$WRK/prodigal/metagenomes/${NAME}/scaffold.pep
OUTPUT=${OUT}/

echo start rgi ${NAME} `date` >> $LOG 2>&1

#run rgi on prodigal amino acid sequences
python /workdir/users/agk85/CDC/card/rgi/rgi.py -t protein -i $SCF -o $OUTPUT -n 8 -a DIAMOND  >> $LOG 2>&1

echo end rgi ${NAME} `date` >> $LOG 2>&1

