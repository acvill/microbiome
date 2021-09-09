#$ -S /bin/bash
#$ -N idba_CDC
#$ -V
#$ -t 1
#$ -tc 1
#$ -e /workdir/users/agk85/CDC/idba/redo/redo_idba_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/idba/redo/redo_idba_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=400G
#$ -pe parenv 8
#$ -q long.q@cbsubrito2

echo 400GB RAM

#This script runs IDBA_UD to assemble genomes from interleaved fasta file

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign2.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/idba/redo/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

echo `date` $NAME
FA=$WRK/idba/fq2fa/${NAME}_fq2fa.fasta

LOG=$WRK/idba/redo/${NAME}/${NAME}.out

#Run IDBA-UD, -l flag is for reads over 128bp
/programs/idba-1.1.1/bin/idba_ud -r $FA --pre_correction --num_threads 8  -o $OUT/ >> $LOG 2>&1

echo `date` finished IDBA $NAME
wc -l $WRK/idba/redo/${NAME}/scaffold.fa

