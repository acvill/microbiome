#$ -S /bin/bash
#$ -N paste_genome
#$ -e /workdir/users/agk85/CDC/mapping/log/genome_figure_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/mapping/log/genome_figure_$JOB_ID.out
#$ -t 1-66
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=25G
#$ -q short.q@cbsubrito2

#make bwa indexes for mapping to

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/References.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`
OUT=$WRK/mapping/genomes/bwa_alignments
DESIGN_FILE=$WRK/Reference_tps.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        TPS=`basename "$DESIGN"`

cd $OUT
Rscript /workdir/users/agk85/CDC/mapping/analysis/general_allgenome_plots.R $NAME $TPS 
