#$ -S /bin/bash
#$ -N cdhit
#$ -e /workdir/users/agk85/CDC/tables/log/cdhit_types_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/tables/log/cdhit_types_$JOB_ID.out
#$ -V
#$ -pe parenv 1
#$ -l h_vmem=30G
#$ -t 1-4
#$ -q long.q@cbsubrito2

# Program will cluster all proteins from a patient at 90% identity using cdhit 
echo start blast `date`

WRK=/workdir/users/agk85/CDC/tables
DESIGN_FILE=$WRK/TypeDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK
IN=$OUT/${NAME}.fna

#run cd-hit using output from prodigal that has been concatenated to include all metagenomes ORFs by patient in respective files
/programs/cd-hit-v4.6.1-2012-08-27/cd-hit-est -i $IN -o $OUT/${NAME}_nr.fna -c 0.90 -M 30000 -T 15 -d 0

echo end cd-hit `date` 
