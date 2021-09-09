#$ -S /bin/bash
#$ -N fq2fa_genome
#$ -V
#$ -t 1-24
#$ -e /workdir/users/agk85/CDC/idba/log/fq2fa_genome_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/idba/log/fq2fa_genome_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=2G
#$ -pe parenv 1
#$ -q short.q@cbsubrito2


#This script runs fq2fa on CDC metagenomes to interleave fastq files and returns fasta as a precursor to IDBA_UD.

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/GenomeDesign.txt
        NAME=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)

FQ1=/workdir/data/CDC/genomes/${NAME}.derep/${NAME}.derep_1.adapter.fastq
FQ2=/workdir/data/CDC/genomes/${NAME}.derep/${NAME}.derep_2.adapter.fastq

OUT=$WRK/idba/fq2fa_genome
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/idba/log/${NAME}_$JOB_ID.out

FA=$OUT/${NAME}_fq2fa.fasta

echo start fq2fa $NAME `date` >> $LOG 2>&1

#Run fq2fa
/programs/idba-1.1.1/bin/fq2fa --merge --filter $FQ1 $FQ2 $FA >> $LOG 2>&1

echo done $NAME `date` >> $LOG 2>&1
wc -l $FA >> $LOG 2>&1
