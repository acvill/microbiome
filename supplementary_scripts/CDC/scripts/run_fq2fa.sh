#$ -S /bin/bash
#$ -N fq2fa_CDC
#$ -V
#$ -t 1-18
#$ -e /workdir/users/agk85/CDC/idba_rerun/fq2fa_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/idba_rerun/fq2fa_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=2G
#$ -pe parenv 1
#$ -q long.q@cbsubrito2


#This script runs fq2fa on CDC metagenomes to interleave fastq files and returns fasta as a precursor to IDBA_UD.
#changed this to run subset of full metagenomes

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign.txt
        NAME=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)

FQ1=/workdir/data/CDC/metagenomes2/${NAME}.1.fastq
FQ2=/workdir/data/CDC/metagenomes2/${NAME}.2.fastq

if [ ! -d $WRK/idba/fq2fa ]; then mkdir -p $WRK/idba/fq2fa; fi

FA=$WRK/idba_rerun/fq2fa/${NAME}_fq2fa.fasta

#Run fq2fa
echo start $FA

/programs/idba-1.1.1/bin/fq2fa --merge --filter $FQ1 $FQ2 $FA

echo done $FA
wc -l $FA
