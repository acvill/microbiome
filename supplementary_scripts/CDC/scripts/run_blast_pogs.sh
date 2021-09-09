#$ -S /bin/bash
#$ -N pog_blast
#$ -e /workdir/users/agk85/CDC/phage/log/blast_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/phage/log/blast_$JOB_ID.out
#$ -V
#$ -t 1-19
#$ -pe parenv 8
#$ -l h_vmem=2G
#$ -q short.q@cbsubrito2

# Goal is to identify phage from idba generated scaffolds

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=/workdir/users/agk85/CDC/MetaDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

LOG=$WRK/phage/log/pog_${NAME}_$JOB_ID.out

echo start blast `date`

IN=$WRK/prodigal/metagenomes/${NAME}/scaffold.pep

OUT=$WRK/phage/metagenomes/${NAME}
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

#run blastp using scaffold file from idba
/programs/ncbi-blast-2.3.0+/bin/blastp -query $IN -db $WRK/pogs/POGseqs -out $OUT/${NAME}_prot_pogs.out -num_threads 8 -outfmt 6 -evalue 1e-10

echo end blast `date` 


