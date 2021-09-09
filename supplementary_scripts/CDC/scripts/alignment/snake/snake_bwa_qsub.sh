#$ -S /bin/bash
#$ -N snk_bwa
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/CDC/logs3/snake_bwa_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/logs3/snake_bwa_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC/mapping/metagenomes3
#$ -l h_vmem=1G
#$ -q long.q@cbsubrito2


#--restart-times 2
snakemake -s /workdir/users/agk85/CDC/scripts/alignment/snake/snake_bwa3 --rerun-incomplete --jobs 10 --restart-times 2 --cluster "qsub -q long.q@cbsubrito2 -S /bin/bash -e /workdir/users/agk85/CDC/logs3 -o /workdir/users/agk85/CDC/logs3 -wd /workdir/users/agk85/CDC/mapping/metagenomes3 -N {params.n} -pe parenv {params.j} -l h_vmem={resources.mem_mb}G"
