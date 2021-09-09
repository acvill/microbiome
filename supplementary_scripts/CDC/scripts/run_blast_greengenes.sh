#$ -S /bin/bash
#$ -N blst_gg
#$ -e /workdir/users/agk85/CDC/rnammer/log/blast_greengenes_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/rnammer/log/blast_greengenes_$JOB_ID.out
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

OUT=$WRK/rnammer/metagenomes/
DB1=$WRK/rnammer/gg_db

#made this with commandline input
#makeblastdb -in current_GREENGENES_gg16S_unaligned.fasta -dbtype 'nucl' -parse_seqids -out gg_db
QUERY1=$WRK/rnammer/metagenomes/${NAME}_16S.fasta

#run blastp using output from prodigal that has been concatenated to include all metagenomes and all phage in respective files
/programs/ncbi-blast-2.3.0+/bin/blastn -query $QUERY1 -db $DB1 -out $OUT/${NAME}_16S.out -num_threads 1 -outfmt 6

echo end blast `date` 

################FILTER BLAST

OUT=$WRK/rnammer/metagenomes/${NAME}
BLASTOUT=$OUT/${NAME}_16S.out
INFILE=$OUT/${NAME}_16S.out.best

#The reference database used in the original blast
REF=$WRK/rnammer/current_GREENGENES_gg16S_unaligned.fasta

#This finds the best hit based on bit score followed by eval followed by percent identity
sort -k1,1 -k12,12gr -k11,11g -k3,3gr $BLASTOUT | sort -u -k1,1 --merge > $INFILE

echo end filter ${NAME} `date`
