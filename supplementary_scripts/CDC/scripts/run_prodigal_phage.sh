#$ -S /bin/bash
#$ -N prodigal_CDC
#$ -V
#$ -t 1-6
#$ -e /workdir/users/agk85/phage_cara/prodigal/err/prodigal_phage_$JOB_ID.err
#$ -o /workdir/users/agk85/phage_cara/prodigal/log/prodigal_phage_$JOB_ID.out
#$ -wd /workdir/users/agk85/phage_cara
#$ -l h_vmem=1G
#$ -q short.q@cbsubrito2

#This script runs prodigal on scaffolds from Spades output for phage_finder.
# Change the Design file if there are stragglers and you need to redo

WRK=/workdir/users/agk85/phage_cara
DESIGN_FILE=$WRK/PhageDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/prodigal
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi



echo start ${NAME} `date`

#make log directory
if [ ! -d $WRK/prodigal/log/ ]; then mkdir -p $WRK/prodigal/log/; fi

#make sample directory
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/prodigal/log/prodigal_genome_${NAME}_$JOB_ID.out
#Run prodigal
/programs/prodigal-2.6.3/prodigal -i $SCF -o $OUT/${NAME}_scaffold.gff -f gff -d $OUT/${NAME}_proteins.fna -a $OUT/${NAME}_proteins.faa -p meta >> $LOG 2>&1 

#move the scaffold file to the phage_finder_folder
cp $SCF $OUT/${NAME}_scaffold.fasta

#program to make the required phage_finder_info.txt file--input is the complete sequences and the orf fasta file
python /workdir/users/agk85/CDC/scripts/phage_finder_info.py $OUT/${NAME}_scaffold.fasta $OUT/${NAME}_proteins.fna $OUT/phage_finder_info.txt

echo $NAME
grep '>' $OUT/${NAME}_proteins.faa -c 
echo finished prodigal ${NAME} `date`

