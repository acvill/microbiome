#$ -S /bin/bash
#$ -N relaxase
#$ -e /workdir/users/agk85/CDC/plasmids/log/relaxase_genome_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/plasmids/log/relaxase_genome_$JOB_ID.out
#$ -t 1-24
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 8
#$ -l h_vmem=16G
#$ -q short.q@cbsubrito2

# Goal is to identify ARG from idba generated scaffolds

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/GenomeDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/plasmids/genomes/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/plasmids/log/relaxase_genome_${NAME}_$JOB_ID.out

SCF=$WRK/prodigal/genomes/${NAME}/scaffold.pep

echo start hmmer ${NAME} `date` >> $LOG 2>&1

#run hmmscan using resfams
/programs/hmmer-3.1b2-linux-intel-x86_64/binaries/hmmsearch --cut_ga --tblout $OUT/${NAME}.tbl.txt /workdir/users/agk85/CDC/plasmids/relaxase.hmm $SCF >> $LOG 2>&1


sed 's/ \{1,\}/,/g' $OUT/${NAME}.tbl.txt > $OUT/${NAME}_modified.tbl.txt
echo end hmmer ${NAME} `date` >> $LOG 2>&1

