#$ -S /bin/bash
#$ -N gaemr
#$ -V
#$ -o /workdir/users/agk85/CDC/spades/log/gaemr_$JOB_ID.out #####
#$ -e /workdir/users/agk85/CDC/spades/log/gaemr_$JOB_ID.err #####
#$ -wd /workdir/users/agk85 #Your working directory
#$ -pe parenv 8
#$ -l h_vmem=15G
#$ -t 1-24 ##change this
#$ -q long.q@cbsubrito2

#Set dirs
WRK=/workdir/users/agk85/CDC

#Create design file of file names
DESIGN_FILE=/workdir/users/agk85/CDC/GenomeDesign.txt  #Your list of file names
NAME=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)

OUT=$WRK/spades/genomes/${NAME}
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

SCF=$WRK/spades/genomes/${NAME}.scaffolds.fasta
R1=/workdir/data/CDC/genomes/round1/${NAME}.derep_1.adapter.fastq
R2=/workdir/data/CDC/genomes/round1/${NAME}.derep_2.adapter.fastq
READS=$WRK/spades/${NAME}/${NAME}_reads.csv
echo ${R1},${R2} > $READS

export PATH=/programs/GAEMR-1.0.1/bin:$PATH
export PYTHONPATH=/programs/GAEMR-1.0.1/

echo $SAMPLE `date` Gaemr start
cd $OUT

python /programs/GAEMR-1.0.1/bin/GAEMR.py -s $SCF -t 8 --minScaffSize=500 -m IDBA_UD -o ${NAME} --force

echo $SAMPLE `date` Gaemr complete

