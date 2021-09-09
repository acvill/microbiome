#$ -S /bin/bash
#$ -N phgblst_genome
#$ -V
#$ -t 1-24
#$ -e /workdir/users/agk85/CDC/prodigal/log/phageblast_genome_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/prodigal/log/phageblast_genome_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=8G
#$ -pe parenv 8
#$ -q short.q@cbsubrito2

#This script runs blastp on scaffolds from prodigal output for phage_finder on genomes.


WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/GenomeDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/prodigal/genomes/${NAME}

IN=$OUT/scaffold.pep

LOG=$WRK/prodigal/log/blast_genome_${NAME}_$JOB_ID.out

echo start blast ${NAME} `date` >> $LOG 2>&1

/programs/ncbi-blast-2.3.0+/bin/blastp -query $IN -db /workdir/users/agk85/tools/phage_finder_v2.1/DB/phagedb -num_threads 8 -outfmt 6 -out $OUT/scaffold.out >> $LOG 2>&1

echo finished blast $NAME `date`

