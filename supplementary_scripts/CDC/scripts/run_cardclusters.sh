#$ -S /bin/bash
#$ -N card_clusters
#$ -e /workdir/users/agk85/CDC/card/log/card_clusters_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/card/log/card_clusters_$JOB_ID.out
#$ -V
#$ -pe parenv 8
#$ -l h_vmem=10G
#$ -t 2-6
#$ -q short.q@cbsubrito2

# Program will grab scaffolds that map via blast to card args
echo start cardcluster `date`

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/PatientDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

SCRIPT=$WRK/scripts/get_cardclusters.py
echo $SCRIPT
echo $NAME
#run card cluster script off of scfs_of_interest files
python $SCRIPT $NAME
echo end cardcluster `date` 
