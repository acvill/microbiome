#$ -S /bin/bash
#$ -N blastn
#$ -e /workdir/users/agk85/CDC/blast_comparisons/log/blast_scfs_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/blast_comparisons/log/blast_scfs_$JOB_ID.out
#$ -V
#$ -pe parenv 8
#$ -l h_vmem=2G
#$ -t 1-6
#$ -q long.q@cbsubrito2

# Identify plasmid genes from plasmid_positiv.fsa database from PlasmidFinder program (database the webapplication uses)
# Run against metagenomes

echo start blast `date`

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/PatientDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/blast_comparisons/metagenomes/
DB=$WRK/blast_comparisons/metagenome_db/${NAME}_db

#made this with commandline input
makeblastdb -in $WRK/blast_comparisons/metagenome_db/${NAME}_combined_scfs_500.fna -dbtype 'nucl' -parse_seqids -out $WRK/blast_comparisons/metagenome_db/${NAME}_db
QUERY=$WRK/blast_comparisons/metagenome_db/${NAME}_combined_scfs_500.fna

#run blastn using output from prodigal gene nucleotide sequences
/programs/ncbi-blast-2.3.0+/bin/blastn -query $QUERY -db $DB -out $OUT/${NAME}_scfs.out -num_threads 8 -outfmt 6 -evalue 1e-10 -max_target_seqs 300000

echo end blast `date` 


