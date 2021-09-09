#$ -S /bin/bash
#$ -N relabel
#$ -e /workdir/users/agk85/CDC2/logs/relabel_bin3c_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC2/logs/relabel_bin3c_$JOB_ID.out
#$ -t 1-44
#$ -V
#$ -wd /workdir/users/agk85/simulated
#$ -pe parenv 1
#$ -l h_vmem=1G
#$ -q short.q@cbsubrito2

WRK=/workdir/users/agk85/CDC2
DESIGN_FILE=$WRK/MetaDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`


#ok and because bin3c fasta files are relabelled
python ~/agk/CDC2/scripts/bin3c_scripts/relabel_bin3c_fasta.py -f $WRK/bin3c/${NAME}/${NAME}_bin3c_clust/fasta -o $WRK/bin3c/${NAME}/${NAME}_bin3c_clust/newfasta -n ${NAME}

