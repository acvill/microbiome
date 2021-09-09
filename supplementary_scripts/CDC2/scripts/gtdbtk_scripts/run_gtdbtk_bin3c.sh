#$ -S /bin/bash
#$ -N gtdbtk_bin3c
#$ -e /workdir/users/agk85/CDC2/logs/gtdbtk_bin3c_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC2/logs/gtdbtk_bin3c_$JOB_ID.out
#$ -t 35
#$ -V
#$ -wd /workdir/users/agk85/CDC2
#$ -pe parenv 10
#$ -l h_vmem=150G
#$ -q long.q@cbsubrito2

# Goal is to bin contigs into single species from idba generated scaffolds

WRK=/workdir/users/agk85/CDC2

#list of all the bins in the DAS folders:
#ls */*DASTool_bins/*.fa | cut -d'/' -f3 > bins.txt
DESIGN_FILE=$WRK/MetaDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

export PATH=/programs/hmmer/binaries:/programs/prodigal-2.6.3:/programs/FastTree-2.1.10:/programs/fastani-Linux64-v1.1:/programs/pplacer-Linux-v1.1.alpha19:$PATH
export GTDBTK_DATA_PATH=/workdir/GtdbTK/release89/

OUT=$WRK/bin3c/${NAME}/gtdbtk/
if [ ! -d $OUT ]; then mkdir -p $OUT; fi

#get data file

gtdbtk classify_wf --genome_dir $WRK/bin3c/${NAME}/${NAME}_bin3c_clust/newfasta/ -x fna --out_dir $WRK/bin3c/${NAME}/gtdbtk --cpus 20

