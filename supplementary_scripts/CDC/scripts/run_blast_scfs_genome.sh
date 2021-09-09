#$ -S /bin/bash
#$ -N blast_g
#$ -e /workdir/users/agk85/CDC/blast_comparisons/log/blast_genomescfs_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/blast_comparisons/log/blast_genomescfs_$JOB_ID.out
#$ -V
#$ -pe parenv 2
#$ -l h_vmem=10G
#$ -t 7-24
#$ -q long.q@cbsubrito2

# Identify genome scfs that map to metagenome scfs
echo start blast `date`

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/GenomeDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

PATIENT=$(echo $NAME | cut -d'-' -f1)
OUT=$WRK/blast_comparisons/genomes
DB=$WRK/blast_comparisons/mgm_db/${PATIENT}_db

#made this with commandline input
QUERY=$WRK/prodigal/genomes/${NAME}/${NAME}_scaffold.fasta

#run blastn using output scaffolds
/programs/ncbi-blast-2.3.0+/bin/blastn -query $QUERY -db $DB -out $OUT/${NAME}_scf.out -num_threads 2 -outfmt 6 -evalue 1e-10 -max_target_seqs 1000000000

echo end blast `date`
