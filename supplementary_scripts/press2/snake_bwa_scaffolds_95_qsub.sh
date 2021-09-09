#$ -S /bin/bash
#$ -N snk_bwa_scf_95
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/press2/logs/snake_bwa_scf_95_$JOB_ID.err
#$ -o /workdir/users/agk85/press2/logs/snake_bwa_scf_95_$JOB_ID.out
#$ -wd /workdir/users/agk85/press2/scripts
#$ -l h_vmem=1G
#$ -q long.q@cbsubrito2


#--restart-times 2
snakemake -s /workdir/users/agk85/press2/scripts/snake_bwa_scaffolds_95 --rerun-incomplete --jobs 1 --restart-times 2 --cluster "qsub -q long.q@cbsubrito2 -S /bin/bash -e /workdir/users/agk85/press2/logs -o /workdir/users/agk85/press2/logs -wd /workdir/users/agk85/press2/mapping -N {params.n} -pe parenv {params.j} -l h_vmem={resources.mem_mb}G"
