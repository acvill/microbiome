#$ -S /bin/bash
#$ -N merge_meta
#$ -V
#$ -t 56
#$ -e /workdir/data/CDC/metagenomes/merged/err
#$ -o /workdir/data/CDC/metagenomes/merged/log
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=50G
#$ -q long.q@cbsubrito2


#This script merges gzipped files

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_all.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

cat /home/britolab/data/CDC/trimmedReads/round*/metagenome/lane*/${NAME}.1.fastq.gz > /workdir/data/CDC/metagenomes/merged/${NAME}.1.fastq.gz

cat /home/britolab/data/CDC/trimmedReads/round*/metagenome/lane*/${NAME}.2.fastq.gz > /workdir/data/CDC/metagenomes/merged/${NAME}.2.fastq.gz
