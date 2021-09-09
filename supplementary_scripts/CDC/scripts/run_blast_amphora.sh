#$ -S /bin/bash
#$ -N blst_nr
#$ -e /workdir/users/agk85/CDC/amphora/log/blast_nr_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/amphora/log/blast_nr_$JOB_ID.out
#$ -V
#$ -pe parenv 8
#$ -l h_vmem=10G
#$ -t 1-17
#$ -q long.q@cbsubrito2

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/HicDesign_good.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

echo start blast `date`
OUT=$WRK/amphora/metagenomes2/${NAME}
DB=/workdir/blastdb/nr

#run blastp using output from prodigal that has been concatenated to include all metagenomes and all phage in respective files
for QUERY in ${OUT}/*.pep
do
/programs/ncbi-blast-2.3.0+/bin/blastp -db $DB -num_threads 8 -query $QUERY -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore staxids sscinames scomnames sskingdoms salltitles'"  -max_target_seqs 100 -out ${QUERY}.out
done
echo end blast `date` 

