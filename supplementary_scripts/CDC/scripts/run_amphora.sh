#$ -S /bin/bash
#$ -N amphora
#$ -e /workdir/users/agk85/CDC/amphora/log/amphora_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/amphora/log/amphora_$JOB_ID.out
#$ -t 1-17
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=5G
#$ -q long.q@cbsubrito2

# Goal is to annotate peptide sequences
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_newhic.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

#changed to metagenomes2 for the final run
OUT=$WRK/amphora/metagenomes2/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/amphora/log/amphora_${NAME}_$JOB_ID.out
PROT=$WRK/prodigal/metagenomes2/${NAME}/${NAME}_proteins.faa

echo start amphora ${NAME} `date` >> $LOG 2>&1
export PATH=/programs/hmmer/binaries:/programs/emboss/bin:/programs/AMPHORA2/bin:$PATH
export AMPHORA2_home=/workdir/users/agk85/tools/AMPHORA2
SCRIPTS=/workdir/users/agk85/tools/AMPHORA2/Scripts

#run amphora2 using idba proteins
cd $OUT
${SCRIPTS}/MarkerScanner.pl -Bacteria -ReferenceDirectory /workdir/users/agk85/tools/AMPHORA2/Marker/ $PROT
${SCRIPTS}/MarkerAlignTrim.pl -WithReference -OutputFormat phylip
${SCRIPTS}/Phylotyping.pl $PROT > ${NAME}_phylotype.txt

echo end amphora ${NAME} `date` >> $LOG 2>&1

