#$ -S /bin/bash
#$ -N snake_press
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/hic/press/err/snakemake_$JOB_ID.err
#$ -o /workdir/users/agk85/hic/press/log/snakemake_$JOB_ID.out
#$ -wd /workdir/users/agk85/hic/press/
#$ -l h_vmem=1G
#$ -q long.q@cbsubrito2

snakemake -s /workdir/users/agk85/hic/press/Snake_qc --jobs 8 --restart-times 5 --cluster "qsub -q long.q@cbsubrito2 -S /bin/bash -e /workdir/users/agk85/hic/press/err -o /workdir/users/agk85/hic/press/log -N qc_press -l h_vmem={resources.mem_mb}G"
