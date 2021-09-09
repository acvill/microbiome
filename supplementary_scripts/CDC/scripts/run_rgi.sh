#$ -S /bin/bash
#$ -N card
#$ -e /workdir/users/agk85/CDC/card/log/rgi_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/card/log/rgi_$JOB_ID.out
#$ -t 1
#$ -V
#$ -wd /workdir/users/agk85/CDC/card/metagenomes
#$ -l h_vmem=16G
#$ -q long.q@cbsubrito2

# Goal is to identify ARG from idba generated scaffolds
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_rerun.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/card/metagenomes/temp/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/card/log/rgi_${NAME}_$JOB_ID.out
PROT=$WRK/prodigal/metagenomes/${NAME}/${NAME}_proteins.faa

cd $OUT
echo start rgi ${NAME} `date` >> $LOG 2>&1

#run rgi on prodigal amino acid sequences
python /workdir/users/agk85/CDC/card/rgi/rgi.py -t protein -i $PROT -o $OUT -n 8  >> $LOG 2>&1

echo end rgi ${NAME} `date` >> $LOG 2>&1

