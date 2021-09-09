#$ -S /bin/bash
#$ -N gsmer_mgblst
#$ -e /workdir/users/agk85/CDC/gsmer/log/blast_gsmer_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/gsmer/log/blast_gsmer_$JOB_ID.out
#$ -V
#$ -pe parenv 4
#$ -l h_vmem=10G
#$ -t 1-34
#$ -q long.q@cbsubrito2

#Identify taxonomically useful gsm's in the metagenomic assemblies
# Run against metagenomes

echo start blast `date`

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/HicDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/gsmer/metagenomes2/${NAME}
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

DB=/workdir/refdbs/GSMer/gsm_species
REF=/workdir/refdbs/GSMer/gsm_species.fasta

#made this with commandline input
#makeblastdb -in /workdir/refdbs/GSMer/gsm_species.fasta -dbtype 'nucl' -hash_index -out gsm_species
QUERY=$WRK/prodigal_excise/metagenomes2/${NAME}/${NAME}_scaffold.fasta
BLASTOUT=$OUT/${NAME}_gsmer.out
#BLASTBEST=$OUT/${NAME}_gsmer.out.best
BLASTFILTER=$OUT/${NAME}_gsmer.out.filter
BLASTTAXONOMY=$OUT/${NAME}_gsmer.out.filter.taxonomy

#run blastp against aclame database with evalue 1e-10
#megablast -i $QUERY -d $DB -o $BLASTOUT -a 4 -m 8 
echo end blast `date` 

#This finds the best hit based on bit score followed by eval followed by percent identity
#sort -k1,1 -k12,12gr -k11,11g -k3,3gr $BLASTOUT | sort -u -k1,1 --merge > $BLASTBEST

#python $WRK/scripts/blast_filter_pid.py $BLASTOUT $BLASTFILTER 100

python $WRK/scripts/link_gsm_taxonomy.py $BLASTFILTER $BLASTTAXONOMY

echo end filter ${NAME} `date`

