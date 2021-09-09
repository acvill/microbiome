#$ -S /bin/bash
#$ -N hicpro
#$ -V
#$ -e /workdir/users/agk85/CDC/hic/log/hicpro_C1r_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/hic/log/hicpro_C1r_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=20G
#$ -q long.q@cbsubrito2

#This script runs hi-c pro on HiC data from SMC.
# before this make sure the reference has been made properly
# in references folder do the following
# bowtie2-build SMC.fasta SMC.fasta
# python ~/agk/CDC/scripts/reference_genome_sizes.py SMC.fasta SMC.sizes
# python /programs/HiC-Pro_2.7.9/bin/utils/digest_genome.py -r hindiii other cutters  -o SMC_hindiii_xbai_xhoi.bed SMC.fasta


# /programs/HiC-Pro_2.7.9/bin/utils/split_reads.py --results_folder ../../split/rawdata/ --nreads 1000000 A1_R1.fastq
# /programs/HiC-Pro_2.7.9/bin/utils/split_reads.py --results_folder ../../split/rawdata/ --nreads 1000000 A1_R2.fastq

# if [ ! -d $OUT ]; then mkdir -p $OUT; fi
#make log directory
WRK=/workdir/users/agk85/CDC
LOG=$WRK/hic/log/hicpro_C1r_$JOB_ID.out
#make sample directory

INPUT=$WRK/hic/C1r/rawdata
OUTPUT=$WRK/hic/C1r_output
CONFIG=$WRK/hic/config-hicpro_C1r.txt

#export
export PYTHONPATH=/programs/HiC-Pro_2.7.9/lib64/python2.7/site-packages:$PYTHONPATH
export PATH=/programs/HiC-Pro_2.7.9/bin:$PATH
echo started hic-pro `date`

#Run hic-pro
HiC-Pro -i $INPUT -o $OUTPUT -c $CONFIG >> $LOG 2>&1

echo finished hic-pro `date`

###convert to juicer format .hic

# /programs/HiC-Pro_2.7.9/bin/utils/hicpro2juicebox.sh -i ~/agk/CDC/hic/hic-pro/A1/hic-results/data/A1/A1_allValidPairs -g ~/agk/CDC/hic/references/574_SMC2.sizes -j ~/agk/CDC/hic/juicebox_tools.jar
