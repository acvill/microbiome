#$ -S /bin/bash
#$ -N metaphlan
#$ -V
#$ -e /workdir/users/agk85/CDC/metaphlan/genomes/err/
#$ -o /workdir/users/agk85/CDC/metaphlan/genomes/out/
#$ -t 1-64
#$ -wd /workdir/users/agk85/CDC/metaphlan
#$ -l h_vmem=20G
#$ -q long.q@cbsubrito2
#$ -pe parenv 4

## This script will run MetaPhlAn-2.0 to identify the organismal composition of 
##the CDC metagenomic data

## Set directories
WRK=/workdir/users/agk85/CDC
DATA=/workdir/data/CDC/genomes/round12
OUT=$WRK/metaphlan/genomes/round12
REF=/workdir/users/fnn3/references
###set to HicDesign.txt to just do those ones quickly

## Create design file of file names
LIST=$WRK/GenomeDesign_r12.txt
NAME=$(sed -n "${SGE_TASK_ID}p" $LIST)

FASTQ1=$DATA/${NAME}.1.fastq
FASTQ2=$DATA/${NAME}.1.solo.fastq
FASTQ3=$DATA/${NAME}.2.fastq
FASTQ4=$DATA/${NAME}.2.solo.fastq

## Run metaphlan
export PATH=/programs/MetaPhlAn-2.0:/programs/MetaPhlAn-2.0/utils:$PATH
metaphlan2.py --input_type fastq --bowtie2db $REF/db_v20/mpa_v20_m200 --bowtie2out $OUT/${NAME}.bowtie2.bz2 --nproc 4 $FASTQ1,$FASTQ2,$FASTQ3,$FASTQ4 $OUT/${NAME}_profile.txt

