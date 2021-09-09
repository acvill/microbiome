#$ -S /bin/bash
#$ -N resfam
#$ -e /workdir/users/agk85/CDC/resfams/log/resfams_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/resfams/log/resfams_$JOB_ID.out
#$ -t 1-17
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 8
#$ -l h_vmem=30G
#$ -q long.q@cbsubrito2

# Goal is to identify ARG from idba generated scaffolds
# modified to rerun stragglers MetaDesign2.txt
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/HicDesign_good.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/resfams/metagenomes2/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/resfams/log/resfams_${NAME}_$JOB_ID.out

SCF=$WRK/prodigal/metagenomes2/${NAME}/${NAME}_proteins.faa

echo start hmmer ${NAME} `date` >> $LOG 2>&1

#run hmmscan using resfams
#/programs/hmmer-3.1b2-linux-intel-x86_64/binaries/hmmsearch --cut_ga --tblout $OUT/${NAME}.resfams.tbl.txt /workdir/refdbs/Resfams/Resfams-core-v1.2-20150127.hmm $SCF >> $LOG 2>&1


cat $OUT/${NAME}.refams.tbl.txt  | grep -v '^#' | awk '{print $1,$2,$3,$5,$6,$7}' | sed 's/ /\t/g' > $OUT/${NAME}_resfams.txt
echo end hmmer ${NAME} `date` >> $LOG 2>&1

