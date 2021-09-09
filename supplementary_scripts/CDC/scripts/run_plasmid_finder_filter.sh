#$ -S /bin/bash
#$ -N pf_filter
#$ -e /workdir/users/agk85/CDC/plasmids/log/plasmidfinder_filter_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/plasmids/log/plasmidfinder_filter_$JOB_ID.out
#$ -t 1-34
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=10G
#$ -q short.q@cbsubrito2

# Goal is to filter plasmidfinder output 80% identity and 60% coverage and convert to gff3 file

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_rerun.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/plasmids/metagenomes/${NAME}

SCRIPT=$WRK/scripts/plasmid_finder_filter.py 
INFILE=$OUT/${NAME}_plasmidgenes.out.best
GFF=$OUT/${NAME}_plasmidgenes.gff
PROT=$WRK/prodigal/metagenomes/${NAME}/${NAME}_proteins.faa
RELAXASE=$OUT/${NAME}_relaxase.txt

echo start filter plasmid finder ${NAME} `date`
echo $SCRIPT

#run python script
python $SCRIPT $INFILE $GFF $PROT $RELAXASE

echo end filter_plasmidfinder ${NAME} `date`

