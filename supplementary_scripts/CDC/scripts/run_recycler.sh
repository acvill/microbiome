#$ -S /bin/bash
#$ -N recycler
#$ -e /workdir/users/agk85/CDC/spades/log/recycler_r4_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/spades/log/recycler_r4_$JOB_ID.out
#$ -t 1-20
#$ -V
#$ -pe parenv 1
#$ -l h_vmem=8G
#$ -q short.q@cbsubrito2

#script to run recycler which identifies cycling plasmids from spades output
WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/Genome_r4_Design.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

BWA=/programs/bwa-0.7.8/bwa
SAMTOOLS=/programs/samtools-1.3.2/bin/samtools
FQ1=/workdir/data/CDC/genomes/round4/${NAME}.derep_1.adapter.fastq
FQ2=/workdir/data/CDC/genomes/round4/${NAME}.derep_2.adapter.fastq

LOG=$WRK/spades/log/${NAME}_$JOB_ID.log
cd $WRK/spades/genomes/${NAME}
echo start `date` ${NAME}
python /workdir/users/agk85/tools/Recycler/bin/make_fasta_from_fastg.py -g assembly_graph.fastg -o assembly_graph.nodes.fasta
$BWA index assembly_graph.nodes.fasta
$BWA mem assembly_graph.nodes.fasta $FQ1 $FQ2 | $SAMTOOLS view -buS - > reads_pe.bam
$SAMTOOLS view -bF 0x0800 reads_pe.bam > reads_pe_primary.bam
$SAMTOOLS sort reads_pe_primary.bam > reads_pe_primary.sort.bam
$SAMTOOLS index reads_pe_primary.sort.bam

#following these steps, we only need the files reads_pe_primary.sort.bam and reads_pe_primary.sort.bam.bai
#remove the rest
#rm assembly_graph.nodes.fasta*
#rm reads_pe_primary.bam
#rm reads_pe.bam

python /workdir/users/agk85/tools/Recycler/bin/recycle.py -g assembly_graph.fastg -k 77 -b reads_pe_primary.sort.bam -i True -o plasmid_results
echo finished `date` ${NAME}

