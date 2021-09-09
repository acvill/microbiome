#$ -S /bin/bash
#$ -N vogs
#$ -e /workdir/users/agk85/CDC/phage/log/phage-hmmscan_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/phage/log/phage-hmmscan_$JOB_ID.out
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

OUT=$WRK/phage/metagenomes/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/phage/log/vogs_${NAME}_$JOB_ID.out

SCF=$WRK/prodigal/metagenomes/${NAME}/scaffold.pep

echo start hmmer ${NAME} `date` >> $LOG 2>&1

#run hmmscan using resfams
/programs/hmmer-3.1b2-linux-intel-x86_64/binaries/hmmscan --tblout $OUT/${NAME}.tbl.txt $WRK/pogs/VOG.hmm $SCF >> $LOG 2>&1

sed 's/ \{1,\}/,/g' ${NAME}.tbl.txt > $OUT/${NAME}_modified.tbl.txt
echo end hmmer ${NAME} `date` >> $LOG 2>&1
