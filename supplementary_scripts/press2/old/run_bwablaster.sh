#$ -S /bin/bash
#$ -N bwaphase
#$ -V
#$ -o /workdir/users/agk85/press2/logs/bwaphase_$JOB_ID.out #####
#$ -e /workdir/users/agk85/press2/logs/bwaphase_$JOB_ID.err #####
#$ -wd /workdir/users/agk85/press2/logs #Your working directory
#$ -pe parenv 8
#$ -l h_vmem=300G
#$ -t 2-32 ##change this
#$ -q long.q@cbsubrito2


#Set dirs
FOLDER=CDC2
WRK=/workdir/users/agk85/${FOLDER}
DESIGN_FILE=${WRK}/HicDesign.txt
NAME=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
LOG=/workdir/users/agk85/press2/phasegenomics/${NAME}_bwa_log.txt

/workdir/users/agk85/tools/bwa/bwa mem -t 8 -5SP /workdir/users/agk85/CDC2/hic/mapping/references/${NAME}_scaffold /workdir/data/CDC/hic/merged/${NAME}hic.1.fastq /workdir/data/CDC/hic/merged/${NAME}hic.2.fastq | /programs/samblaster/samblaster | samtools view -S -h -b -F 2316 > /workdir/users/agk85/press2/phasegenomics/${NAME}_phasegenomics.bam 
python /workdir/users/agk85/press2/scripts/bam_to_mate_hist/bam_to_mate_hist.py -b /workdir/users/agk85/press2/phasegenomics/${NAME}_phasegenomics.bam -r -o /workdir/users/agk85/press2/phasegenomics/${NAME} -n -1
rm /workdir/users/agk85/press2/phasegenomics/${NAME}_phasegenomics.bam

/workdir/users/agk85/tools/bwa/bwa mem -t 8 -5SP /workdir/users/agk85/CDC2/hic/mapping/references/${NAME}_scaffold /workdir/data/CDC/hic/merged/${NAME}hic.1.fastq /workdir/data/CDC/hic/merged/${NAME}hic.2.fastq | samtools view -S -h -b -F 2316 > /workdir/users/agk85/press2/phasegenomics/${NAME}_noblaster_phasegenomics.bam
python /workdir/users/agk85/press2/scripts/bam_to_mate_hist/bam_to_mate_hist.py -b /workdir/users/agk85/press2/phasegenomics/${NAME}_noblaster_phasegenomics.bam -r -o /workdir/users/agk85/press2/phasegenomics/${NAME}_nb -n -1
rm /workdir/users/agk85/press2/phasegenomics/${NAME}_noblaster_phasegenomics.bam
