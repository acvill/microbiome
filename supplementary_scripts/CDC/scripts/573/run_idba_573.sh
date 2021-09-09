#$ -S /bin/bash
#$ -N idba_573_CDC
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/CDC/idba_rerun/log/idba_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/idba_rerun/log/idba_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=1500G
#$ -pe parenv 12
#$ -q long.q@cbsubrito2


#This script runs IDBA_UD to assemble genomes from interleaved fasta file
#increase memory in cases where first run fails

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/573Design.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/idba_rerun/metagenomes/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

echo `date` start IDBA $FA >> $LOG 2>&1

FA=$WRK/idba_rerun/fq2fa/${NAME}_fq2fa.fasta
LOG=$WRK/idba_rerun/log/idba_${NAME}_$JOB_ID.out
#Run IDBA-UD, -l flag is for reads over 512bp
/programs/idba-1.1.1/bin/idba_ud -r $FA --pre_correction --num_threads 12 -o $OUT/ >> $LOG 2>&1

echo `date` finished IDBA $FA >> $LOG 2>&1
wc -l $FA >> $LOG 2>&1
