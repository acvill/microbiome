#$ -S /bin/bash
#$ -N bwa
#$ -e /workdir/users/agk85/CDC/plasmids/log/bwa_plasmids$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/plasmids/log/bwa_plasmids$JOB_ID.out
#$ -t 1-5
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 8
#$ -l h_vmem=75G
#$ -q short.q@cbsubrito2

# Goal is map back reads from each sample to recycler generated plasmids
# and eventually to map each sample to the whole bacterial genome where the plasmid came from

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/B309Design.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

#PATIENT=$(echo $NAME | cut -f1 -d"-")
OUT=$WRK/plasmids/metagenomes/B309
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/plasmids/log/bwa_recycler_$JOB_ID_${NAME}.out

FQ1=$WRK/plasmids/metagenomes/B309/${NAME}/${NAME}.1.fastq
FQ2=$WRK/plasmids/metagenomes/B309/${NAME}/${NAME}.2.fastq
REF=$OUT/${NAME}/possible_plasmids.fasta

echo start bwa ${NAME} `date` >> $LOG 2>&1

cd $OUT/${NAME}
/programs/bwa-0.7.8/bwa index $REF
/programs/bwa-0.7.8/bwa mem -a -t 8 $REF $FQ1 $FQ2 > ${NAME}_pp.aln.sam
/programs/samtools-1.3.2/bin/samtools faidx $REF
/programs/samtools-1.3.2/bin/samtools import $REF ${NAME}_pp.aln.sam ${NAME}_pp.aln.sam.bam
/programs/samtools-1.3.2/bin/samtools sort ${NAME}_pp.aln.sam.bam -o ${NAME}_pp.aln.sam.sorted.bam
/programs/samtools-1.3.2/bin/samtools index ${NAME}_pp.aln.sam.sorted.bam
rm ${NAME}_pp.aln.sam.bam
/programs/samtools-1.3.2/bin/samtools idxstats ${NAME}_pp.aln.sam.sorted.bam > ${NAME}_pp.aln.sam.sorted.bam.idxstats

echo end bwa ${NAME} `date` >> $LOG 2>&1

