#$ -S /bin/bash
#$ -N gtdbtk_network
#$ -e /workdir/users/agk85/CDC2/logs/gtdbtk_network_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC2/logs/gtdbtk_network_$JOB_ID.out
#$ -t 11
#$ -V
#$ -wd /workdir/users/agk85/CDC2
#$ -pe parenv 20
#$ -l h_vmem=200G
#$ -q short.q@cbsubrito2

# Goal is to bin contigs into single species from idba generated scaffolds

WRK=/workdir/users/agk85/CDC2
DESIGN_FILE=$WRK/MetaDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

GENOME_FOLDER=$WRK/networks/clusters/${NAME}
OUT=$WRK/networks/gtdbtk/${NAME}
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

echo `date` begin
export PATH=/programs/hmmer/binaries:/programs/prodigal-2.6.3:/programs/FastTree-2.1.10:/programs/fastani-Linux64-v1.1:/programs/pplacer-Linux-v1.1.alpha19:$PATH
export GTDBTK_DATA_PATH=/workdir/GtdbTK/release89/
#run classification program
python ~/.local/bin/gtdbtk classify_wf --genome_dir $GENOME_FOLDER --out_dir $OUT -x fasta --prefix $NAME --cpus 20

echo `date` finish
