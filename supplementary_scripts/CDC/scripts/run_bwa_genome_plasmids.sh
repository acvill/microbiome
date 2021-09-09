#$ -S /bin/bash
#$ -N bwa
#$ -e /workdir/users/agk85/CDC/plasmids/log/bwa_plasmids$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/plasmids/log/bwa_plasmids$JOB_ID.out
#$ -t 1-18
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 8
#$ -l h_vmem=75G
#$ -q short.q@cbsubrito2

# Goal is map back reads from each sample to recycler generated plasmids
# and eventually to map each sample to the whole bacterial genome where the plasmid came from

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

#PATIENT=$(echo $NAME | cut -f1 -d"-")
OUT=$WRK/plasmids/metagenomes/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/plasmids/log/bwa_recycler_$JOB_ID_${NAME}.out

SCF=/workdir/users/agk85/tools/Recycler/genomes/possible_plasmids.fasta
FQ2FA=$WRK/idba/fq2fa/${NAME}_fq2fa.fasta
SCFOLD=$OUT/possible_plasmids.fasta
FA=$OUT/${NAME}_fq2fa.fasta

echo start bwa ${NAME} `date` >> $LOG 2>&1

cd $OUT
cp $SCF $SCFOLD
cp $FQ2FA $FA
/programs/bwa-0.7.8/bwa index $SCFOLD
/programs/bwa-0.7.8/bwa mem -p -a -t 8 $SCFOLD $FA > ${NAME}_pp.aln.sam
/programs/samtools-1.3.2/bin/samtools faidx $SCFOLD
/programs/samtools-1.3.2/bin/samtools import $SCFOLD ${NAME}_pp.aln.sam ${NAME}_pp.aln.sam.bam
/programs/samtools-1.3.2/bin/samtools sort ${NAME}_pp.aln.sam.bam -o ${NAME}_pp.aln.sam.bam.sorted
/programs/samtools-1.3.2/bin/samtools index ${NAME}_pp.aln.sam.bam.sorted
rm ${NAME}_pp.aln.sam.bam
/programs/samtools-1.3.2/bin/samtools idxstats ${NAME}_pp.aln.sam.bam.sorted > ${NAME}_pp.aln.sam.bam.sorted.idxstats
rm $SCFOLD
rm $FA

echo end bwa ${NAME} `date` >> $LOG 2>&1

