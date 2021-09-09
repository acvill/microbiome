#$ -S /bin/bash
#$ -N trnascan
#$ -e /workdir/users/agk85/CDC/trnascan/log/trnascan_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/trnascan/log/trnascan_$JOB_ID.out
#$ -V
#$ -pe parenv 1
#$ -l h_vmem=2G
#$ -t 1-88
#$ -q long.q@cbsubrito2

# Run tRNAScan-SE against metagenomes

echo start blast `date`

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_all.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/trnascan/metagenomes
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

SCF=$WRK/prodigal/metagenomes2/${NAME}/${NAME}_scaffold.fasta
OUTFILE=$OUT/${NAME}_trnascan.txt
echo begin trnascan `date`
source /programs/tRNAscan-SE-1.3.1/setup.tRNAscan-SE
tRNAscan-SE -B -o $OUTFILE $SCF
echo end trnascan `date` 
