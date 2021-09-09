#$ -S /bin/bash
#$ -N card_drug
#$ -e /workdir/users/agk85/CDC/card/log/get_args_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/card/log/get_args_$JOB_ID.out
#$ -t 1-18
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 1
#$ -l h_vmem=10G
#$ -q short.q@cbsubrito2

# Goal is to get scfs from scflist file created by get_card_scfs.sh  

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/card/metagenomes/${NAME}

REF=$WRK/prodigal/metagenomes/${NAME}/scaffold.seq
SCFLIST=$OUT/${NAME}_card_strict_argids.txt
OUTFILE=$OUT/${NAME}_card_strict_args.fna
SCRIPT=$WRK/scripts/general_getseqs.py

echo start get_card_args ${NAME} `date`
echo $SCRIPT
echo $REF
echo $SCFLIST
echo $OUTFILE

#run python script
python $SCRIPT $REF $SCFLIST $OUTFILE 1 $NAME

echo end get_card_args ${NAME} `date`

