#$ -S /bin/bash
#$ -N expand
#$ -e /workdir/users/agk85/CDC/card/log/add_drug_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/card/log/add_drug_$JOB_ID.out
#$ -t 1-19
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 1
#$ -l h_vmem=1G
#$ -q short.q@cbsubrito2

# Goal is to expand prodigal called genes 150bp on either side

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/card/metagenomes/${NAME}/

REF=$OUT/${NAME}_card.txt
OUTFILE=$OUT/${NAME}_card_drugs.txt

echo start add_drugs ${NAME} `date`

#run python script
python /workdir/users/agk85/CDC/scripts/add_antibiotics.py $REF $OUTFILE

echo end add_drugs ${NAME} `date`

