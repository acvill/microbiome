#$ -S /bin/bash
#$ -N fq2fa_CDC
#$ -V
#$ -t 1-19
#$ -e /workdir/users/agk85/CDC/idba/log/fq2fa_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/idba/log/fq2fa_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=2G
#$ -pe parenv 1
#$ -q short.q@cbsubrito2
unset module;
echo `date`;
#This script runs fq2fa on CDC metagenomes to interleave fastq files and returns fasta as a precursor to IDBA_UD.

WRK=/workdir/users/agk85/CDC;
DESIGN_FILE=$WRK/MetaDesign.txt;
        NAME=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE);

FQ1=/workdir/data/CDC/metagenomes/${NAME}.1.fastq;
FQ2=/workdir/data/CDC/metagenomes/${NAME}.2.fastq;

if [ ! -d $WRK/idba/fq2fa ]; then mkdir -p $WRK/idba/fq2fa; fi;

FA=$WRK/idba/fq2fa/${NAME}_fq2fa_unfiltered.fasta;

#Run fq2fa
echo start $FA;

/programs/idba-1.1.1/bin/fq2fa --merge $FQ1 $FQ2 $FA;

echo `date` done $FA;
wc -l $FA;
