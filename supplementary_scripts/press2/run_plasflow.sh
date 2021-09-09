#$ -S /bin/bash
#$ -N plasflow
#$ -e /workdir/users/agk85/CDC2/logs/plasflow_$JOB_ID.err
#$ -o /workdir/users/agk85/CDC2/logs/plasflow_$JOB_ID.out
#$ -t 1-37
#$ -V
#$ -wd /workdir/users/agk85/CDC2
#$ -pe parenv 1
#$ -l h_vmem=20G
#$ -q long.q@cbsubrito2

# Goal is to bin contigs into single species from idba generated scaffolds

WRK=/workdir/users/agk85/CDC2

DESIGN_FILE=$WRK/MetaDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`


## set environment
export PATH=/programs/Anaconda2/bin:$PATH
export LD_LIBRARY_PATH=/programs/Anaconda2/lib:$LD_LIBRARY_PATH
source activate plasflow


#ran on B314-1, 3 minutes
## run the tool
PlasFlow.py --input $WRK/prodigal_excise/metagenomes/${NAME}/${NAME}_scaffold.fasta --output $WRK/plasmids/metagenomes/${NAME}/${NAME}_plasflow.txt --threshold 0.95

 
## after you are done, deactivate the environment
source deactivate


