#$ -S /bin/bash
#$ -N tigrfam_mgm
#$ -e /workdir/users/agk85/CDC/annotation/log/tigrfam_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/annotation/log/tigrfam_$JOB_ID.out
#$ -t 1-34
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 1
#$ -l h_vmem=16G
#$ -q long.q@cbsubrito2

# Goal is to identify mgm annotation from prodigal generated ORFS
# redo to include 12-34 which i stoppped to do other work
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_rerun.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/annotation/metagenomes/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/annotation/log/tigrfam_${NAME}_$JOB_ID.out

SCF=$WRK/prodigal/metagenomes/${NAME}/${NAME}_proteins.faa

echo start hmmer ${NAME} `date` >> $LOG 2>&1

#run hmmscan using resfams
/programs/hmmer-3.1b2-linux-intel-x86_64/binaries/hmmsearch --cpu 4 --cut_ga --tblout $OUT/${NAME}.tigr.tbl.txt /workdir/refdbs/TIGRfams/TIGR.hmm $SCF >> $LOG 2>&1

cat $OUT/${NAME}.tigr.tbl.txt  | grep -v '^#' | awk '{print $1,$2,$3,$5,$6,$7}' | sed 's/ /\t/g' > $OUT/${NAME}_tigrfam.txt
echo end hmmer ${NAME} `date` >> $LOG 2>&1

