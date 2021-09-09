#$ -S /bin/bash
#$ -N kraken_bin3c
#$ -e /workdir/users/agk85/CDC2/logs/kraken_bins_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC2/logs/kraken_bins_$JOB_ID.out
#$ -t 38-44
#$ -V
#$ -wd /workdir/users/agk85/CDC2
#$ -pe parenv 10
#$ -l h_vmem=300G
#$ -q long.q@cbsubrito2

# Goal is to bin contigs into single species from idba generated scaffolds
WRK=/workdir/users/agk85/CDC2

#list of all the bins in the DAS folders:
#ls */*DASTool_bins/*.fa | cut -d'/' -f3 > bins.txt
DESIGN_FILE=$WRK/MetaDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

#make the bin file
ls $WRK/bin3c/${NAME}/${NAME}_bin3c_clust/newfasta/*.fna | cut -d '/' -f10 > $WRK/bin3c/${NAME}/${NAME}_bins.txt 

OUT=$WRK/bin3c/${NAME}/kraken/
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

/workdir/users/agk85/tools/krakenuniq/krakenuniq --db  /workdir/users/agk85/tools/krakenuniq/DB_subset --preload --threads 20


file_lines=`cat $WRK/bin3c/${NAME}/${NAME}_bins.txt`
for line in $file_lines; 
do
echo $line
echo start kraken for DAS $line
/workdir/users/agk85/tools/krakenuniq/krakenuniq --db /workdir/users/agk85/tools/krakenuniq/DB_subset --threads 20 --fasta-input $WRK/bin3c/${NAME}/${NAME}_bin3c_clust/newfasta/${line} --report-file $WRK/bin3c/${NAME}/kraken/${line}.report.txt > ${WRK}/bin3c/${NAME}/kraken/${line}.kraken.txt 

/workdir/users/agk85/tools/krakenuniq/krakenuniq-translate --db /workdir/users/agk85/tools/krakenuniq/DB_subset --mpa-format ${WRK}/bin3c/${NAME}/kraken/${line}.kraken.txt  > ${WRK}/bin3c/${NAME}/kraken/${line}.kraken.taxonomy.txt


#get the best taxonomy for each bin
python /workdir/users/agk85/press2/scripts/best_taxonomy_50_contamination.py -i $WRK/bin3c/${NAME}/kraken/${line}.report.txt -o $WRK/bin3c/${NAME}/kraken/${line}.report.txt.besttaxid

echo end kraken for DAS $line
done

done
