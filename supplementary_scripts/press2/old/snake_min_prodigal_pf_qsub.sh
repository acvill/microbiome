#$ -S /bin/bash
#$ -N trim_pro_phage_is
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/press2/logs/snake_min_prodigal_$JOB_ID.err
#$ -o /workdir/users/agk85/press2/logs/snake_min_prodigal_$JOB_ID.out
#$ -wd /workdir/users/agk85/press2/logs/
#$ -l h_vmem=1G
#$ -q long.q@cbsubrito2

FOLDER=press2
JOBS=20
RESTARTS=1
ERR=/workdir/users/agk85/${FOLDER}/logs

#--restart-times 2
snakemake -s /workdir/users/agk85/${FOLDER}/scripts/snake_min_prodigal_pf --jobs $JOBS --restart-times $RESTARTS --cluster "qsub -q long.q@cbsubrito2 -S /bin/bash -e $ERR -o $ERR -N {params.n} -l h_vmem={resources.mem_mb}G"
