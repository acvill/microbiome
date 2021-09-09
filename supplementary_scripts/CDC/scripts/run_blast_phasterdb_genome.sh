#$ -S /bin/bash
#$ -N blastn
#$ -e /workdir/users/agk85/CDC/phage/log/blast_phage_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/phage/log/blast_phage_$JOB_ID.out
#$ -V
#$ -pe parenv 1
#$ -l h_vmem=2G
#$ -t 1-41
#$ -q short.q@cbsubrito2

# Run against metagenomes
# Phage database from phaster

echo start blast `date`

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/Genome_all_Design.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/phage/genomes/${NAME}
DB=$WRK/phage/phaster_db

#made this with commandline input
#makeblastdb -in prophage_virus.db -dbtype 'prot' -parse_seqids -out phaster_db 
QUERY=$WRK/prodigal/genomes/${NAME}/${NAME}_proteins.faa

#run blastp using output from prodigal that has been concatenated to include all metagenomes and all phage in respective files
/programs/ncbi-blast-2.3.0+/bin/blastp -query $QUERY -db $DB -out $OUT/${NAME}_phaster.out -num_threads 1 -outfmt 6 -evalue 1e-10

echo end blast `date` 

##########################################
BLASTOUT=$OUT/${NAME}_phaster.out
INFILE=$OUT/${NAME}_phaster.best

#The reference database used in the original blast
REF=$WRK/phage/new_prophage_virus.db2

#What you want to call the new filtered file 
OUTFILE=$OUT/${NAME}_phaster_filter.out

#This finds the best hit based on bit score followed by eval followed by percent identity
sort -k1,1 -k12,12gr -k11,11g -k3,3gr $BLASTOUT | sort -u -k1,1 --merge > $INFILE

echo start filter ${NAME} `date`
#run python script first number is $identity second number is coverage of reference subject
python $WRK/scripts/blast_filter.py $REF $INFILE $OUTFILE 80 60
rm $INFILE
echo end filter ${NAME} `date`
