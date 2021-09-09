#$ -S /bin/bash
#$ -N blastn
#$ -V
#$ -o /workdir/users/agk85/simulated/logs/gene_blast_$JOB_ID.out
#$ -e /workdir/users/agk85/simulated/logs/gene_blast_$JOB_ID.err
#$ -wd /workdir/users/acv46/ARGs_Hi-C
#$ -q long.q@cbsubrito2
#$ -t 1

WRK=/workdir/users/agk85/simulated
DB=/workdir/blastdb/nt
OUT=$WRK/args
EVAL=1e-100 #Largest E value to keep for alignments
ALIGN=100 #Number of alignments to keep per query -- defunct in this script
OUTFMT=6 #Output format type. 0 = pairwise, 6 = tabular, 10 = csv

/programs/ncbi-blast-2.3.0+/bin/blastn -query $WRK/args.fna -db $DB -out $OUT/ARGs_$EVAL.oout -outfmt $OUTFMT -evalue $EVAL

echo -e "qseqid\tsseqid\tpident\tlength\tmismatch\tgapopen\tqstart\tqend\tsstart\tsend\tevalue\tbitscore" | cat - ARGs_Hi-C_BLASTn_all_$EVAL.txt > ARGs_Hi-C_BLASTn_all_header_$EVAL.txt
