#$ -S /bin/bash
#$ -N blastn
#$ -e /workdir/users/agk85/CDC/resfams/log/blast_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/resfams/log/blast_B320m_$JOB_ID.out
#$ -V
#$ -pe parenv 8
#$ -l h_vmem=2G
#$ -q short.q@cbsubrito2

# Goal is to compare args against args
echo start blast `date`
WRK=/workdir/users/agk85/CDC/resfams/blast

#run blastp using output from prodigal that has been concatenated to include all metagenomes and all phage in respective files
/programs/ncbi-blast-2.3.0+/bin/blastn -query $WRK/arg.fna -db $WRK/arg_fna -out $WRK/arg.out -num_threads 8 -outfmt 6 -evalue 1e-10

echo end blast `date` 


