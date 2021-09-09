#$ -S /bin/bash
#$ -N isescan
#$ -e /workdir/users/agk85/CDC/iselements/log/isescan3_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/iselements/log/isescan3_$JOB_ID.out
#$ -t 1-19
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 16
#$ -l h_vmem=16G
#$ -q short.q@cbsubrito2

# Goal is to identify is-elements from idba generated scaffolds
# do this one at a time in screen

JOB_ID='manual'
for SGE_TASK_ID in {1..19};
do
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=/workdir/users/agk85/tools/ISEScan/metagenomes
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/iselements/log/isescan3_${NAME}_$JOB_ID.out
SCF=$WRK/prodigal/metagenomes/${NAME}/scaffold.fna
PRGRM=/workdir/users/agk85/tools/ISEScan/isescan.py

cp $SCF $OUT/${NAME}.fna
echo start isescan ${NAME} `date` >> $LOG 2>&1

#export python lib
export PYTHONPATH=$PYTHONPATH:/programs/fastcluster_p3/lib/python3.6/site-packages:/workdir/users/agk85/tools/ISEScan/
#export ssw library
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/workdir/users/agk85/tools/ISEScan/

#move to the file
cd $OUT
#run ISEScan 
python3 $PRGRM ${NAME}.fna proteome hmm >>$LOG 2>&1

echo end isescan ${NAME} `date` >> $LOG 2>&1

done