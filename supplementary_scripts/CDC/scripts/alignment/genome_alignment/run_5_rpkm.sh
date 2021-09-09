#$ -S /bin/bash
#$ -N rpkm_mgm
#$ -e /workdir/users/agk85/CDC/mapping/log/arg_rpkm_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/mapping/log/arg_rpkm_$JOB_ID.out
#$ -t 1-227
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=50G
#$ -q short.q@cbsubrito2

# Goal is to return rpkm values for fastq files mapped to args

#Set directories
WRK=/workdir/users/agk85/CDC
OUT=$WRK/mapping/genomes/bwa_alignments

#Create design file of file names
LIST=$WRK/MetaDesign_isomap.txt
DESIGN=$(sed -n "${SGE_TASK_ID}p" $LIST)
NAME=`basename "$DESIGN"`
LIST=$WRK/GenomeDesign_isomap.txt
DESIGN=$(sed -n "${SGE_TASK_ID}p" $LIST)
ISOLATE=`basename "$DESIGN"`

a=($(wc -l /workdir/data/CDC/metagenomes/merged/unzip/${NAME}.1.fastq))
b=($(wc -l /workdir/data/CDC/metagenomes/merged/unzip/${NAME}.2.fastq))

#run rpkm on aligned reads bam file and idxstats
python /workdir/scripts/analysing_alignments/rpkm_calculate.py -s ${OUT}/${NAME}_${ISOLATE}.idxstats.txt -d ${OUT}/${NAME}_${ISOLATE}.depth.txt -o ${OUT}/${NAME}_${ISOLATE}.rpkm.txt -f1 $a -f2 $b

