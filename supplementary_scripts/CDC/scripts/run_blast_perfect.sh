#$ -S /bin/bash
#$ -N arg_perfect
#$ -e /workdir/users/agk85/CDC/resfams/log/blast_perfect_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/resfams/log/blast_perfect_$JOB_ID.out
#$ -V
#$ -pe parenv 1
#$ -l h_vmem=2G
#$ -t 1-34
#$ -q short.q@cbsubrito2

# Identify argnot snpped genes from argannot program plus 16S and 23S downloaded from CARD database
# Run against metagenomes

echo start blast `date`

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_rerun.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/resfams/metagenomes/${NAME}
DB1=$WRK/resfams/blast_db/perfect_db

#made this with commandline input
#makeblastdb -in perfect_db.fasta -dbtype 'nucl' -parse_seqids -out perfect_db
QUERY1=$WRK/prodigal/metagenomes/${NAME}/${NAME}_proteins.fna

#run blastp using output from prodigal that has been concatenated to include all metagenomes and all phage in respective files
/programs/ncbi-blast-2.3.0+/bin/blastn -query $QUERY1 -db $DB1 -out $OUT/${NAME}_perfect.out -num_threads 1 -outfmt 6

echo end blast `date` 

################FILTER BLAST

OUT=$WRK/resfams/metagenomes/${NAME}
BLASTOUT=$OUT/${NAME}_perfect.out
INFILE=$OUT/${NAME}_perfect.out.best

#The reference database used in the original blast
REF=$WRK/resfams/blast_db/perfect_db.fasta

#What you want to call the new filtered file 
OUTFILE=$OUT/${NAME}_perfect_filter.out

#This finds the best hit based on bit score followed by eval followed by percent identity
sort -k1,1 -k12,12gr -k11,11g -k3,3gr $BLASTOUT | sort -u -k1,1 --merge > $INFILE

echo start filter ${NAME} `date`
#run python script first number is $identity second number is coverage of reference subject
python $WRK/scripts/blast_filter.py $REF $INFILE $OUTFILE 100 95

echo end filter ${NAME} `date`
