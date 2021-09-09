#$ -S /bin/bash
#$ -N fastqc_meta
#$ -V
#$ -t 2-92
#$ -e /workdir/data/CDC/metagenomes/merged/fastqc_$JOB_ID.err
#$ -o /workdir/data/CDC/metagenomes/merged/fastqc_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=50G
#$ -pe parenv 8
#$ -q long.q@cbsubrito2

#runs fastqc on end of QC data that's been merged
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_all.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

/programs/FastQC-0.11.5/fastqc -t 8 -o /workdir/data/CDC/metagenomes/merged/fastqc/ --noextract -f fastq /workdir/data/CDC/metagenomes/merged/${NAME}.1.fastq.gz
/programs/FastQC-0.11.5/fastqc -t 8 -o /workdir/data/CDC/metagenomes/merged/fastqc/ --noextract -f fastq /workdir/data/CDC/metagenomes/merged/${NAME}.2.fastq.gz
