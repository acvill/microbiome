#$ -S /bin/bash
#$ -N resfam
#$ -e /workdir/users/agk85/CDC/resfams/log/resfams_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/resfams/log/resfams_$JOB_ID.out
#$ -t 1-4
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 8
#$ -l h_vmem=16G
#$ -q short.q@cbsubrito2

# Goal is to identify ARG from idba generated scaffolds
# modified to rerun stragglers MetaDesign2.txt
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign2.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/resfams/metagenomes/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/resfams/log/resfams_${NAME}_$JOB_ID.out

SCF=$WRK/prodigal/metagenomes/${NAME}/scaffold.pep

echo start hmmer ${NAME} `date` >> $LOG 2>&1

#run hmmscan using resfams
/programs/hmmer-3.1b2-linux-intel-x86_64/binaries/hmmscan --cut_ga --domtblout $OUT/${NAME}.dom.txt --tblout $OUT/${NAME}.tbl.txt /workdir/refdbs/Resfams/Resfams-core-v1.2-20150127.hmm $SCF >> $LOG 2>&1


sed 's/ \{1,\}/,/g' $OUT/${NAME}.tbl.txt > $OUT/${NAME}_modified.tbl.txt
echo end hmmer ${NAME} `date` >> $LOG 2>&1

