#$ -S /bin/bash
#$ -N plasmid_fullg
#$ -e /workdir/users/agk85/CDC/plasmids/log/blast_fullplasmidg_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/plasmids/log/blast_fullplasmidg_$JOB_ID.out
#$ -V
#$ -pe parenv 1
#$ -l h_vmem=2G
#$ -t 1-41
#$ -q short.q@cbsubrito2

# Identify plasmid genes from plasmid_db.fsa database from PlasmidFinder program (database the webapplication uses)
# Run against metagenomes

echo start blast `date`

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/GenomeDesign_all.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/plasmids/genomes/${NAME}
DB=/workdir/refdbs/plasmids/plasmids_db

#made this with commandline input
#makeblastdb -in /workdir/refdbs/plasmids/plasmids.fna -dbtype 'nucl' -parse_seqids -out plasmids_db
QUERY=$WRK/prodigal/genomes/${NAME}/${NAME}_scaffold.fasta

#run blastp using output from prodigal that has been concatenated to include all metagenomes and all phage in respective files
#/programs/ncbi-blast-2.3.0+/bin/blastn -query $QUERY -db $DB -out $OUT/${NAME}_fullplasmid.out -num_threads 1 -outfmt 6 -evalue 1e-10

echo end blast `date`

######################FILTER BLAST

OUT=$WRK/plasmids/genomes/${NAME}
BLASTOUT=$OUT/${NAME}_fullplasmid.out
INFILE=$OUT/${NAME}_fullplasmid.out.best

#The reference database used in the original blast
REF=/workdir/refdbs/plasmids/plasmids.fna

#What you want to call the new filtered file 
OUTFILE=$OUT/${NAME}_fullplasmid_filter.out

#This finds the best hit based on bit score followed by eval followed by percent identity
sort -k1,1 -k12,12gr -k11,11g -k3,3gr $BLASTOUT | sort -u -k1,1 --merge > $INFILE

echo start filter ${NAME} `date`
#run python script first number is $identity second number is coverage of reference subject
python $WRK/scripts/blast_filter_size.py $QUERY $INFILE $OUTFILE 95 80 1000
rm $INFILE
echo end filter ${NAME} `date` 
