
#This script runs masurca on CDC genomes to assemble them as a comparison to SPADES.
#Modified to just run one at a time on commandline because scheduler is not working for it.

JOB_ID='manual'
for SGE_TASK_ID in {1..24};
do
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/GenomeDesign.txt
        NAME=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)

FQ1=/workdir/data/CDC/genomes/${NAME}.derep_1.adapter.fastq
FQ2=/workdir/data/CDC/genomes/${NAME}.derep_2.adapter.fastq

OUT=$WRK/masurca/${NAME}
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/masurca/log/${NAME}_${JOB_ID}.out

echo start masurca $NAME `date` >> $LOG 2>&1
cd $OUT

#make configuration file using SPADES information
python /workdir/users/agk85/CDC/scripts/set_masurca_config.py $FQ1 $FQ2 $NAME

#Run masurca
/programs/MaSuRCA-3.2.1/bin/masurca ${NAME}_configuration.txt >> $LOG 2>&1

./assemble.sh >> $LOG 2>&1

echo done masurca $NAME `date` >> $LOG 2>&1

done
