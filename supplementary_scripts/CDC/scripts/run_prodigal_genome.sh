#$ -S /bin/bash
#$ -N prodigalg
#$ -V
#$ -t 1-26
#$ -e /workdir/users/agk85/CDC/prodigal/log/prodigal_genome_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/prodigal/log/prodigal_genome_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=1G
#$ -q short.q@cbsubrito2

#This script runs prodigal on scaffolds from Spades output for phage_finder.
# Change the Design file if there are stragglers and you need to redo
# Changed to Genome_r4_Design.txt to do the new genomes
# Changed back to GenomeDesign.txt for B308-2s to make sure it ran correctly 

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/GenomeDesign_r14.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/prodigal/genomes/r14/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

SCF=$WRK/spades/genomes/r14/${NAME}/${NAME}_scaffolds.fasta
SCF=$WRK/prodigal/genomes/r14/${NAME}/${NAME}_scaffolds.fasta
echo start ${NAME} `date`

LOG=$WRK/prodigal/log/prodigal_genome_${NAME}_$JOB_ID.out
#Run prodigal
/programs/prodigal-2.6.3/prodigal -i $SCF -o $OUT/${NAME}_scaffold.gff -f gff -d $OUT/${NAME}_proteins.fna -a $OUT/${NAME}_proteins.faa -p meta >> $LOG 2>&1 

#move the scaffold file to the phage_finder_folder
cp $SCF $OUT/${NAME}_scaffold.fasta

#program to make the required phage_finder_info.txt file--input is the complete sequences and the orf fasta file
python /workdir/users/agk85/CDC/scripts/phage_finder_info.py $OUT/${NAME}_scaffolds.fasta $OUT/${NAME}_proteins.fna $OUT/phage_finder_info.txt

echo $NAME
grep '>' $OUT/${NAME}_proteins.faa -c 
echo finished prodigal ${NAME} `date`

