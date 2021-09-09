#$ -S /bin/bash
#$ -N prodigal_CDC
#$ -V
#$ -t 1
#$ -e /workdir/users/agk85/CDC/prodigal/log/prodigal_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC/prodigal/log/prodigal_$JOB_ID.out
#$ -wd /workdir/users/agk85/CDC
#$ -l h_vmem=10G
#$ -q short.q@cbsubrito2

#This script runs prodigal on scaffolds from IDBA_UD output for phage_finder.
# Change the Design file if there are stragglers and you need to redo

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/573Design.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/prodigal/metagenomes/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

SCF=$WRK/idba_rerun/metagenomes/${NAME}/scaffold.fa

echo start ${NAME} `date`

#make log directory
if [ ! -d $WRK/prodigal/log/ ]; then mkdir -p $WRK/prodigal/log/; fi
LOG=$WRK/prodigal/log/prodigal_${NAME}_$JOB_ID.out

#make sample directory
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

#move the scaffold file to the phage_finder_folder
cp $SCF $OUT/${NAME}_scaffold.fasta

grep '>' $OUT/${NAME}_scaffold.fasta | cut -d'>' -f2 > $OUT/${NAME}_scfids.txt

python /workdir/users/agk85/CDC/scripts/general_getseqs.py $OUT/${NAME}_scaffold.fasta $OUT/${NAME}_scfids.txt $OUT/${NAME}_scaffold_rename.fasta 1 ${NAME}

mv $OUT/${NAME}_scaffold_rename.fasta $OUT/${NAME}_scaffold.fasta

SCF=$OUT/${NAME}_scaffold.fasta

#Run prodigal
/programs/prodigal-2.6.3/prodigal -i $SCF -o $OUT/${NAME}.gff3 -f gff -d $OUT/${NAME}_proteins.fna -a $OUT/${NAME}_proteins.faa -p meta >> $LOG 2>&1

#program to make the required phage_finder_info.txt file--input is the complete sequences and the orf fasta file
python /workdir/users/agk85/CDC/scripts/phage_finder_info.py $OUT/${NAME}_scaffold.fasta $OUT/${NAME}_proteins.faa $OUT/phage_finder_info.txt

grep '>' $OUT/${NAME}_proteins.faa -c 
echo finished prodigal ${NAME} `date`

