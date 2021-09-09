#$ -S /bin/bash
#$ -N rnammer_mg
#$ -V
#$ -wd /workdir/users/agk85/CDC/rnammer/metagenomes
#$ -pe parenv 1
#$ -l h_vmem=15G
#$ -t 1-88
#$ -tc 1
#$ -q long.q@cbsubrito2
#$ -e /workdir/users/agk85/CDC/rnammer/log/rnammer_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/rnammer/log/rnammer_$JOB_ID.out
# Runs RNAMMER to identify 16S sequences in metagenome assemblies

#Set dirs
WRK=/workdir/users/agk85/CDC
OUTDIR=$WRK/rnammer/metagenomes ## output
#Create design file of file names
DESIGN_FILE=$WRK/MetaDesign_all.txt  #Your list of file names
NAME=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
SCF=$WRK/prodigal/metagenomes/${NAME}/${NAME}_scaffold.fasta ##Location of your assembly scaffolds.fasta

################# RNAMMER ####################
RNAMMER=/programs/rnammer-1.2/rnammer

echo $NAME RNAMMER start

perl $RNAMMER -S bac -m ssu -f $OUTDIR/${NAME}_16S.fasta $SCF

echo $NAME RNAMMER complete
