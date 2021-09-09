#$ -S /bin/bash
#$ -N phylosift
#$ -e /workdir/users/agk85/CDC/phylosift/log/phylosift_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/phylosift/log/phylosift_$JOB_ID.out
#$ -t 1
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 1
#$ -l h_vmem=16G
#$ -q long.q@cbsubrito2

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_test.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

        
SCF=$WRK/prodigal_excise/metagenomes2/${NAME}/${NAME}_scaffold.fasta
OUT=$WRK/phylosift/metagenomes2/${NAME}
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/phylosift/log/phylosift_${NAME}_$JOB_ID.out

echo `date` start phylosift >> $LOG 2>&1

cd $OUT
cp ${SCF} $OUT
/workdir/users/agk85/tools/phylosift/phylosift_v1.0.1/bin/phylosift all $SCF >> $LOG 2>&1
# rm ${OUT}/${NAME}_scaffold.fasta

echo `date` done phylosift >> $LOG 2>&1

