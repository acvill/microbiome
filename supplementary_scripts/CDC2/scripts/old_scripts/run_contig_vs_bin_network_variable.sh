#$ -S /bin/bash
#$ -N contig_vs_bin_network
#$ -V
#$ -o /workdir/users/agk85/CDC2/logs/contig_vs_bin_$JOB_ID.out #####
#$ -e /workdir/users/agk85/CDC2/logs/contig_vs_bin_$JOB_ID.err #####
#$ -wd /workdir/users/agk85/CDC2/logs #Your working directory
#$ -pe parenv 1
#$ -l h_vmem=50G
#$ -t 2-44 ##change this
#$ -q short.q@cbsubrito2

#Set dirs
FOLDER=CDC2
CONTACT_THRESH=5
WRK=/workdir/users/agk85/${FOLDER}
DESIGN_FILE=${WRK}/MetaDesign.txt
NAME=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)

SCF=$WRK/prodigal_excise/metagenomes/${NAME}/${NAME}_scaffold.fasta

echo $SAMPLE `date` CvB start
OUT=$WRK/bins
if [ ! -d $OUT ]; then mkdir -p $OUT; fi
cd $OUT

#might not need to do this if you have run das network before
#conda init bash
#Set up conda DAS environment
export PATH=$HOME/miniconda3/condabin:$PATH
export PATH=$HOME/miniconda3/bin:$PATH
#/home/agk85/miniconda2/condabin/conda activate forDAS
eval "$(conda shell.bash hook)"
#source activate forDAS
conda activate forDAS
#first you need to make the scaffoldbins according to DASTool's preferences
Fasta_to_Scaffolds2Bin.sh -i ${WRK}/networks/clusters_${CONTACT_THRESH}/${NAME} -e fasta > ${WRK}/networks/clusters_${CONTACT_THRESH}/${NAME}/${NAME}_network_scaffolds2bin.tsv
conda deactivate

#FILES
SCRIPT=$WRK/scripts/contig_vs_bin.py
DAS=$WRK/networks/clusters_${CONTACT_THRESH}/${NAME}/${NAME}_network_scaffolds2bin.tsv
OUTFILE=$WRK/bins/${NAME}_network_${CONTACT_THRESH}_contigs_v_bins.txt
HIC=$WRK/hicpro/output/${NAME}_output/hic_results/data/${NAME}/${NAME}_trans_primary_0_ncol_withexcise_noeuks_normalize_${CONTACT_THRESH}.txt
COMBO_TABLE=$WRK/combo_tables/metagenomes/${NAME}_master_scf_table.txt
CHECKM=$WRK/networks/checkms_${CONTACT_THRESH}/${NAME}/${NAME}.stats
ARGS=$WRK/args/args_99_nr.fna.clstr.tbl
KRAKEN_BINS=$WRK/networks/membership/${NAME}_${CONTACT_THRESH}_mge_count_membership.txt
KRAKEN_CONTIGS=$WRK/kraken/${NAME}/${NAME}.kraken.taxonomy.txt
time python $SCRIPT -b $DAS -o $OUTFILE -l $HIC -t $COMBO_TABLE -m $CONTACT_THRESH -c $CHECKM -a $ARGS -k $KRAKEN_BINS -kc $KRAKEN_CONTIGS

python $WRK/scripts/contig_histogram_prep.py  -o $WRK/bins/${NAME}_contig_taxa_network_${CONTACT_THRESH}_fgs  -i $WRK/bins/${NAME}_network_${CONTACT_THRESH}_contigs_v_bins.txt  -c $WRK/combo_tables/metagenomes/${NAME}_master_scf_table.txt

echo $SAMPLE `date` CvB complete
