#$ -S /bin/bash
#$ -N vogs
#$ -e /workdir/users/agk85/CDC/phage/log/phage-hmmsearch_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/phage/log/phage-hmmsearch_$JOB_ID.out
#$ -t 1-34
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=16G
#$ -q long.q@cbsubrito2

# Goal is to identify ARG from idba generated scaffolds

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_rerun.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/phage/metagenomes/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/phage/log/vogs_${NAME}_$JOB_ID.out

SCF=$WRK/prodigal/metagenomes/${NAME}/${NAME}_proteins.faa

echo start hmmer ${NAME} `date` >> $LOG 2>&1

#run hmmscan using resfams
/programs/hmmer-3.1b2-linux-intel-x86_64/binaries/hmmsearch --cpu 4 --tblout $OUT/${NAME}.vogs.tbl.txt $WRK/phage/pogs/VOG.hmm $SCF >> $LOG 2>&1

cat $OUT/${NAME}.vogs.tbl.txt  | grep -v '^#' | awk '{print $1,$2,$3,$5,$6,$7}' | sed 's/ /\t/g' > $OUT/${NAME}_vogs.txt
sort -k3,3 -k5,5gr -k4,4g $OUT/${NAME}_vogs.txt | sort -u -k3,3 --merge > $OUT/${NAME}_vogs.txt.best

echo end hmmer ${NAME} `date` >> $LOG 2>&1
