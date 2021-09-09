#$ -S /bin/bash
#$ -N snake_checkm
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/press2/logs/snake_network_$JOB_ID.err
#$ -o /workdir/users/agk85/press2/logs/snake_network_$JOB_ID.out
#$ -wd /workdir/users/agk85/press2/scripts
#$ -l h_vmem=1G
#$ -q long.q@cbsubrito2

FOLDER=press2
SCRIPT=/workdir/users/agk85/${FOLDER}/scripts/snake_network 
JOBS=1
RESTARTS=1
ERR=/workdir/users/agk85/${FOLDER}/logs

#--restart-times 2
snakemake -s $SCRIPT --restart-times $RESTARTS --jobs $JOBS --cluster "qsub -q long.q@cbsubrito2 -S /bin/bash -e $ERR -o $ERR -N {params.n} -l h_vmem={resources.mem_mb}G"
