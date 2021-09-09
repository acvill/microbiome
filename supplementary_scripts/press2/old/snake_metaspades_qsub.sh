#$ -S /bin/bash
#$ -N snake_metaspades
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/CDC2/logs/snake_metaspades_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC2/logs/snake_metaspades_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC2/scripts
#$ -l h_vmem=1G
#$ -q long.q@cbsubrito2

snakemake -s /workdir/users/agk85/CDC2/scripts/snake_metaspades --jobs 1 --restart-times 2 --cluster "qsub -q long.q@cbsubrito2 -pe parenv 16 -S /bin/bash -e /workdir/users/agk85/CDC2/logs -o /workdir/users/agk85/CDC2/logs -N {params.n} -l h_vmem={resources.mem_mb}G"