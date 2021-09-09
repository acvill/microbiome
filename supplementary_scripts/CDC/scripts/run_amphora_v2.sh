#$ -S /bin/bash
#$ -N amphora
#$ -e /workdir/users/agk85/CDC/amphora/log/amphora_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/amphora/log/amphora_$JOB_ID.out
#$ -t 1-31
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 2
#$ -l h_vmem=10G
#$ -q long.q@cbsubrito2

# Goal is to annotate peptide sequences
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_rerun.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/amphora/metagenomes/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/amphora/log/amphora_${NAME}_$JOB_ID.out
SCF=$WRK/prodigal/metagenomes/${NAME}/${NAME}_scaffold.fasta

echo start amphora ${NAME} `date` >> $LOG 2>&1
export PATH=/programs/hmmer/binaries:/programs/emboss/bin:/programs/AMPHORA2/bin:$PATH
export AMPHORA2_home=/workdir/users/agk85/tools/AMPHORA2
SCRIPTS=/workdir/users/agk85/tools/AMPHORA2/Scripts

#run amphora2 using idba scaffolds
cd $OUT
${SCRIPTS}/MarkerScanner.pl -ReferenceDirectory /workdir/users/agk85/tools/AMPHORA2/Marker/ -DNA $SCF
${SCRIPTS}/MarkerAlignTrim.pl -WithReference -OutputFormat phylip
${SCRIPTS}/Phylotyping.pl $SCF -CPUs 2 > ${NAME}_phylotype_scfs.txt

echo end amphora ${NAME} `date` >> $LOG 2>&1

