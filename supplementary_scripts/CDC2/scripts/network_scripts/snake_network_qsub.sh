#$ -S /bin/bash
#$ -N snake_network
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/CDC2/logs/snake_network_hist_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC2/logs/snake_network_hist_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC2/scripts/network_scripts
#$ -l h_vmem=1G
#$ -q long.q@cbsubrito2

FOLDER=CDC2
SCRIPT=/workdir/users/agk85/${FOLDER}/scripts/network_scripts/snake_network_hist
ERR=/workdir/users/agk85/${FOLDER}/logs
JOBS=20
RESTARTS=1
snakemake -s $SCRIPT --restart-times $RESTARTS --jobs $JOBS --cluster "qsub -q long.q@cbsubrito2 -S /bin/bash -pe parenv 1 -e $ERR -o $ERR -N {params.n} -l h_vmem={resources.mem_mb}G"
