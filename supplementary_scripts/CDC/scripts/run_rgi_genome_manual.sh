
# Goal is to identify ARG from idba generated scaffolds
for SGE_TASK_ID in {1..26};
do
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/GenomeDesign_r14.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/card/genomes/r14/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/card/log/rgi_r14_${NAME}_genome_manual.out
PROT=$WRK/prodigal/genomes/r14/${NAME}/${NAME}_proteins.faa
OUTPUT=${OUT}/${NAME}

echo start rgi ${NAME} `date` >> $LOG 2>&1
echo start rgi ${NAME} 
#run rgi on prodigal amino acid sequences
python /workdir/users/agk85/CDC/card/rgi/rgi.py -t protein -i $PROT -o $OUTPUT >> $LOG 2>&1

echo end rgi ${NAME} `date` >> $LOG 2>&1
done
