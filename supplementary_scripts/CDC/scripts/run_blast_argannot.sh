#$ -S /bin/bash
#$ -N argannot
#$ -e /workdir/users/agk85/CDC/resfams/log/blast_argannot_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/resfams/log/blast_argannot_$JOB_ID.out
#$ -V
#$ -pe parenv 1
#$ -l h_vmem=2G
#$ -t 1-34
#$ -q short.q@cbsubrito2

# Identify argnot snpped genes from argannot program (database the webapplication uses)
# Run against metagenomes

echo start blast `date`

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_rerun.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/resfams/metagenomes/${NAME}
DB1=$WRK/resfams/blast_db/argannot_nt_db
DB2=$WRK/resfams/blast_db/argannot_aa_db

#made this with commandline input
#makeblastdb -in /workdir/users/agk85/CDC/resfams/blast_db/argannot-nt-v3-march2017.fna -dbtype 'nucl' -parse_seqids -out argannot_nt_db
#makeblastdb -in /workdir/users/agk85/CDC/resfams/blast_db/argannot-aa-v3-march2017.faa -dbtype 'prot' -parse_seqids -out argannot_aa_db
QUERY1=$WRK/prodigal/metagenomes/${NAME}/${NAME}_proteins.fna
QUERY2=$WRK/prodigal/metagenomes/${NAME}/${NAME}_proteins.faa

#run blastp using output from prodigal that has been concatenated to include all metagenomes and all phage in respective files
/programs/ncbi-blast-2.3.0+/bin/blastn -query $QUERY1 -db $DB1 -out $OUT/${NAME}_argannot_nt.out -num_threads 1 -outfmt 6 -evalue 1e-100

/programs/ncbi-blast-2.3.0+/bin/blastp -query $QUERY2 -db $DB2 -out $OUT/${NAME}_argannot_aa.out -num_threads 1 -outfmt 6 -evalue 1e-100 


echo end blast `date` 


