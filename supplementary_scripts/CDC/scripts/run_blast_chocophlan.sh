#$ -S /bin/bash
#$ -N choco
#$ -e /workdir/users/agk85/CDC/chocophlan/log/blast_choco_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/chocophlan/log/blast_choco_$JOB_ID.out
#$ -V
#$ -pe parenv 8
#$ -l h_vmem=20G
#$ -t 46
#$ -q long.q@cbsubrito2

# Identify plasmid genes from plasmid_db.fsa database from PlasmidFinder program (database the webapplication uses)
# Run against metagenomes

echo start blast `date`

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_all.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/chocophlan/metagenomes2/${NAME}
DB=/workdir/refdbs/chocophlan/chocophlan
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi
#made this with commandline input
QUERY=$WRK/prodigal_excise/metagenomes2/${NAME}/${NAME}_scaffold.fasta

#run blastp using output from prodigal that has been concatenated to include all metagenomes and all phage in respective files
/programs/ncbi-blast-2.3.0+/bin/blastn -query $QUERY -db $DB -out $OUT/${NAME}_chocophlan.out -num_threads 8 -outfmt 6 -max_target_seqs 500

echo end blast `date` 


