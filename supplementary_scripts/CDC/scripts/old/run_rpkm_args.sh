#$ -S /bin/bash
#$ -N arg_rpkm
#$ -e /workdir/users/agk85/CDC/resfams/log/arg_rpkm_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/resfams/log/arg_rpkm_$JOB_ID.out
#$ -t 2-19
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=1G
#$ -q short.q@cbsubrito2

# Goal is to return rpkm values for fastq files mapped to args

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/resfams/metagenomes/${NAME}

#run rpkm on aligned reads bam file and idxstats
python ~/agk/CDC/scripts/rpkm_calculate_v2.py -b ${OUT}/${NAME}_nr.aln.sam.bam.sorted -s ${OUT}/${NAME}_nr.aln.sam.bam.sorted.idxstats -o ${OUT}/${NAME}_args_nr_rpkm.txt

