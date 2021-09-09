#$ -S /bin/bash
#$ -N cBar
#$ -e /workdir/users/agk85/CDC/plasmids/log/cbar_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/plasmids/log/cbar_$JOB_ID.out
#$ -V
#$ -l h_vmem=10G
#$ -t 1-34
#$ -q short.q@cbsubrito2

# Identify plasmid vs. genome origin of each of the scaffolds using cBar program
# Cbar looks at kmer distribution
# Run against metagenomic scaffolds

echo start cbar `date` ${NAME}

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_rerun.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUTFILE=$WRK/plasmids/metagenomes/${NAME}/${NAME}_cbar.txt
SCF=$WRK/prodigal/metagenomes/${NAME}/${NAME}_scaffold.fasta

#run blastp using output from prodigal that has been concatenated to include all metagenomes and all phage in respective files
/programs/cBar.1.2/cBar.pl $SCF $OUTFILE
echo end cbar `date` ${NAME}
