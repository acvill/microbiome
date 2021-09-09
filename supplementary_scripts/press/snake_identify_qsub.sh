#$ -S /bin/bash
#$ -N snake_id
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/press/logs/snake_identify_noise_$JOB_ID.err
#$ -o /workdir/users/agk85/press/logs/snake_identify_noise_$JOB_ID.out
#$ -wd /workdir/users/agk85/press/prodigal
#$ -l h_vmem=1G
#$ -q long.q@cbsubrito2


#--restart-times 2
snakemake -s /workdir/users/agk85/press/scripts/snake_identify --jobs 10 --restart-times 1 --cluster "qsub -q long.q@cbsubrito2 -S /bin/bash -e /workdir/users/agk85/press/logs -o /workdir/users/agk85/press/logs -N {params.n} -l h_vmem={resources.mem_mb}G"
