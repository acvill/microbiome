
# Goal is to identify ARG from idba generated scaffolds
for SGE_TASK_ID in {2..34};
do
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_rerun.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/card/metagenomes/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/card/log/rgi_${NAME}_manual.out
PROT=$WRK/prodigal/metagenomes/${NAME}/${NAME}_proteins.faa
OUTPUT=${OUT}/${NAME}

echo start rgi ${NAME} `date` >> $LOG 2>&1
echo start rgi ${NAME} 
#run rgi on prodigal amino acid sequences
python /workdir/users/agk85/CDC/card/rgi/rgi.py -t protein -i $PROT -o $OUTPUT >> $LOG 2>&1

echo end rgi ${NAME} `date` >> $LOG 2>&1
done
