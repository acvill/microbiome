#$ -S /bin/bash
#$ -N hicpro_s
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/CDC/hic/log/hicpro_single_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/hic/log/hicpro_single_$JOB_ID.out
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
INPUT=$WRK/hic/hic-pro/single/rawdata
OUTPUT=$WRK/hic/hic-pro/single/output
CONFIG=$WRK/hic/hic-pro/single/config-hicpro.txt

#export
export PYTHONPATH=/programs/HiC-Pro_2.7.9/lib64/python2.7/site-packages:$PYTHONPATH
export PATH=/programs/HiC-Pro_2.7.9/bin:$PATH
echo started hic-pro `date`

#Run hic-pro
HiC-Pro -i $INPUT -o $OUTPUT -c $CONFIG -p
echo finished hic-pro `date`

