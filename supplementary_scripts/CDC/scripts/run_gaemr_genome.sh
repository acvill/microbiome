#$ -S /bin/bash
#$ -N gaemr
#$ -V
#$ -o /workdir/users/agk85/CDC/spades/log/gaemr_$JOB_ID.out #####
#$ -e /workdir/users/agk85/CDC/spades/log/gaemr_$JOB_ID.err #####
#$ -wd /workdir/users/agk85 #Your working directory
#$ -pe parenv 8
#$ -l h_vmem=15G
#$ -t 1-26 ##change this
#$ -q short.q@cbsubrito2

#Set dirs
WRK=/workdir/users/agk85/CDC

#Create design file of file names
DESIGN_FILE=/workdir/users/agk85/CDC/GenomeDesign_r14.txt  #Your list of file names
NAME=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)

SCF=$WRK/spades/round14/${NAME}/${NAME}_scaffold_min_500.fasta 
R1=/workdir/data/CDC/genomes/round14/${NAME}.1.fastq
R2=/workdir/data/CDC/genomes/round14/${NAME}.2.fastq
READS=$WRK/spades/round14/${NAME}/${NAME}_reads.csv
echo ${R1},${R2} > $READS

export PATH=/programs/GAEMR-1.0.1/bin:$PATH
export PYTHONPATH=/programs/GAEMR-1.0.1/

echo $SAMPLE `date` Gaemr start
cd $WRK/spades/round14/${NAME}/

python /programs/GAEMR-1.0.1/bin/GAEMR.py -s $SCF -t 8 -l $READS --minScaffSize=500 -i bwa -m spades -o ${NAME} --force

echo $SAMPLE `date` Gaemr complete

