#$ -S /bin/bash
#$ -N virsort
#$ -V
#$ -t 1-34
#$ -e /workdir/users/agk85/CDC/phage/log/virsorter_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/phage/log/virsorter_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=5G
#$ -q long.q@cbsubrito2

#This script runs phagefinder on blastp file and sequencefile from prodigal and blastp output.

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_rerun.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/phage/metagenomes/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

#make log
LOG=$WRK/phage/log/virer_${NAME}_$JOB_ID.out
echo start vir_finder ${NAME} `date` >> $LOG 2>&1

SCF=$WRK/prodigal/metagenomes/${NAME}/${NAME}_scaffold.fasta
OUTFILE=${OUT}/${NAME}_virfinder.txt

# R CMD INSTALL /workdir/users/agk85/tools/VirFinder_1.1.tar.gz 

Rscript --vanilla /workdir/users/agk85/CDC/scripts/virFinder.r $SCF $OUTFILE

#I don't know if the image id ever gets changed

docker1 run -d -it 71b92ff487fe /bin/bash

docker1 run --rm -v /workdir/agk85/virsorter-data:/data -v /workdir/agk85/virsorter-run:/wdir discoenv/virsorter:v1.0.3 --db 2 --fna /wdir/B309-1_scaffold.fasta &


echo finished vir_finder $NAME `date` >> $LOG 2>&1


