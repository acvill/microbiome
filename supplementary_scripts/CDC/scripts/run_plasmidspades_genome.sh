#$ -S /bin/bash
#$ -N spades
#$ -V
#$ -o /workdir/users/agk85/CDC/plasmids/log/plasmidspades_$JOB_ID.out #####
#$ -e /workdir/users/agk85/CDC/plasmids/log/plasmidspades_$JOB_ID.err #####
#$ -wd /workdir/users/agk85 #Your working directory
#$ -pe parenv 1
#$ -l h_vmem=15G
#$ -t 3 ##change this
#$ -q long.q@cbsubrito2
#$ -tc 2

#Set dirs
WRK=/workdir/data/CDC
ASSEMBLY=/workdir/users/agk85/CDC/plasmids/genomes ## Assemby output
TRIMM=/workdir/data/CDC/genomes/round1 ##Location of your trimmed reads

#Create design file of file names
DESIGN_FILE=/workdir/users/agk85/CDC/GenomeDesign_r1.txt  #Your list of file names
SAMPLE=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)

################# SPADES ####################
SPADES=/programs/SPAdes-3.10.1-Linux/bin/spades.py

cd $ASSEMBLY
if [ ! -e $ASSEMBLY/${SAMPLE} ]; then mkdir -p ${ASSEMBLY}/${SAMPLE}; fi

FILE=$TRIMM
FORWARD=${SAMPLE}.derep_1.adapter.fastq
REVERSE=${SAMPLE}.derep_2.adapter.fastq
SOLOFW=${SAMPLE}.derep_1.adapter.solo.fastq
SOLORV=${SAMPLE}.derep_2.adapter.solo.fastq

echo $SAMPLE `date` SPADE start

$SPADES  -m 15 --careful --plasmid --pe1-1 $FILE/${FORWARD} --pe1-2 $FILE/${REVERSE} --pe1-s $FILE/${SOLOFW} --pe1-s $FILE/${SOLORV} -o $ASSEMBLY/${SAMPLE}

echo $SAMPLE `date` SPADE complete

