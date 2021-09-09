#$ -S /bin/bash
#$ -N GSMer
#$ -V
#$ -o /workdir/users/agk85/CDC/GSMer/log/GSMer_$JOB_ID.out #####
#$ -e /workdir/users/agk85/CDC/GSMer/log/GSMer_$JOB_ID.err #####
#$ -wd /workdir/users/agk85/CDC/GSMer #Your working directory
#$ -pe parenv 1
#$ -l h_vmem=15G
#$ -t 1-34  ##change this
#$ -q long.q@cbsubrito2

#Set dirs
WRK=/workdir/users/agk85/CDC

#Create design file of file names
DESIGN_FILE=/workdir/users/agk85/CDC/HicDesign.txt  #Your list of file names
NAME=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)

SCF=$WRK/prodigal_excise/metagenomes2/${NAME}/${NAME}_scaffold.fasta

echo $SAMPLE `date` GSMer start
OUT=$WRK/gsmer/metagenomes2/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi
cd $OUT

megablast -d /workdir/users/agk85/tools/refdbs/gsmerdb_species -i $SCF -m 8 
echo $SAMPLE `date` GSMer complete

