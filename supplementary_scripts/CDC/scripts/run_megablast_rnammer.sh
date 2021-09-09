#$ -S /bin/bash
#$ -N rnammer_mgblst
#$ -e /workdir/users/agk85/CDC/rnammer/log/blast_rnammer_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/rnammer/log/blast_rnammer_$JOB_ID.out
#$ -V
#$ -pe parenv 4
#$ -l h_vmem=20G
#$ -t 1-34
#$ -q long.q@cbsubrito2

#Identify taxonomically useful gsm's in the metagenomic assemblies
# Run against metagenomes

echo start blast `date`

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/HicDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/rnammer/metagenomes2
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

DB=/workdir/blastdb/nt

#made this with commandline input
#makeblastdb -in /workdir/refdbs/GSMer/gsm_species.fasta -dbtype 'nucl' -hash_index -out gsm_species


QUERY=${OUT}/${NAME}_16S.fasta
BLASTOUT=$OUT/${NAME}_rnammer_nt.out
BLASTBEST=$OUT/${NAME}_rnammer_nt.out.best
BLASTFILTER=$OUT/${NAME}_rnammer_nt.out.best.filter

#run blastp against aclame database with evalue 1e-10
#megablast -i $QUERY -d $DB -o $BLASTOUT -a 4 -m "8 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore staxids"

/programs/ncbi-blast-2.3.0+/bin/blastn -task megablast -query $QUERY -db $DB -out $BLASTOUT -num_threads 4 -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore staxids"

#This finds the best hit based on bit score followed by eval followed by percent identity
sort -k1,1 -k12,12gr -k11,11g -k3,3gr $BLASTOUT | sort -u -k1,1 --merge > $BLASTBEST

python $WRK/scripts/blast_filter_size_noref.py $QUERY $BLASTBEST $BLASTFILTER 95 80 0 
echo end filter ${NAME} `date`
