#$ -S /bin/bash
#$ -N phgfind_g
#$ -V
#$ -t 1-20
#$ -e /workdir/users/agk85/CDC/prodigal/log/phagefinder_genome_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/prodigal/log/phagefinder_genome_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=1G
#$ -q short.q@cbsubrito2

#This script runs phagefinder on blastp file and sequencefile from prodigal and blastp output.

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/Genome_r4_Design.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/prodigal/genomes/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

IN=$OUT/${NAME}_proteins.out

#make log
LOG=$WRK/prodigal/log/phagefinder_${NAME}_$JOB_ID.out
echo start phage_finder ${NAME} `date` >> $LOG 2>&1

#export phome
export PHOME=/workdir/users/agk85/tools/

cd $WRK/prodigal/genomes/${NAME}/

/workdir/users/agk85/tools/phage_finder_v2.1/bin/Phage_Finder_v2.1.pl -t ${NAME}_proteins.out -i phage_finder_info.txt >> $LOG 2>&1

echo finished phage_finder $NAME `date` >> $LOG 2>&1