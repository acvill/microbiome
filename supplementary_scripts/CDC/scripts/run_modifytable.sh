#$ -S /bin/bash
#$ -N clean_table
#$ -e /workdir/users/agk85/CDC/resfams/log/clean_table_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/resfams/log/clean_table_$JOB_ID.out
#$ -t 1-34
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=1G
#$ -q short.q@cbsubrito2

#Create clean modified table file
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_rerun.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/resfams/metagenomes/${NAME}
cat $OUT/${NAME}.tbl.txt  | grep -v '^#' | awk '{print $1,$2,$3,$5,$6,$7}' | sed 's/ /\t/g' > $OUT/${NAME}_resfams.txt

