#$ -S /bin/bash
#$ -N inf_idba
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/hic/press/idba/log/snakemake_$JOB_ID.err
#$ -o /workdir/users/agk85/hic/press/idba/log/snakemake_$JOB_ID.out
#$ -wd /workdir/users/agk85/hic/press/idba/
#$ -l h_vmem=1G
#$ -q long.q@cbsubrito2

snakemake -s /workdir/users/agk85/hic/press/scripts/Snake_idba --jobs 2 --restart-times 2 --cluster "qsub -q long.q@cbsubrito2 -S /bin/bash -e /workdir/users/agk85/hic/press/idba/log -o /workdir/users/agk85/hic/press/idba/log -N {params.n} -l h_vmem={resources.mem_mb}G"
