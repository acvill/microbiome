#$ -S /bin/bash
#$ -N addname
#$ -e /workdir/users/agk85/CDC/spades/log/addname_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/spades/log/addname_$JOB_ID.out
#$ -t 1-64
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 1
#$ -l h_vmem=2G
#$ -q short.q@cbsubrito2

# Goal is to get prots from protlist file created by get_card_scfs.sh  

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/GenomeDesign_r12.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/spades/round12/${NAME}
INFILE=$OUT/scaffolds.fasta
OUTFILE=$OUT/${NAME}_scaffolds.fasta
SCRIPT=$WRK/scripts/addname_fasta.py

echo start addname ${NAME} `date`
echo $SCRIPT $INFILE $NAME $OUTFILE
#run python script
python $SCRIPT $INFILE $NAME $OUTFILE
echo end addname ${NAME} `date`
