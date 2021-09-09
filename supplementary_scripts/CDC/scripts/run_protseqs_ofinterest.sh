#$ -S /bin/bash
#$ -N prot_seqs
#$ -e /workdir/users/agk85/CDC/tables/log/protseqs_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/tables/log/protseqs_$JOB_ID.out
#$ -t 1-32
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 1
#$ -l h_vmem=2G
#$ -q long.q@cbsubrito2

# Goal is to get scfs from scflist file created by get_card_scfs.sh  
SCRIPT=/workdir/users/agk85/CDC/scripts/protseqs_ofinterest6.py
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/HicDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`


LOG=/workdir/users/agk85/CDC/tables/log/mgeseqs_${NAME}.log
echo start protseqs_ofinterest `date` >> $LOG 2>&1
echo $SCRIPT >> $LOG 2>&1
#run python script
python $SCRIPT $NAME  >> $LOG 2>&1

echo end protseqs_ofinterest `date` >> $LOG 2>&1


#after wards

#grep '>' /workdir/users/agk85/CDC/tables/metagenomes3/B*_mge.fna > /workdir/users/agk85/CDC/tables/metagenomes3/gene_ids.txt
