#$ -S /bin/bash
#$ -N fullp_filter
#$ -e /workdir/users/agk85/CDC/plasmids/log/fullplasmids_filter_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/plasmids/log/fullplasmids_filter_$JOB_ID.out
#$ -t 1-34
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=10G
#$ -q short.q@cbsubrito2

# Goal is to filter blast output 80% identity and 60% coverage of the reference sequence

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_rerun.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/plasmids/metagenomes/${NAME}
BLASTOUT=$OUT/${NAME}_fullplasmid.out
INFILE=$OUT/${NAME}_fullplasmid.out.best

#The reference database used in the original blast
REF=/workdir/refdbs/plasmids/plasmids.fna

#What you want to call the new filtered file 
OUTFILE=$OUT/${NAME}_fullplasmid_filter.out

#This finds the best hit based on bit score followed by eval followed by percent identity
sort -k1,1 -k12,12gr -k11,11g -k3,3gr $BLASTOUT | sort -u -k1,1 --merge > $INFILE

echo start filter ${NAME} `date`
#run python script first number is $identity second number is coverage of reference subject
python $WRK/scripts/blast_filter.py $REF $INFILE $OUTFILE 80 60
rm $INFILE
echo end filter ${NAME} `date`

