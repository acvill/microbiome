#$ -S /bin/bash
#$ -N gaemr
#$ -V
#$ -o /workdir/users/agk85/CDC/gaemr/log/gaemr_$JOB_ID.out #####
#$ -e /workdir/users/agk85/CDC/gaemr/log/gaemr_$JOB_ID.err #####
#$ -wd /workdir/users/agk85/CDC/gaemr/metagenomes4 #Your working directory
#$ -pe parenv 4
#$ -l h_vmem=30G
#$ -t 1-60 ##change this
#$ -q long.q@cbsubrito2


#Set dirs
WRK=/workdir/users/agk85/CDC

#Create design file of file names
#PRIMARY_DESIGN=/workdir/users/agk85/CDC/Design.txt
#TASK_ID=$(sed -n "${SGE_TASK_ID}p" $PRIMARY_DESIGN)

#DESIGN_FILE=/workdir/users/agk85/CDC/HicDesign.txt  #Your list of file names
DESIGN_FILE=/workdir/users/agk85/CDC/MetaDesign_noHic.txt
NAME=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)

SCF=$WRK/prodigal_excise/metagenomes3/${NAME}/${NAME}_scaffold.fasta
export PATH=/programs/GAEMR-1.0.1/bin:$PATH
export PYTHONPATH=/programs/GAEMR-1.0.1/

echo $SAMPLE `date` Gaemr start
OUT=$WRK/gaemr/metagenomes5/${NAME}
if [ ! -d $OUT ]; then mkdir -p $OUT; fi
cd $OUT
python2.7 /programs/GAEMR-1.0.1/bin/GAEMR.py -s $SCF -t 4 -m IDBA_UD -o ${NAME} --force

echo $SAMPLE `date` Gaemr complete

