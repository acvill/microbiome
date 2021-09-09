LOG=/workdir/users/agk85/CDC/card/log/get_args_manual.out
# Goal is to get prots from protlist file created by get_card_scfs.sh  
for SGE_TASK_ID in {1..18}
do
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/resfams/metagenomes/${NAME}

REF=$WRK/prodigal/metagenomes/${NAME}/scaffold.seq
SCFLIST=$OUT/${NAME}_resfam_argids.txt
OUTFILE=$OUT/${NAME}_resfam_args.fna
SCRIPT=$WRK/scripts/general_getseqs.py

echo start get_resfam_args ${NAME} `date` >> $LOG 2>&1
echo $SCRIPT
echo $REF
echo $SCFLIST
echo $OUTFILE

#run python script
python $SCRIPT $REF $SCFLIST $OUTFILE 1 $NAME >> $LOG 2>&1

echo end get_resfam_args ${NAME} `date` >> $LOG 2>&1
done
