#$ -S /bin/bash
#$ -N metabat_with
#$ -e /workdir/users/agk85/CDC2/logs/metabat_with_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC2/logs/metabat_with_$JOB_ID.out
#$ -t 1-43
#$ -V
#$ -wd /workdir/users/agk85/CDC2
#$ -pe parenv 4
#$ -l h_vmem=10G
#$ -q short.q@cbsubrito2

# Goal is to bin contigs into single species from scaffolds

WRK=/workdir/users/agk85/CDC2
DESIGN_FILE=$WRK/MetaDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/metabat_with/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

OUTFILE=$OUT/${NAME}

SCF=$WRK/prodigal/metagenomes/${NAME}/${NAME}_scaffold.fasta
echo start maxbin ${NAME} `date` >> $LOG 2>&1
BAM=$WRK/mapping_with/${NAME}/${NAME}.sorted.bam


# default, metabat runs matabat 2
# if you want to run metabat v1, you need to specify metabat1 

export PATH=/programs/metabat:$PATH
cd $OUT
time runMetaBat.sh -t 4 $SCF $BAM


FOLDER=$WRK/metabat_with/${NAME}/${NAME}_scaffold.fasta.metabat-bins
cd $FOLDER
for file in bin*.fa;
do
echo $file
binnum=$(echo $file| cut -d'.' -f2)
newname=${NAME}_metabat_${binnum}.fa
mv $file $newname
done

echo end maxbin ${NAME} `date` >> $LOG 2>&1

