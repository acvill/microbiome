#$ -S /bin/bash
#$ -N maxbin
#$ -e /workdir/users/agk85/CDC/maxbin/log/maxbin_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/maxbin/log/maxbin_$JOB_ID.out
#$ -t 1-88
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 8
#$ -l h_vmem=10G
#$ -q short.q@cbsubrito2

# Goal is to bin contigs into single species from idba generated scaffolds

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_all.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/maxbin/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/maxbin/log/maxbin_$JOB_ID_${NAME}.out

SCF=$WRK/prodigal_excise/metagenomes2/${NAME}/${NAME}_scaffold.fasta
R1=/workdir/data/CDC/metagenomes/merged/unzip/${NAME}.1.fastq
R2=/workdir/data/CDC/metagenomes/merged/unzip/${NAME}.2.fastq
#SCF=$WRK/maxbin/${NAME}/${NAME}_scaffold.fasta
#R1=$WRK/growth_rates/maxbin/${NAME}/${NAME}.1.fastq
#R2=$WRK/growth_rates/maxbin/${NAME}/${NAME}.2.fastq
echo start maxbin ${NAME} `date` >> $LOG 2>&1

#run maxbin
perl /programs/MaxBin-2.2.4/run_MaxBin.pl -contig $SCF -reads $R1 -reads2 $R2 -max_iteration 50 -thread 8 -out $OUT/${NAME} >> $LOG 2>&1

echo end maxbin ${NAME} `date` >> $LOG 2>&1

