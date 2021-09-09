

for SGE_TASK_ID in {2..6}
do
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/PatientDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

cat /workdir/users/agk85/CDC/card/metagenomes/${NAME}*/${NAME}*_drug_args.fna > /workdir/users/agk85/CDC/card/metagenomes/patients/${NAME}_args.fna
done
