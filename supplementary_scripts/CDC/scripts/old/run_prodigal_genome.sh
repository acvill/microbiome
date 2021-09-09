#$ -S /bin/bash
#$ -N prodigal_CDC
#$ -V
#$ -t 1-24
#$ -e /workdir/users/agk85/CDC/prodigal/log/prodigal_genome_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/prodigal/log/prodigal_genome_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=1G
#$ -q short.q@cbsubrito2

#This script runs prodigal on scaffolds from Spades output for phage_finder.
# Change the Design file if there are stragglers and you need to redo

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/GenomeDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/prodigal/genomes/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

SCF=$WRK/spades/genomes/${NAME}.scaffolds.fasta

echo start ${NAME} `date`

#make log directory
if [ ! -d $WRK/prodigal/log/ ]; then mkdir -p $WRK/prodigal/log/; fi

#make sample directory
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/prodigal/log/prodigal_genome_${NAME}_$JOB_ID.out
#Run prodigal
/programs/prodigal-2.6.3/prodigal -i $SCF -o $OUT/scaffold.gbk -d $OUT/scaffold.seq -a $OUT/scaffold.pep -p meta >> $LOG 2>&1 

#move the scaffold file to the phage_finder_folder
cp $SCF $OUT/scaffold.fna

#program to make the required phage_finder_info.txt file--input is the complete sequences and the orf fasta file
python /workdir/users/agk85/CDC/scripts/phage_finder_info.py $OUT/scaffold.fna $OUT/scaffold.seq $OUT/phage_finder_info.txt

echo $NAME
grep '>' $OUT/scaffold.pep -c 
echo finished prodigal ${NAME} `date`

