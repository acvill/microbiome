#$ -S /bin/bash
#$ -N DAS_network
#$ -e /workdir/users/agk85/simulated/logs/DAS_network_$JOB_ID.err
#$ -o /workdir/users/agk85/simulated/logs/DAS_network_$JOB_ID.out
#$ -t 1
#$ -V
#$ -wd /workdir/users/agk85/simulated
#$ -pe parenv 8
#$ -l h_vmem=30G
#$ -q long.q@cbsubrito2

#This runs DAS on maxbin and metabat output to combine and create new mgm bins, could improve to add in Concoct in the future

#requires that metabat and maxbin and concoct and the network clustering have already been performed

#conda init bash
#Set up conda DAS environment
echo $PATH
export PATH=$HOME/miniconda3/condabin:$PATH
export PATH=$HOME/miniconda3/bin:$PATH

#/home/agk85/miniconda2/condabin/conda activate forDAS
eval "$(conda shell.bash hook)"
#source activate forDAS
conda activate forDAS
#each of the folders
WRK=/workdir/users/agk85/simulated
DESIGN_FILE=$WRK/MetaDesign.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

OUT=$WRK/das_network/${NAME}
 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

#first you need to make the scaffoldbins according to DASTool's preferences
Fasta_to_Scaffolds2Bin.sh -i ${WRK}/maxbin/${NAME} -e fasta > ${WRK}/maxbin/${NAME}/${NAME}_maxbin2_scaffolds2bin.tsv

Fasta_to_Scaffolds2Bin.sh -i /workdir/agk85/metabat/${NAME} -e fa > /workdir/agk85/metabat/${NAME}/${NAME}_metabat2_scaffolds2bin.tsv

Fasta_to_Scaffolds2Bin.sh -i ${WRK}/concoct/${NAME}/concoct_output/fasta_bins -e fa > ${WRK}/concoct/${NAME}/concoct_output/fasta_bins/${NAME}_concoct_scaffolds2bin.tsv

Fasta_to_Scaffolds2Bin.sh -i ${WRK}/networks/clusters/${NAME}_mge_count -e fasta > ${WRK}/networks/clusters/${NAME}_mge_count/${NAME}_network_scaffolds2bin.tsv

#B314-1 took 4 minutes with 32 threads
#B314-1 too 	with 1 thread 60 minutes

DAS_Tool -i  ${WRK}/maxbin/${NAME}/${NAME}_maxbin2_scaffolds2bin.tsv,/workdir/agk85/metabat/${NAME}/${NAME}_metabat2_scaffolds2bin.tsv,${WRK}/concoct/${NAME}/concoct_output/fasta_bins/${NAME}_concoct_scaffolds2bin.tsv,${WRK}/networks/clusters/${NAME}_mge_count/${NAME}_network_scaffolds2bin.tsv -l maxbin,metabat,concoct,network -c ${WRK}/prodigal_excise/metagenomes/${NAME}/${NAME}_scaffold.fasta -o ${WRK}/das_network/${NAME}/${NAME} --search_engine BLAST --write_bins 1 --score_threshold 0 -t 8

conda deactivate
