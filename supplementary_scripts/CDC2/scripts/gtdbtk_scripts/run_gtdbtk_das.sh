#$ -S /bin/bash
#$ -N gtdbtk_das
#$ -e /workdir/users/agk85/CDC2/logs/gtdbtk_das_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC2/logs/gtdbtk_das_$JOB_ID.out
#$ -t 1-43
#$ -V
#$ -wd /workdir/users/agk85/CDC2
#$ -pe parenv 1
#$ -l h_vmem=150G
#$ -q long.q@cbsubrito2

# Goal is to bin contigs into single species from idba generated scaffolds

WRK=/workdir/users/agk85/CDC2
DESIGN_FILE=$WRK/MetaDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

GENOME_FOLDER=$WRK/das/${NAME}/${NAME}_DASTool_bins/
OUT=$WRK/das/${NAME}/gtdbtk/
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

export PATH=/programs/hmmer/binaries:/programs/prodigal-2.6.3:/programs/FastTree-2.1.10:/programs/fastani-Linux64-v1.1:/programs/pplacer-Linux-v1.1.alpha19:$PATH
export GTDBTK_DATA_PATH=/workdir/GtdbTK/release89/
#run classification program
python ~/.local/bin/gtdbtk classify_wf --genome_dir $GENOME_FOLDER --out_dir $OUT -x fa --prefix ${NAME}


