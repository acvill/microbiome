#$ -S /bin/bash
#$ -N metagenome_stats
#$ -V
#$ -t 1-92
#$ -e /workdir/data/CDC/metagenomes/merged/stats.err
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=5G
#$ -pe parenv 8
#$ -q short.q@cbsubrito2



#Run QUAST to get assembly statistics

WRK=/workdir/users/agk85


LIST=$WRK/MetaDesign_all.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $LIST)
        NAME=`basename "$DESIGN"`

ASSEMBLY=$WRK/idba_rerun/metagenomes/${NAME}/${NAME}_scaffolds.fasta
OUT=$WRK/idba_rerun/metagenomes/${NAME}/${NAME}_assembly_stats
        if [ ! -d $OUT ]; then mkdir -p $OUT; fi

python /programs/quast-4.0/quast.py -o $OUT $ASSEMBLY
