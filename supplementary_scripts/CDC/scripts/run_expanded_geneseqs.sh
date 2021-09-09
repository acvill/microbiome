#$ -S /bin/bash
#$ -N expand
#$ -e /workdir/users/agk85/CDC/prodigal/log/expand_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/prodigal/log/expand_$JOB_ID.out
#$ -t 1-19
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 8
#$ -l h_vmem=16G
#$ -q short.q@cbsubrito2

# Goal is to expand prodigal called genes 150bp on either side

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/prodigal/metagenomes/${NAME}/

REF=$OUT/scaffold.fna
SEQ=$OUT/scaffold.seq
OUTFILE=$OUT/scaffold_expand.seq

echo start expand ${NAME} `date`

#run python script
python /workdir/users/agk85/CDC/scripts/get_expanded_geneseqs.py $REF $SEQ $OUTFILE

echo end expand ${NAME} `date`

