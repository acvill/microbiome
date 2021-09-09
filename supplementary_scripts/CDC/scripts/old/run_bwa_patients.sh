#$ -S /bin/bash
#$ -N bwa
#$ -e /workdir/users/agk85/CDC/mapping/log/bwa_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/mapping/log/bwa_$JOB_ID.out
#$ -t 2
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 1
#$ -l h_vmem=50G
#$ -q short.q@cbsubrito2

# Goal is map back reads from each sample to clustered ORFs generated from prodigal, concatenating 
#patient orfs, and clustering with CD-HIT
#TODO: add the 75bp +/- after getting reads to map to original ones

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

PATIENT=$(echo $NAME | cut -f1 -d"-")
OUT=$WRK/mapping/metagenomes/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/mapping/log/bwa_patient_$JOB_ID_${NAME}.out

SCFOLD=$WRK/prodigal/metagenomes/combined_prots/${PATIENT}_nr.fna
FA=$WRK/idba/fq2fa/${NAME}_fq2fa.fasta
#SCF=$WRK/mapping/metagenomes/${NAME}/${NAME}_scaffold.seq
echo start bwa ${NAME} `date` >> $LOG 2>&1

#cp $SCFOLD $SCF
#cp $OLDR1 $INTERLEAVED

cd $OUT

/programs/bwa-0.7.8/bwa index $SCFOLD
/programs/bwa-0.7.8/bwa mem -p -a -t 8 $SCFOLD $FA > ${NAME}_nr.aln.sam
/programs/samtools-1.3.2/bin/samtools faidx $SCFOLD
/programs/samtools-1.3.2/bin/samtools import $SCFOLD ${NAME}_nr.aln.sam ${NAME}_nr.aln.sam.bam
/programs/samtools-1.3.2/bin/samtools sort ${NAME}_nr.aln.sam.bam -o ${NAME}_nr.aln.sam.bam.sorted
/programs/samtools-1.3.2/bin/samtools index ${NAME}_nr.aln.sam.bam.sorted
rm ${NAME}_nr.aln.sam.bam
/programs/samtools-1.3.2/bin/samtools idxstats ${NAME}_nr.aln.sam.bam.sorted > ${NAME}_nr.aln.sam.bam.sorted.idxstats

echo end bwa ${NAME} `date` >> $LOG 2>&1

