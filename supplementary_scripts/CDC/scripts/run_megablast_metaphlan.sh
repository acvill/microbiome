#$ -S /bin/bash
#$ -N mtphln_mgblst
#$ -e /workdir/users/agk85/CDC/mtphln/log/blast_metaphlan_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/mtphln/log/blast_metaphlan_$JOB_ID.out
#$ -V
#$ -pe parenv 4
#$ -l h_vmem=10G
#$ -t 1-34
#$ -q long.q@cbsubrito2

#Identify mobile element genes from ACLAME database of proteins
# Run against metagenomes

echo start blast `date`

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/HicDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/mtphln/metagenomes2/${NAME}
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

DB=/workdir/refdbs/metaphlan/metaphlan_db
REF=/workdir/refdbs/metaphlan/metaphlan_refs.fasta

#made this with commandline input
#makeblastdb -in /workdir/refdbs/ACLAME/aclame_proteins_all_0.4.fasta -dbtype 'prot' -parse_seqids -out aclame_db
QUERY=$WRK/prodigal_excise/metagenomes2/${NAME}/${NAME}_proteins.fna
BLASTOUT=$OUT/${NAME}_metaphlan.out
BLASTBEST=$OUT/${NAME}_metaphlan.out.best
BLASTFILTER=$OUT/${NAME}_metaphlan.out.best.filter

#run blastp against aclame database with evalue 1e-10
#megablast -i $QUERY -d $DB -o $BLASTOUT -a 4 -m 8 
echo end blast `date` 

#This finds the best hit based on bit score followed by eval followed by percent identity
#sort -k1,1 -k12,12gr -k11,11g -k3,3gr $BLASTOUT | sort -u -k1,1 --merge > $BLASTBEST

python $WRK/scripts/blast_filter_size_noref.py #QUERY $BLASTBEST $BLASTFILTER 95 80 0
echo end filter ${NAME} `date`
