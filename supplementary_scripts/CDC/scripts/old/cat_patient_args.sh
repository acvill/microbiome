#$ -S /bin/bash
#$ -N cat_arg
#$ -e /workdir/users/agk85/CDC/resfams/log/cat_arg_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/resfams/log/cat_arg_$JOB_ID.out
#$ -t 1-6
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 1
#$ -l h_vmem=1G
#$ -q short.q@cbsubrito2

# Goal is map back reads from each sample to clustered ORFs generated from prodigal, concatenating 
#patient orfs, and clustering with CD-HIT
#TODO: add the 75bp +/- after getting reads to map to original ones

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/PatientDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/resfams/metagenomes/patients
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

cat $WRK/resfams/metagenomes/${NAME}*/*_args.fna > $OUT/${NAME}_args.fna
