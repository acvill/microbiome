#$ -S /bin/bash
#$ -N geneids
#$ -V
#$ -t 1-9
#$ -e /workdir/users/agk85/CDC/logs3/geneids_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/logs3/geneids_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=1G
#$ -q long.q@cbsubrito2
#$ -tc 15

#This script runs IDBA_UD to assemble genomes from interleaved fasta file
#increase memory in cases where first run fails

WRK=/workdir/refdbs/metaphlan/geneid_link
DESIGN_FILE=${WRK}/geneid_all.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

INFILE=${WRK}/${NAME}

python ${WRK}/get_geneids.py ${INFILE} 

