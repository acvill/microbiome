#$ -S /bin/bash
#$ -N spades-m
#$ -V
#$ -o /workdir/users/agk85/CDC/spades/log/spades_$JOB_ID.out #####
#$ -e /workdir/users/agk85/CDC/spades/log/spades_$JOB_ID.err #####
#$ -wd /workdir/users/agk85 #Your working directory
#$ -pe parenv 1
#$ -l h_vmem=100G
#$ -t 1 ##change this
#$ -q long.q@cbsubrito2

#Set dirs
WRK=/workdir/data/CDC
ASSEMBLY=/workdir/users/agk85/CDC/spades ## Assemby output
TRIMM=/workdir/data/CDC/metagenomes/ ##Location of your trimmed reads

#Create design file of file names
DESIGN_FILE=/workdir/users/agk85/CDC/MetaDesign_r4.txt  #Your list of file names
SAMPLE=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)

################# SPADES ####################
SPADES=/programs/SPAdes-3.10.1-Linux/bin/spades.py

cd $ASSEMBLY
if [ ! -e $ASSEMBLY/${SAMPLE} ]; then mkdir -p ${ASSEMBLY}/${SAMPLE}; fi

FILE=$TRIMM
FORWARD=${SAMPLE}.1.fastq
REVERSE=${SAMPLE}.2.fastq
SOLOFW=${SAMPLE}.1.solo.fastq
SOLORV=${SAMPLE}.2.solo.fastq

echo $SAMPLE `date` SPADE start

$SPADES  -m 100 --meta --pe1-1 $FILE/${FORWARD} --pe1-2 $FILE/${REVERSE} -o $ASSEMBLY/${SAMPLE}

echo $SAMPLE `date` SPADE complete

