#$ -S /bin/bash
#$ -N blst_aclame
#$ -e /workdir/users/agk85/CDC/aclame/log/blast_aclame_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/aclame/log/blast_aclame_$JOB_ID.out
#$ -V
#$ -pe parenv 1
#$ -l h_vmem=2G
#$ -t 1-34
#$ -q long.q@cbsubrito2

#Identify mobile element genes from ACLAME database of proteins
# Run against metagenomes

echo start blast `date`

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_rerun.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/aclame/metagenomes/${NAME}
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

DB=/workdir/refdbs/ACLAME/aclame_db

#made this with commandline input
#makeblastdb -in /workdir/refdbs/ACLAME/aclame_proteins_all_0.4.fasta -dbtype 'prot' -parse_seqids -out aclame_db
QUERY=$WRK/prodigal/metagenomes/${NAME}/${NAME}_proteins.faa

#run blastp against aclame database with evalue 1e-10
/programs/ncbi-blast-2.3.0+/bin/blastp -query $QUERY -db $DB -out $OUT/${NAME}_aclame.out -num_threads 1 -outfmt 6 -evalue 1e-10

echo end blast `date` 

BLASTOUT=$OUT/${NAME}_aclame.out
INFILE=$OUT/${NAME}_aclame.out.best

#The reference database used in the original blast
REF=/workdir/refdbs/ACLAME/aclame_proteins_all_0.4.fasta

#What you want to call the new filtered file 
OUTFILE=$OUT/${NAME}_aclame_filter.out

#This finds the best hit based on bit score followed by eval followed by percent identity
sort -k1,1 -k12,12gr -k11,11g -k3,3gr $BLASTOUT | sort -u -k1,1 --merge > $INFILE

echo start filter ${NAME} `date`
#run python script first number is $identity second number is coverage of reference subject
python $WRK/scripts/blast_filter.py $REF $INFILE $OUTFILE 80 60
echo end filter ${NAME} `date`
