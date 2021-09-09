#$ -S /bin/bash
#$ -N kraken_bins
#$ -e /workdir/users/agk85/press2/logs/kraken_bins_$JOB_ID.err
#$ -o /workdir/users/agk85/press2/logs/kraken_bins_$JOB_ID.out
#$ -t 1
#$ -V
#$ -wd /workdir/users/agk85/press2
#$ -pe parenv 1
#$ -l h_vmem=300G
#$ -q long.q@cbsubrito2

# Goal is to bin contigs into single species from idba generated scaffolds

WRK=/workdir/users/agk85/press2

#list of all the bins in the DAS folders:
#ls */*DASTool_bins/*.fa | cut -d'/' -f3 > bins.txt
DESIGN_FILE=$WRK/MetaDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

#make the bin file
ls $WRK/das/${NAME}/${NAME}_DASTool_non_mobile_bins/*.fa | cut -d '/' -f9 > $WRK/das/${NAME}/${NAME}_non_mobile_bins.txt 

OUT=$WRK/das/${NAME}/kraken_non_mobile
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

file_lines=`cat $WRK/das/${NAME}/${NAME}_non_mobile_bins.txt`
for line in $file_lines; 
do
echo $line
echo start kraken for DAS $line
/workdir/users/agk85/tools/krakenuniq/krakenuniq --db /workdir/users/agk85/tools/krakenuniq/DB_subset --threads 4 --fasta-input $WRK/das/${NAME}/${NAME}_DASTool_non_mobile_bins/${line} --report-file ${OUT}/${line}.report.txt > ${OUT}/${line}.kraken.txt 

/workdir/users/agk85/tools/krakenuniq/krakenuniq-translate --db /workdir/users/agk85/tools/krakenuniq/DB_subset --mpa-format ${OUT}/${line}.kraken.txt  > ${OUT}/${line}.kraken.taxonomy.txt

echo end kraken for DAS $line
done
