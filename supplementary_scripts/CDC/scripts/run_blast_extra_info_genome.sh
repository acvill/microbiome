#$ -S /bin/bash
#$ -N blast_info
#$ -e /workdir/users/agk85/CDC/blast_comparisons/log/blast_infog_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/blast_comparisons/log/blast_infog_$JOB_ID.out
#$ -t 8-20
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 1
#$ -l h_vmem=10G
#$ -q short.q@cbsubrito2

# Goal is to add information to all-v-all blast that tells you about how extended it is on either side of the query and subject

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/GenomeDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

SCRIPT=$WRK/scripts/blast_extra_info.py
#number of bp you want beyond the extension
REF=$WRK/prodigal/genomes/${NAME}/${NAME}_scaffold.fasta
THRESH=2000
INFILE=$WRK/blast_comparisons/genomes/${NAME}_scfs.out
OUTFILE=$WRK/blast_comparisons/genomes/${NAME}_scfs_info.out

echo start blast_extra_info ${NAME} `date`
echo $SCRIPT

#run python script
python $SCRIPT $REF $THRESH $INFILE $OUTFILE

echo end blast_extra_info ${NAME} `date`

