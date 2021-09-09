#$ -S /bin/bash
#$ -N mge_prot_CDC
#$ -V
#$ -t 1-92
#$ -e /workdir/users/agk85/CDC/idba_rerun/log/idba_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/idba_rerun/log/idba_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=3G
#$ -q long.q@cbsubrito2


#This script runs IDBA_UD to assemble genomes from interleaved fasta file
#increase memory in cases where first run fails

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_all.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

python ~/agk/CDC/scripts/protseqs_ofinterest3.py $NAME

