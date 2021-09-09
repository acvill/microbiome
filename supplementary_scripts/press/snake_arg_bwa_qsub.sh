#$ -S /bin/bash
#$ -N snk_bwa_arg
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/press/logs/snake_bwa_arg_$JOB_ID.err
#$ -o /workdir/users/agk85/press/logs/snake_bwa_arg_$JOB_ID.out
#$ -wd /workdir/users/agk85/press/scripts
#$ -l h_vmem=1G
#$ -q long.q@cbsubrito2

FOLDER=press
WRK="/workdir/users/agk85/${FOLDER}"
JOBS=10
RESTARTS=1
ERR="/workdir/users/agk85/${FOLDER}/logs/"
OUT=$ERR
snakemake -s ${WRK}/scripts/snake_arg_index --jobs $JOBS --restart-times $RESTARTS --cluster "qsub -q long.q@cbsubrito2 -S /bin/bash -e $ERR -o $OUT -wd ${WRK}/arg_v_org/metagenomes/ -N {params.n} -l h_vem={resources.mem_mb}G"

snakemake -s ${WRK}/scripts/snake_arg_bwa --jobs $JOBS --restart-times $RESTARTS --cluster "qsub -q long.q@cbsubrito2 -S /bin/bash -e $ERR -o $OUT -wd ${WRK}/arg_v_org/metagenomes/ -N {params.n} -l h_vmem={resources.mem_mb}G"
