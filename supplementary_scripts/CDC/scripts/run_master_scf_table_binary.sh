#make scf tables

for SGE_TASK_ID in {1..94}
do
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_all.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

PATIENT=$(echo $NAME | cut -d'-' -f1) 

echo combo_table ${NAME} `date`
python ~/agk/CDC/scripts/master_scf_table_binary.py $NAME

done
