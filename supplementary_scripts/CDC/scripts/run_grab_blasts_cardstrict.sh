#$ -S /bin/bash
#$ -N card_strict
#$ -e /workdir/users/agk85/CDC/card/log/get_cardstrict_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/card/log/get_cardstrict_$JOB_ID.out
#$ -t 2-6
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 1
#$ -l h_vmem=10G
#$ -q short.q@cbsubrito2

# Goal is to get scfs from scflist file created by get_card_scfs.sh  

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/PatientDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/card/metagenomes/${NAME}

SCRIPT=$WRK/scripts/grab_blasts_cardstrict.py 
CLUSTFILE=$WRK/card/metagenomes/patients/${NAME}_card_strict_args_nr.fna.clstr
echo start get_card_strict_clusters ${NAME} `date`sts_cardstrict.py
echo $SCRIPT

#run python script
python $SCRIPT $NAME $CLUSTFILE

echo end get_card_strict_clusters ${NAME} `date`

