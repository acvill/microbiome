#$ -S /bin/bash
#$ -N card_drug
#$ -e /workdir/users/agk85/CDC/card/log/add_drug_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/card/log/add_drug_$JOB_ID.out
#$ -t 1-18
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

OUT=$WRK/card/metagenomes/${NAME}

REF=$OUT/${NAME}_card.txt
OUTFILE=$OUT/${NAME}_drug_specific_card_hits.txt
EVAL=1e-150
LOOSENESS=Loose
SCRIPT=$WRK/scripts/filter_card_output.py


echo start filter_drugs ${NAME} `date`
echo $SCRIPT
echo $REF
echo $OUTFILE
echo $EVAL
echo $LOOSENESS

#run python script
python $SCRIPT $REF $OUTFILE $EVAL $LOOSENESS

echo end filter_drugs ${NAME} `date`

