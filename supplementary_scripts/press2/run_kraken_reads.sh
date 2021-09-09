#$ -S /bin/bash
#$ -N kraken_reads
#$ -e /workdir/users/agk85/press2/logs/kraken_reads_$JOB_ID.err
#$ -o /workdir/users/agk85/press2/logs/kraken_reads_$JOB_ID.out
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

OUT=$WRK/kraken/${NAME}
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

echo start kraken for $NAME
/workdir/users/agk85/tools/krakenuniq/krakenuniq --db /workdir/users/agk85/tools/krakenuniq/DB_subset --threads 8 --fastq-input --paired /workdir/data/press/metagenomes/merged/${NAME}.1.fastq /workdir/data/press/metagenomes/merged/${NAME}.2.fastq --report-file $WRK/kraken/${NAME}/${NAME}.reads.report.txt > ${WRK}/kraken/${NAME}/${NAME}.reads.kraken.txt 

/workdir/users/agk85/tools/krakenuniq/krakenuniq-translate --db /workdir/users/agk85/tools/krakenuniq/DB_subset --mpa-format ${WRK}/kraken/${NAME}/${NAME}.reads.kraken.txt  > ${WRK}/kraken/${NAME}/${NAME}.reads.kraken.taxonomy.txt

echo end kraken for $NAME
