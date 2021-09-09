#$ -S /bin/bash
#$ -N snake_rna
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/CDC/rnammer/log/snake_rnammer_mgm_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/rnammer/log/snake_rnammer_mgm_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC/metaphlan/
#$ -l h_vmem=1G
#$ -q long.q@cbsubrito2

#--restart_times 2
snakemake -s /workdir/users/agk85/CDC/scripts/Snake_rnammer --jobs 8 --cluster "qsub -q long.q@cbsubrito2 -S /bin/bash -e /workdir/users/agk85/CDC/rnammer/log -o /workdir/users/agk85/CDC/rnammer/log -N {params.n} -l h_vmem={resources.mem_mb}G"
