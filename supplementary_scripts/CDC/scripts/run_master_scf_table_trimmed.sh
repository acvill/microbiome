#make scf tables

for SGE_TASK_ID in {1..17}
do
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/HicDesign_good.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

PATIENT=$(echo $NAME | cut -d'-' -f1) 

echo combo_table ${NAME} `date`
python ~/agk/CDC/scripts/master_scf_table_trimmed.py $NAME $PATIENT

done
