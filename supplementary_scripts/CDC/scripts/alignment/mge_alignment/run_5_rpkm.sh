#$ -S /bin/bash
#$ -N rpkm_mge
#$ -e /workdir/users/agk85/CDC/mapping/log/mge_rpkm_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/mapping/log/mge_rpkm_$JOB_ID.out
#$ -t 1-34
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=50G
#$ -q short.q@cbsubrito2

# Goal is to return rpkm values for fastq files mapped to args

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_rerun.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/mapping/metagenomes/bwa_mge_alignments

#run rpkm on aligned reads bam file and idxstats
python /workdir/scripts/rpkm_calculate.py -b ${OUT}/${NAME}.sorted.bam -s ${OUT}/${NAME}.idxstats.txt -d ${OUT}/${NAME}.depth.txt -o ${OUT}/${NAME}.rpkm.txt

