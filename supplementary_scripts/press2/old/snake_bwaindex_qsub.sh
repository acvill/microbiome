#$ -S /bin/bash
#$ -N snake_index
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/CDC/newhic/log/snakemake_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/newhic/log/snakemake_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC/newhic/refs/
#$ -l h_vmem=1G
#$ -q long.q@cbsubrito2

#--restart_times 2
snakemake -s /workdir/users/agk85/CDC/newhic/Snake_bwaindex --jobs 8 --cluster "qsub -q long.q@cbsubrito2 -S /bin/bash -e /workdir/users/agk85/CDC/newhic/log -o /workdir/users/agk85/CDC/newhic/log -N {params.n} -l h_vmem={resources.mem_mb}G"
