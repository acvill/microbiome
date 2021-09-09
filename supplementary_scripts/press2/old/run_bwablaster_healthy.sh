#$ -S /bin/bash
#$ -N bwaphase
#$ -V
#$ -o /workdir/users/agk85/healthy/logs/bwaphase_$JOB_ID.out #####
#$ -e /workdir/users/agk85/healthy/logs/bwaphase_$JOB_ID.err #####
#$ -wd /workdir/users/agk85/healthy/logs #Your working directory
#$ -pe parenv 4
#$ -l h_vmem=200G
#$ -t 1-5 ##change this
#$ -q long.q@cbsubrito2


#Set dirs
FOLDER=healthy
WRK=/workdir/users/agk85/${FOLDER}

DESIGN_FILE=${WRK}/HicDesign.txt
NAME=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
#newer version of bwa that has -5 flag
SCRIPT=/workdir/users/agk85/tools/bwa/bwa
#bwa reference
REF=$WRK/hic/mapping/references/${NAME}_scaffold
R1=/workdir/data/gates/hic_fastqs/${NAME}-hic.1.fastq
R2=/workdir/data/gates/hic_fastqs/${NAME}-hic.2.fastq
OUTPUT=/workdir/users/agk85/press2/phasegenomics/${NAME}_phasegenomics.bam 
OUTPUT2=/workdir/users/agk85/press2/phasegenomics/${NAME}_noblaster_phasegenomics.bam

HEADER=/workdir/users/agk85/press2/phasegenomics/${NAME}

SCRIPT=/workdir/users/agk85/tools/bwa/bwa 
SCRIPT2=/workdir/users/agk85/press2/scripts/bam_to_mate_hist/bam_to_mate_hist.py

$SCRIPT mem -t 8 -5SP $REF $R1 $R2 | /programs/samblaster/samblaster | samtools view -S -h -b -F 2316 > $OUTPUT
python $SCRIPT2 -b $OUTPUT -r -o $HEADER -n -1
rm $OUTPUT

$SCRIPT mem -t 8 -5SP $REF $R1 $R2 | samtools view -S -h -b -F 2316 > $OUTPUT2
python $SCRIPT2 -b $OUTPUT2 -r -o ${HEADER}_nb -n -1
rm $OUTPUT2
