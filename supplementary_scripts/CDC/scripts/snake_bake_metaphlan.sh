#$ -S /bin/bash
#$ -N snake_mtphln
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/CDC/metaphlan/log/snake_metaphlan_mgm_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/metaphlan/log/snake_metaphlan_mgm_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC/metaphlan/
#$ -l h_vmem=1G
#$ -q long.q@cbsubrito2

snakemake -s /workdir/users/agk85/CDC/scripts/Snake_metaphlan --restart-times 2 --jobs 8 --cluster "qsub -q long.q@cbsubrito2 -S /bin/bash -e /workdir/users/agk85/CDC/metaphlan/log -o /workdir/users/agk85/CDC/metaphlan/log -N {params.n} -l h_vmem={resources.mem_mb}G -pe parenv 4"
