#$ -S /bin/bash
#$ -N snake_anvio
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/CDC/logs/snake_anvio_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/logs/snake_anvio_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC/anvio
#$ -l h_vmem=1G
#$ -q long.q@cbsubrito2

PE=4
#--restart-times 2
snakemake -s /workdir/users/agk85/CDC/anvio/snake_anvio --jobs 8 --restart-times 1 --cluster "qsub -q long.q@cbsubrito2 -S /bin/bash -e /workdir/users/agk85/CDC/logs -o /workdir/users/agk85/CDC/logs -N {params.n} -l h_vmem={resources.mem_mb}G -pe parenv $PE"
