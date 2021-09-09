#$ -S /bin/bash
#$ -N blastn
#$ -e /workdir/users/agk85/CDC/plasmids/log/blast_plasmid_genome_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/plasmids/log/blast_plasmid_genome_$JOB_ID.out
#$ -V
#$ -pe parenv 1
#$ -l h_vmem=2G
#$ -t 1-20
#$ -q short.q@cbsubrito2

# Identify plasmid genes from plasmid_db.fsa database from PlasmidFinder program (database the webapplication uses)
# Run against genomes

echo start blast `date`

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/Genome_r4_Design.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/plasmids/genomes/${NAME}
DB=$WRK/plasmids/plasmidFinder_db

#made this with commandline input
#makeblastdb -in /workdir/users/agk85/CDC/plasmids/plasmid_db.fsa -dbtype 'nucl' -parse_seqids -out plasmidFinder_db
QUERY=$WRK/prodigal/genomes/${NAME}/${NAME}_scaffold.fasta

#run blastn using output from prodigal gene nucleotide sequences
/programs/ncbi-blast-2.3.0+/bin/blastn -query $QUERY -db $DB -out $OUT/${NAME}_plasmidgenes.out -num_threads 8 -outfmt 6 -evalue 1e-10

echo end blast `date` 
##############FILTER HITS
BLASTOUT=$OUT/${NAME}_plasmidgenes.out
INFILE=$OUT/${NAME}_plasmidgenes.out.best

#The reference database used in the original blast
REF=$WRK/plasmids/plasmid_db.fsa

#What you want to call the new filtered file 
OUTFILE=$OUT/${NAME}_plasmidgenes_filter.out

#This finds the best hit based on bit score followed by eval followed by percent identity
sort -k1,1 -k12,12gr -k11,11g -k3,3gr $BLASTOUT | sort -u -k1,1 --merge > $INFILE

echo start filter ${NAME} `date`
#run python script first number is $identity second number is coverage of reference subject
python $WRK/scripts/blast_filter.py $REF $INFILE $OUTFILE 80 60
rm $INFILE
echo end filter ${NAME} `date`

