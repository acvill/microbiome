#$ -S /bin/bash
#$ -N hicpro
#$ -V
#$ -t 12-16
#$ -e /workdir/users/agk85/CDC/hic/log/hicpro_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/hic/log/hicpro_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=20G
#$ -q long.q@cbsubrito2

#This script runs hi-c pro on HiC data from subject 573.
# Change the Design file if there are stragglers and you need to redo

# before this make sure the reference has been made properly
# in references folder do the following
# bowtie2-build 573_SMC2.fasta 573_SMC2.fasta
# python ~/agk/CDC/scripts/reference_genome_sizes.py 573_SMC2.fasta 573_SMC2.sizes
# python /programs/HiC-Pro_2.7.9/bin/utils/digest_genome.py -r hindiii -o 573_SMC2_hindiii.bed 573_SMC2.fasta

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/HicDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

# if [ ! -d $OUT ]; then mkdir -p $OUT; fi
OUTPUT=$WRK/hic/hic-pro/dpn/rawdata/${NAME}
if [ ! -d $OUTPUT ]; then mkdir -p $OUTPUT; fi

#export
export PYTHONPATH=/programs/HiC-Pro_2.7.9/lib64/python2.7/site-packages:$PYTHONPATH
export PATH=/programs/HiC-Pro_2.7.9/bin:$PATH
echo started hic-pro ${NAME} `date`

mv /workdir/data/CDC/hic/${NAME}.human_1.adapter.fastq /workdir/data/CDC/hic/${NAME}_R1.fastq

mv /workdir/data/CDC/hic/${NAME}.human_2.adapter.fastq /workdir/data/CDC/hic/${NAME}_R2.fastq

/programs/HiC-Pro_2.7.9/bin/utils/split_reads.py --results_folder $OUTPUT --nreads 500000 /workdir/data/CDC/hic/${NAME}_R1.fastq

/programs/HiC-Pro_2.7.9/bin/utils/split_reads.py --results_folder $OUTPUT --nreads 500000 /workdir/data/CDC/hic/${NAME}_R2.fastq 


