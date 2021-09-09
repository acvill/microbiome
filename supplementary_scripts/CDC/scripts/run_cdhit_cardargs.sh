#$ -S /bin/bash
#$ -N cdhit
#$ -e /workdir/users/agk85/CDC/resfams/log/cdhit_patient_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/resfams/log/cdhit_patient_$JOB_ID.out
#$ -V
#$ -pe parenv 8
#$ -l h_vmem=10G
#$ -t 2-6
#$ -q short.q@cbsubrito2

# Program will cluster all ARGs from a patient at 99% identity using cdhit 
echo start cdhit `date`

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/PatientDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/card/metagenomes/patients
IN=$OUT/${NAME}_args.fna

#run cd-hit using output from prodigal that has been concatenated to include all metagenomes ORFs by patient in respective files
/programs/cd-hit-v4.6.1-2012-08-27/cd-hit-est -i $IN -o $OUT/${NAME}_args_nr.fna -c 0.99 -M 10000 -T 8 -d 0

echo end cd-hit `date` 
