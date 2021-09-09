#$ -S /bin/bash
#$ -N snake_idba
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/CDC/idba_rerun/log/snakemake_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/idba_rerun/log/snakemake_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC/idba_rerun/
#$ -l h_vmem=1G
#$ -q long.q@cbsubrito2

#--restart_times 2
snakemake -s /workdir/users/agk85/CDC/idba_rerun/Snakefile_idba --jobs 1 --cluster "qsub -q long.q@cbsubrito2 -S /bin/bash -e /workdir/users/agk85/CDC/idba_rerun/log -o /workdir/users/agk85/CDC/idba_rerun/log -N {params.n} -l h_vmem={resources.mem_mb}G -pe parenv 8"
