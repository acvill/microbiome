#$ -S /bin/bash
#$ -N tigrfam_g
#$ -e /workdir/users/agk85/CDC/annotation/log/tigrfamg_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/annotation/log/tigrfamg_$JOB_ID.out
#$ -t 1-20
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 8
#$ -l h_vmem=16G
#$ -q short.q@cbsubrito2

# Goal is to identify ARG annotation from prodigal generated ORFS
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/Genome_r4_Design.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/annotation/genomes/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/annotation/log/tigrfamg_${NAME}_$JOB_ID.out

SCF=$WRK/prodigal/genomes/${NAME}/${NAME}_proteins.faa

echo start hmmer ${NAME} `date` >> $LOG 2>&1

#run hmmscan using resfams
/programs/hmmer-3.1b2-linux-intel-x86_64/binaries/hmmsearch --cut_ga --cpu 4 --tblout $OUT/${NAME}.tigr.tbl.txt /workdir/refdbs/TIGRfams/TIGR.hmm $SCF >> $LOG 2>&1

cat $OUT/${NAME}.tigr.tbl.txt  | grep -v '^#' | awk '{print $1,$2,$3,$5,$6,$7}' | sed 's/ /\t/g' > $OUT/${NAME}_tigrfam.txt
echo end hmmer ${NAME} `date` >> $LOG 2>&1

