#$ -S /bin/bash
#$ -N snake_bwahic
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/press/logs/snakebwahic_$JOB_ID.err
#$ -o /workdir/users/agk85/press/logs/snakebwahic_$JOB_ID.out
#$ -wd /workdir/users/agk85/press/hic/
#$ -l h_vmem=1G
#$ -q long.q@cbsubrito2

#--restart-times 2
snakemake -s /workdir/users/agk85/press/scripts/Snake_bwahic_9899100 --restart-times 3 --jobs 20 --cluster "qsub -q long.q@cbsubrito2 -S /bin/bash -e /workdir/users/agk85/press/logs -o /workdir/users/agk85/press/logs -N {params.n} -l h_vmem={resources.mem_mb}G"