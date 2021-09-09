#$ -S /bin/bash
#$ -N snake_bwahic
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/CDC/newhic/log/snakemake_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/newhic/log/snakemake_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC/newhic/
#$ -l h_vmem=1G
#$ -q long.q@cbsubrito2

#--restart-times 2
snakemake -s /workdir/users/agk85/CDC/newhic/Snakefile_bwahic --restart-times 3 --jobs 20 --cluster "qsub -q long.q@cbsubrito2 -S /bin/bash -e /workdir/users/agk85/CDC/newhic/log -o /workdir/users/agk85/CDC/newhic/log -N {params.n} -l h_vmem={resources.mem_mb}G"
