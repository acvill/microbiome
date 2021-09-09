#$ -S /bin/bash
#$ -N blastn
#$ -e /workdir/users/agk85/CDC/blast_comparisons/log/blast_scfs_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/blast_comparisons/log/blast_scfs_$JOB_ID.out
#$ -V
#$ -wd /workdir/users/agk85/CDC/
#$ -pe parenv 4
#$ -l h_vmem=10G
#$ -t 1-9
#$ -q long.q@cbsubrito2

# Identify plasmid genes from plasmid_positiv.fsa database from PlasmidFinder program (database the webapplication uses)
# Run against metagenomes
# Modified to 2 to redo B316 because I deleted it...

echo start blast `date`

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/PatientDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/blast_comparisons/metagenomes
DB=$WRK/blast_comparisons/mgm_db/${NAME}_db

#made this with commandline input
#makeblastdb -in $WRK/blast_comparisons/mgm_db/${NAME}_scaffolds.fasta -dbtype 'nucl' -parse_seqids -out $WRK/blast_comparisons/mgm_db/${NAME}_db
QUERY=$WRK/blast_comparisons/mgm_db/${NAME}_scaffolds.fasta

#run blastn using output scaffolds
/programs/ncbi-blast-2.3.0+/bin/blastn -query $QUERY -db $DB -out $OUT/${NAME}_scfs.out -num_threads 4 -outfmt 6 -evalue 1e-10 -max_target_seqs 1000000000

echo end blast `date`
