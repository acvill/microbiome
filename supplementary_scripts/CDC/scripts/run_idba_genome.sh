#$ -S /bin/bash
#$ -N idba_genome
#$ -V
#$ -t 22-24
#$ -tc 1
#$ -e /workdir/users/agk85/CDC/idba/log/genome_idba_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/idba/log/genome_idba_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=250G
#$ -pe parenv 8
#$ -q long.q@cbsubrito2

echo 250gb memory

#This script runs IDBA_UD to assemble genomes from interleaved fasta file
#redo changing t to -t 22-24 to rerun last samples
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/GenomeDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/idba/genome/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/idba/log/genome_${NAME}_$JOB_ID.out
echo `date` $NAME >> $LOG 2>&1
FA=$WRK/idba/fq2fa_genome/${NAME}_fq2fa.fasta

#Run IDBA-UD, -l flag is for reads over 128bp
/programs/idba-1.1.1/bin/idba_ud -r $FA --pre_correction --num_threads 8  -o $OUT >> $LOG 2>&1

echo `date` finished IDBA $NAME
wc -l $OUT/scaffold.fa

