#$ -S /bin/bash
#$ -N B320_maxbin
#$ -e /workdir/users/agk85/CDC/growth_rates/log/maxbin_B320_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/growth_rates/log/maxbin_B320_$JOB_ID.out
#$ -t 2-4
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 1
#$ -l h_vmem=50G
#$ -q short.q@cbsubrito2

# Goal is to bin contigs into single species from idba generated scaffolds

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_B320.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/growth_rates/maxbin/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/growth_rates/log/maxbin_B320_$JOB_ID_${NAME}.out

SCFOLD=$WRK/prodigal/metagenomes/${NAME}/scaffold.fna
OLDR1=/workdir/data/CDC/metagenomes/${NAME}.1.fastq
OLDR2=/workdir/data/CDC/metagenomes/${NAME}.2.fastq
SCF=$WRK/growth_rates/maxbin/${NAME}/scaffold.fna
R1=$WRK/growth_rates/maxbin/${NAME}/${NAME}.1.fastq
R2=$WRK/growth_rates/maxbin/${NAME}/${NAME}.2.fastq
echo start maxbin ${NAME} `date` >> $LOG 2>&1

#run maxbin
cp $SCFOLD $SCF
cp $OLDR1 $R1
cp $OLDR2 $R2

cd $OUT

/programs/bwa-0.7.8/bwa index -a bwtsw $SCF >>$LOG 2>&1

/programs/bwa-0.7.8/bwa mem $SCF $R1 $R2 > ${NAME}.aln.sam

/programs/samtools-1.3.2/bin/samtools faidx $SCF >> $LOG 2>&1

for i in *.sam
do
 # /programs/samtools-1.3.2/bin/samtools import subset_assembly.fa $i $i.bam
  /programs/samtools-1.3.2/bin/samtools sort $i.bam -o $i.bam.sorted
  /programs/samtools-1.3.2/bin/samtools index $i.bam.sorted
done

for i in *bam.sorted
do
  /programs/samtools-1.3.2/bin/samtools idxstats $i > $i.idxstats
  cut -f1,3 $i.idxstats > $i.counts
done

ls $OUT/*counts > $OUT/abundance.list

perl ~/agk/tools/maxbin/MaxBin-2.2.2/run_MaxBin.pl -contig $SCF -abund_list $OUT/abundance.list -max_iteration 5 -out $OUT/mbin >> $LOG 2>&1

echo end maxbin ${NAME} `date` >> $LOG 2>&1

