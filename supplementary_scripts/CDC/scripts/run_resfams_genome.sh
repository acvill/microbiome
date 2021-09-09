#$ -S /bin/bash
#$ -N resfam_genome
#$ -e /workdir/users/agk85/CDC/resfams/log/resfams_genome_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/resfams/log/resfams_genome_$JOB_ID.out
#$ -t 1-26
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 8
#$ -l h_vmem=16G
#$ -q short.q@cbsubrito2

# Goal is to identify ARG from spades generated scaffolds
# Changed to 1-20 and Genome_r4_Design.txt from 1-24 and GenomeDesign.txt

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/GenomeDesign_r14.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/resfams/genomes/r14/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/resfams/log/resfams_${NAME}_$JOB_ID.out

PROTS=$WRK/prodigal/genomes/r14/${NAME}/${NAME}_proteins.faa

echo start hmmer ${NAME} `date` >> $LOG 2>&1

#run hmmscan using resfams
/programs/hmmer-3.1b2-linux-intel-x86_64/binaries/hmmsearch --cut_ga --tblout $OUT/${NAME}.resfams.tbl.txt /workdir/refdbs/Resfams/Resfams-core-v1.2-20150127.hmm $PROTS >> $LOG 2>&1

cat $OUT/${NAME}.resfams.tbl.txt  | grep -v '^#' | awk '{print $1,$2,$3,$5,$6,$7}' | sed 's/ /\t/g' > $OUT/${NAME}_resfams.txt
echo end hmmer ${NAME} `date` >> $LOG 2>&1

