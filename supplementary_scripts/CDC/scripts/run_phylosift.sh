#$ -S /bin/bash
#$ -N phylosift
#$ -e /workdir/users/agk85/CDC/phylosift/log/phylosift_genome_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/phylosift/log/phylosift_genome_$JOB_ID.out
#$ -t 1-24
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 1
#$ -l h_vmem=16G
#$ -q short.q@cbsubrito2

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/GenomeDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

        
INPUT=$WRK/growth_rates/maxbin/${NAME}/mbin
OUT=$WRK/growth_rates/phylosift/${NAME}
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/growth_rates/log/phylosift_genome_${NAME}_$JOB_ID.out

cd $INPUT

while read MBINFILE; do
  echo $MBINFILE
  MBINID=`echo $MBINFILE | cut -d"." -f2`
  SCF=/workdir/users/agk85/CDC/growth_rates/maxbin/${NAME}/mbin/${MBINFILE}
  /workdir/users/agk85/tools/phylosift/phylosift_v1.0.1/bin/phylosift all $SCF >> $LOG 2>&1
  mv PS_temp $OUT/${MBINID}  
done <$INPUT/mbinDesign.txt

echo done phylosift >> $LOG 2>&1

