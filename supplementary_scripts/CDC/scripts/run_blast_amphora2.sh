#$ -S /bin/bash
#$ -N amphora_blstt
#$ -e /workdir/users/agk85/CDC/amphora/log/blast_amphora_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/amphora/log/blast_amphora_$JOB_ID.out
#$ -V
#$ -pe parenv 4
#$ -l h_vmem=30G
#$ -t 1-34
#$ -q long.q@cbsubrito2

#Identify mobile element genes from ACLAME database of proteins
# Run against metagenomes

echo start blast `date`

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/HicDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/amphora/metagenomes2/${NAME}
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

DB=/workdir/blastdb/nr

#made this with commandline input
#makeblastdb -in /workdir/refdbs/ACLAME/aclame_proteins_all_0.4.fasta -dbtype 'prot' -parse_seqids -out aclame_db
QUERY=$OUT/${NAME}_amphora.pep

cat $OUT/*.pep > $QUERY
BLASTOUT=$OUT/${NAME}_amphora_blast.out
BLASTBEST=$OUT/${NAME}_amphora_blast.out.best
BLASTFILTER=$OUT/${NAME}_amphora_blast.out.best.filter

echo start blast `date`
#run blastp against aclame database with evalue 1e-10
/programs/ncbi-blast-2.3.0+/bin/blastp -query $QUERY -db $DB -out $BLASTOUT -num_threads 4 -outfmt 6
echo end blast `date`

#This finds the best hit based on bit score followed by eval followed by percent identity
sort -k1,1 -k12,12gr -k11,11g -k3,3gr $BLASTOUT | sort -u -k1,1 --merge > $BLASTBEST

python $WRK/scripts/blast_filter_pid.py $BLASTBEST $BLASTFILTER 95
echo end filter ${NAME} `date`
