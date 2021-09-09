#$ -S /bin/bash
#$ -N snake_excise
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/CDC/prodigal_excise/log/snake_excise_mgm_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/prodigal_excise/log/snake_excise_mgm_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC/prodigal_excise/
#$ -l h_vmem=1G
#$ -q long.q@cbsubrito2

#this script launches snakemake for metaphlan

SNAKEFILE=/workdir/users/agk85/CDC/scripts/snake_excise
RESTARTS=2
JOBS=10
LOG=/workdir/users/agk85/CDC/prodigal_excise/log
PE=1

snakemake -s $SNAKEFILE --restart-times $RESTARTS --jobs $JOBS --cluster "qsub -q long.q@cbsubrito2 -S /bin/bash -e $LOG -o $LOG -N {params.n} -l h_vmem={resources.mem_mb}G -pe parenv $PE"
