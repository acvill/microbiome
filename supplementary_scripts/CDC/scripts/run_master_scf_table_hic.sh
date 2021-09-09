#make scf tables
#$ -S /bin/bash
#$ -N master_scf_table
#$ -V
#$ -t 1-32
#$ -e /workdir/users/agk85/CDC/combo_tables/log/master_scf_table_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/combo_tables/log/master_scf_table_$JOB_ID.errt
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=2G
#$ -pe parenv 1
#$ -q short.q@cbsubrito2


WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/HicDesign.txt #changed from rerun
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

PATIENT=$(echo $NAME | cut -d'-' -f1) 

echo combo_table ${NAME} `date`
python  ~/agk/CDC/scripts/gaemr_gettaxa.py -n $NAME
python ~/agk/CDC/scripts/master_scf_table17.py $NAME $PATIENT
python ~/agk/CDC/scripts/master_scf_table_binary.py $NAME
