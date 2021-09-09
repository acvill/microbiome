#$ -S /bin/bash
#$ -N master_scf_table
#$ -V
#$ -t 1-60
#$ -e /workdir/users/agk85/CDC/isolate_hgt/log/master_scf_table_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/isolate_hgt/log/master_scf_table_$JOB_ID.errt
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=2G
#$ -pe parenv 1
#$ -q long.q@cbsubrito2


WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_noHic.txt #changed from rerun
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

PATIENT=$(echo $NAME | cut -d'-' -f1) 

echo combo_table ${NAME} `date`
python  ~/agk/CDC/scripts/gaemr_gettaxa_percent.py -i /workdir/users/agk85/CDC/gaemr/metagenomes5/ -n $NAME
