#$ -S /bin/bash
#$ -N add_supp
#$ -e /workdir/users/agk85/CDC/newhic/log/add_supp_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/newhic/log/add_supp_$JOB_ID.out
#$ -t 1-17
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 1
#$ -l h_vmem=40G
#$ -q short.q@cbsubrito2

# Goal is to get scfs from scflist file created by get_card_scfs.sh  

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/HicDesign_good.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/newhic/mapping/${NAME}

SCRIPT=$WRK/scripts/add_in_supplementary.py

echo start get_card_args ${NAME} `date`
echo $SCRIPT

#run python script
python $SCRIPT $NAME

echo end get_card_args ${NAME} `date`

