#$ -S /bin/bash
#$ -N pfam_mgm
#$ -e /workdir/users/agk85/CDC/annotation/log/pfam_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/annotation/log/pfam_$JOB_ID.out
#$ -t 1-16
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 1
#$ -l h_vmem=16G
#$ -q long.q@cbsubrito2

# Goal is to identify ARG annotation from prodigal generated ORFS
# modified to rerun stragglers MetaDesign2.txt
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_rerun.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/annotation/metagenomes/search/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/annotation/log/pfam_${NAME}_$JOB_ID.out

SCF=$WRK/prodigal/metagenomes/${NAME}/${NAME}_proteins.faa

echo start hmmer ${NAME} `date` >> $LOG 2>&1

#run hmmscan using resfams
/programs/hmmer-3.1b2-linux-intel-x86_64/binaries/hmmsearch --cut_ga --tblout $OUT/${NAME}.tbl.txt --cpu 20 /workdir/refdbs/Pfams/Pfam-A.hmm $SCF >> $LOG 2>&1

cat $OUT/${NAME}.tbl.txt  | grep -v '^#' | awk '{print $1,$2,$3,$5,$6,$7}' | sed 's/ /\t/g' > $OUT/${NAME}_modified.tbl.txt
echo end hmmer ${NAME} `date` >> $LOG 2>&1

