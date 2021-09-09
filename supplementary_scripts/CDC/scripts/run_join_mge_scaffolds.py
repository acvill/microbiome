#make scf tables

for SGE_TASK_ID in {1..94} #changed from 34
do
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_all.txt #changed from rerun
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

PATIENT=$(echo $NAME | cut -d'-' -f1) 

echo combo_table ${NAME} `date`
python join_mge_scaffolds.py /workdir/users/agk85/CDC/prodigal_excise/metagenomes2/${NAME}/${NAME}_scaffold.fasta /workdir/users/agk85/CDC/combo_tables/metagenomes2/${NAME}_master_scf_table_binary.txt /workdir/users/agk85/CDC/prodigal_excise/metagenomes2/${NAME}/${NAME}_scaffold_mges.fasta
done
