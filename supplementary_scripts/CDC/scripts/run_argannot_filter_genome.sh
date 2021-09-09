#$ -S /bin/bash
#$ -N argang_filter
#$ -e /workdir/users/agk85/CDC/resfams/log/argannot_filterg_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/resfams/log/argannot_filterg_$JOB_ID.out
#$ -t 1-24
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=10G
#$ -q short.q@cbsubrito2

# Goal is to filter argannot output 100% identity and 100% coverage and convert to gff3 file

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/GenomeDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/resfams/genomes/${NAME}

SCRIPT=$WRK/scripts/argannot_filter.py 
INFILE=$OUT/${NAME}_argannot_nt.out.best
GFF=$OUT/${NAME}_argannot_nt.gff

echo start filter argannot ${NAME} `date`
echo $SCRIPT

#run python script
python $SCRIPT $INFILE $GFF

echo end filter argannot ${NAME} `date`

