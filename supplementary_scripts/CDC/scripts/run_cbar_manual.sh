#! /bin/bash
# Identify plasmid vs. genome origin of each of the scaffolds using cBar program
# Cbar looks at kmer distribution
# Run against metagenomic scaffolds

echo start cbar `date`

for SGE_TASK_ID in {1..34};
do
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_rerun.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

LOG=$WRK/plasmids/log/cbar_${NAME}_manual.out
OUTFILE=$WRK/plasmids/metagenomes/${NAME}/${NAME}_cbar.txt
SCF=$WRK/prodigal/metagenomes/${NAME}/${NAME}_scaffold.fasta
echo start cbar `date` ${NAME} >> $LOG 2>&1
/programs/cBar.1.2/cBar.pl $SCF $OUTFILE >> $LOG 2>&1
echo end cbar `date` ${NAME} >> $LOG 2>&1
echo finished cbar ${NAME}
done
