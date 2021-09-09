#$ -S /bin/bash
#$ -N bwa
#$ -e /workdir/users/agk85/CDC/mapping/log/bwa_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/mapping/log/bwa_$JOB_ID.out
#$ -t 2-19
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 1
#$ -l h_vmem=50G
#$ -q short.q@cbsubrito2

# Goal is map back reads to ORFs generated from prodigal
#will add the 150bp +/- after getting reads to map to original ones

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/mapping/metagenomes/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/mapping/log/bwa_$JOB_ID_${NAME}.out

SCFOLD=$WRK/prodigal/metagenomes/${NAME}/scaffold_expand.seq
OLDR1=$WRK/idba/fq2fa/${NAME}_fq2fa.fasta
SCF=$WRK/mapping/metagenomes/${NAME}/${NAME}_scaffold.seq
INTERLEAVED=$WRK/mapping/metagenomes/${NAME}/${NAME}_fq2fa.fasta
echo start bwa ${NAME} `date` >> $LOG 2>&1

cp $SCFOLD $SCF
cp $OLDR1 $INTERLEAVED

cd $OUT

/programs/bwa-0.7.8/bwa index $SCF >>$LOG 2>&1

/programs/bwa-0.7.8/bwa mem -p -a -t 8 $SCF $INTERLEAVED > $INTERLEAVED.aln.sam

/programs/samtools-1.3.2/bin/samtools faidx $SCF >> $LOG 2>&1

/programs/samtools-1.3.2/bin/samtools import subset_assembly.fa $INTERLEAVED.aln.sam $INTERLEAVED.aln.sam.bam >>$LOG 2>&1

/programs/samtools-1.3.2/bin/samtools sort $INTERLEAVED.aln.sam.bam -o $INTERLEAVED.aln.sam.bam.sorted >>$LOG 2>&1

/programs/samtools-1.3.2/bin/samtools index $INTERLEAVED.aln.sam.bam.sorted >>$LOG 2>&1
rm $INTERLEAVED.aln.sam.bam

/programs/samtools-1.3.2/bin/samtools idxstats $INTERLEAVED.aln.sam.bam.sorted > $INTERLEAVED.aln.sam.bam.sorted.idxstats

echo end bwa ${NAME} `date` >> $LOG 2>&1

