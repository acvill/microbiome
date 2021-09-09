#$ -S /bin/bash
#$ -N gsmer_taxonomy
#$ -V
#$ -t 1-32
#$ -e /workdir/users/agk85/CDC/gsmer/log/gsmer_taxonomy_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/gsmer/log/gsmer_taxonomy_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=30G
#$ -pe parenv 1
#$ -q long.q@cbsubrito2

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/HicDesign.txt #changed from rerun
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`
echo $NAME
python ${WRK}/scripts/link_gsm_taxonomy.py ${WRK}/gsmer/metagenomes3/${NAME}/${NAME}_gsmer.out.filter ${WRK}/gsmer/metagenomes3/${NAME}/${NAME}_gsmer.out.filter.taxonomy

