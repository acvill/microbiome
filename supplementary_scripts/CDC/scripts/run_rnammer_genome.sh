#$ -S /bin/bash
#$ -N rnammer
#$ -V
#$ -o /workdir/users/agk85/CDC/spades/log/rnammer_$JOB_ID.out #####
#$ -e /workdir/users/agk85/CDC/spades/log/rnammer_$JOB_ID.err #####
#$ -wd /workdir/users/agk85/CDC/spades/log
#$ -pe parenv 1
#$ -l h_vmem=15G
#$ -t 1-26
#$ -q short.q@cbsubrito2
# Runs RNAMMER to identify 16S sequences in genome assemblies

#Set dirs
WRK=/workdir/users/agk85/CDC
OUTDIR=$WRK/spades/round14 ## output
#Create design file of file names
DESIGN_FILE=$WRK/GenomeDesign_r14.txt  #Your list of file names
NAME=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
SCF=${OUTDIR}/${NAME}/${NAME}_scaffold_min_500.fasta ##Location of your assembly scaffolds.fasta

################# RNAMMER ####################
RNAMMER=/programs/rnammer-1.2/rnammer

echo $NAME RNAMMER start

perl $RNAMMER -S bac -m ssu -f ${OUTDIR}/16S/${NAME}.16S.fasta $SCF

echo $NAME RNAMMER complete
