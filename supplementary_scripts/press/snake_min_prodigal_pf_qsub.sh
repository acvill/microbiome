#$ -S /bin/bash
#$ -N trim_pro_phage_is
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/press/prodigal/log/snakemake_min_prodigal_$JOB_ID.err
#$ -o /workdir/users/agk85/press/prodigal/log/snakemake_min_prodigal_$JOB_ID.out
#$ -wd /workdir/users/agk85/press/prodigal/
#$ -l h_vmem=1G
#$ -q long.q@cbsubrito2

#--restart-times 2
snakemake -s /workdir/users/agk85/press/scripts/Snake_min_prodigal_pf --jobs 1 --restart-times 3 --cluster "qsub -q long.q@cbsubrito2 -S /bin/bash -e /workdir/users/agk85/press/prodigal/log -o /workdir/users/agk85/press/prodigal/log -N {params.n} -l h_vmem={resources.mem_mb}G"
