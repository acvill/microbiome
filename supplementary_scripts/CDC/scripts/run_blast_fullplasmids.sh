#$ -S /bin/bash
#$ -N blastn
#$ -e /workdir/users/agk85/CDC/plasmids/log/blast_fullplasmid_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/plasmids/log/blast_fullplasmid_$JOB_ID.out
#$ -V
#$ -pe parenv 1
#$ -l h_vmem=2G
#$ -t 1-34
#$ -q short.q@cbsubrito2

# Identify plasmid genes from plasmid_db.fsa database from PlasmidFinder program (database the webapplication uses)
# Run against metagenomes

echo start blast `date`

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_rerun.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/plasmids/metagenomes/${NAME}
DB=/workdir/refdbs/plasmids/plasmids_db

#made this with commandline input
#makeblastdb -in /workdir/refdbs/plasmids/plasmids.fna -dbtype 'nucl' -parse_seqids -out plasmids_db
QUERY=$WRK/prodigal/metagenomes/${NAME}/${NAME}_scaffold.fasta

#run blastp using output from prodigal that has been concatenated to include all metagenomes and all phage in respective files
/programs/ncbi-blast-2.3.0+/bin/blastn -query $QUERY -db $DB -out $OUT/${NAME}_fullplasmid.out -num_threads 1 -outfmt 6 -evalue 1e-10

echo end blast `date` 


