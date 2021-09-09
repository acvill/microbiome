#$ -S /bin/bash
#$ -N hic_iterate
#$ -e /workdir/users/agk85/CDC/hic/log/hic_iterate_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/hic/log/hic_iterate_$JOB_ID.out
#$ -t 2
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -pe parenv 1
#$ -l h_vmem=50G
#$ -q long.q@cbsubrito2

# Goal is to map hi-c reads to hi-c reference per burton et al. Strict matching with iterations at 150, 125, 100, 75, 50

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/HicDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/hic/mapping/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/hic/log/hic_iterate_$JOB_ID_${NAME}.out
REF=$WRK/hic/references/573_SMC2.fasta
REFNAME=573_SMC2
echo start hic_iterate ${NAME} `date` >> $LOG 2>&1

cd $OUT
#Script to run through different lengths of Hi-C reads with strict mapping to ${REFNAME} dataset

R1=/workdir/data/CDC/hic/${NAME}.human_1.adapter.fastq
R2=/workdir/data/CDC/hic/${NAME}.human_2.adapter.fastq

O1=${NAME}_unmapped_150_1.fastq
O2=${NAME}_unmapped_150_2.fastq
OS1=${NAME}_unmapped_150_1_solo.fastq
OS2=${NAME}_unmapped_150_2_solo.fastq
TRIMMO=/programs/trimmomatic/trimmomatic-0.36.jar
java -Xmx8g -jar $TRIMMO PE $R1 $R2 $O1 $OS1 $O2 $OS2 CROP:150
rm $OS1
rm $OS2

for LEN in 150 125 100;
do
	bwa mem -t 8 $REF ${NAME}_unmapped_${LEN}_1.fastq > ${NAME}_R1_${REFNAME}_${LEN}.sam
	samtools view -bh ${NAME}_R1_${REFNAME}_${LEN}.sam > ${NAME}_R1_${REFNAME}_${LEN}.bam
	bamtools filter -tag XM:0 -in ${NAME}_R1_${REFNAME}_${LEN}.bam -out ${NAME}_R1_${REFNAME}_${LEN}_good.bam
	bamtools filter -tag "XM:>0" -in ${NAME}_R1_${REFNAME}_${LEN}.bam -out ${NAME}_R1_${REFNAME}_${LEN}_bad.bam
	samtools view -h ${NAME}_R1_${REFNAME}_${LEN}_bad.bam > ${NAME}_R1_${REFNAME}_${LEN}_bad.sam 
	cat ${NAME}_R1_${REFNAME}_${LEN}_bad.sam | grep -v ^@ | awk '{print "@"$1"\n"$10"\n+\n"$11}' > ${NAME}_unmapped_${LEN}_1.fastq

	bwa mem -t 8 $REF ${NAME}_unmapped_${LEN}_2.fastq > ${NAME}_R2_${REFNAME}_${LEN}.sam
	samtools view -bh ${NAME}_R2_${REFNAME}_${LEN}.sam > ${NAME}_R2_${REFNAME}_${LEN}.bam
	bamtools filter -tag XM:0 -in ${NAME}_R2_${REFNAME}_${LEN}.bam -out ${NAME}_R2_${REFNAME}_${LEN}_good.bam
	bamtools filter -tag "XM:>0" -in ${NAME}_R2_${REFNAME}_${LEN}.bam -out ${NAME}_R2_${REFNAME}_${LEN}_bad.bam
	samtools view -h ${NAME}_R2_${REFNAME}_${LEN}_bad.bam > ${NAME}_R2_${REFNAME}_${LEN}_bad.sam 
	cat ${NAME}_R2_${REFNAME}_${LEN}_bad.sam | grep -v ^@ | awk '{print "@"$1"\n"$10"\n+\n"$11}' > ${NAME}_unmapped_${LEN}_2.fastq
	
	NEXT_LEN=`expr $LEN - 25`
	F1=${NAME}_unmapped_${LEN}_1.fastq
	F2=${NAME}_unmapped_${LEN}_2.fastq
	O1=${NAME}_unmapped_${NEXT_LEN}_1.fastq
	O2=${NAME}_unmapped_${NEXT_LEN}_2.fastq
	OS1=${NAME}_unmapped_${NEXT_LEN}_1_solo.fastq
	OS2=${NAME}_unmapped_${NEXT_LEN}_2_solo.fastq
	TRIMMO=/programs/trimmomatic/trimmomatic-0.36.jar
	java -Xmx8g -jar $TRIMMO PE $F1 $F2 $O1 $OS1 $O2 $OS2 CROP:${NEXT_LEN}
	rm $OS1
	rm $OS2
	rm $F1
	rm $F2
done

samtools merge -fn ${NAME}_R2_${REFNAME}_all_lengths.bam ${NAME}_R1_${REFNAME}_150.good.bam ${NAME}_R1_${REFNAME}_125.good.bam ${NAME}_R1_${REFNAME}_100.bam 
samtools merge -fn ${NAME}_R2_${REFNAME}_all_lengths.bam ${NAME}_R2_${REFNAME}_150.good.bam ${NAME}_R2_${REFNAME}_125.good.bam ${NAME}_R2_${REFNAME}_100.bam 

#  Keeping only the columns of the sam file that contain necessary information:
awk '{print $1,$3,$4,$2,$5;}' ${NAME}_R1_${REFNAME}_all_lengths.bam > ${NAME}_R1_${REFNAME}_3Cformat
awk '{print $1,$3,$4,$2,$5;}' ${NAME}_R2_${REFNAME}_all_lengths.bam > ${NAME}_R2_${REFNAME}_3Cformat

# Sort according to the read identification to have both mates in the same order
# if sort does not have -V option try -d
sort -V -k1 ${NAME}_R1_${REFNAME}_3Cformat > ${NAME}_R1_${REFNAME}_3Cformat.sorted
sort -V -k1 ${NAME}_R2_${REFNAME}_3Cformat > ${NAME}_R2_${REFNAME}_3Cformat.sorted

# Pairing of both mates in a single file
paste ${NAME}_R1_${REFNAME}_3Cformat.sorted ${NAME}_R2_${REFNAME}_3Cformat.sorted > ${NAME}_merged_${REFNAME}_3Cformat.sorted

#Remove pairs if both reads aren't above 30 mapq
awk '{if($1 eq $6 && $5>= 30 && $10 >= 30) print $2,$3,$4,$7,$8,$9}'  ${NAME}_merged_${REFNAME}_3Cformat.sorted  > ${NAME}_merged_${REFNAME}_3Cformat.dat

echo hic_iterate finished `date` >> $LOG 2>&1
