#$ -S /bin/bash
#$ -N protindex
#$ -e /workdir/users/agk85/CDC/mapping/log/genome_index_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/mapping/log/genome_index_$JOB_ID.out
#$ -t 25-66
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=25G
#$ -q short.q@cbsubrito2

#make bwa indexes for mapping to

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/References.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/mapping/genomes/references
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/mapping/log/genomeindex_$JOB_ID_${NAME}.out

GENOME=$WRK/mapping/genomes/references/${NAME}_1000_scaffolds.fasta

echo start index ${NAME} `date` >> $LOG 2>&1

cd $OUT
/programs/bwa-0.7.8/bwa index -a bwtsw -p ${NAME} $GENOME

echo end index ${NAME} `date` >> $LOG 2>&1

