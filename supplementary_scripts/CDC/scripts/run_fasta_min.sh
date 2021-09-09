#$ -S /bin/bash
#$ -N fasta_min
#$ -t 1-19
#$ -e /workdir/users/agk85/CDC/idba/log/fasta_min.err
#$ -V
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=1G
#$ -q short.q@cbsubrito2

# Goal is to subset scaffolds at minimum 500bp from idba generated scaffolds

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

SCF=$WRK/idba/metagenome/${NAME}/scaffold.fa
LEN=500
OUTSCF=$WRK/idba/metagenome/${NAME}/scaffold_min_${LEN}.fa

python $WRK/scripts/fasta_min_Xbp.py $SCF $OUTSCF $LEN


