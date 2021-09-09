#$ -S /bin/bash
#$ -N filter_vogs
#$ -e /workdir/users/agk85/CDC/phage/log/filter_vogs_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/phage/log/filter_vogs_$JOB_ID.out
#$ -V
#$ -pe parenv 1
#$ -l h_vmem=2G
#$ -t 1-34
#$ -q short.q@cbsubrito2
# Run against metagenomes
# Phage database from pVOGS
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_rerun.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

#The best file from vogs output 
OUTFILE=$WRK/phage/metagenomes/${NAME}/${NAME}_vogs.txt.best 

echo start filter ${NAME} `date`
#run python script first number is $identity second number is coverage of reference subject
python $WRK/scripts/vogs_filter.py $OUTFILE
echo end filter ${NAME} `date`
