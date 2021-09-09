#$ -S /bin/bash
#$ -N annotate_kegg
#$ -e /workdir/users/agk85/CDC/annotation/log/diamond_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/annotation/log/diamond_$JOB_ID.out
#$ -t 1-34
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 8
#$ -l h_vmem=16G
#$ -q short.q@cbsubrito2

# Goal is to annotate peptide sequences
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_rerun.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/annotation/metagenomes/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/annotation/log/kegg_${NAME}_$JOB_ID.out

PROT=$WRK/prodigal/metagenomes/${NAME}/${NAME}_proteins.faa
OUTFILE=$OUT/${NAME}_kegg.txt
echo start diamond ${NAME} `date` >> $LOG 2>&1

#run hmmscan using resfams
/programs/diamond-0.8.34/diamond blastp -d /workdir/refdbs/KEGG/kegg.prokaryotes.pep.dmnd  -p 8 -q $PROT --out $OUTFILE -k 1 --outfmt 6

echo end diamond ${NAME} `date` >> $LOG 2>&1

