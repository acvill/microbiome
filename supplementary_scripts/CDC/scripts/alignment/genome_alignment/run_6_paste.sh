#$ -S /bin/bash
#$ -N paste_genome
#$ -e /workdir/users/agk85/CDC/mapping/log/genome_paste_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/mapping/log/genome_paste_$JOB_ID.out
#$ -t 1-66
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=25G
#$ -q short.q@cbsubrito2

#make bwa indexes for mapping to

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/References.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`
PATIENT=$(echo $NAME | cut -d'-' -f1)
OUT=$WRK/mapping/genomes/bwa_alignments
cd $OUT
paste -d',' ${PATIENT}*_${NAME}.rpkm.txt > ${NAME}.rpkm.txt
