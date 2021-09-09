FOLDER=press
WRK=/workdir/users/agk85/${FOLDER}
PID=99
#run qc
qsub snake_qc_qsub.sh
#run idba
qsub snake_idba_qsub.sh
#run minimum prodigal
qsub snake_min_prodigal_pf_qsub.sh
#run excise
snake_excise_phage 
#run trnascan
screen 
snakemake -s snake_trnascan
#run identification
qsub snake_identify_qsub.sh
#run hic
qsub snake_bwaindex_qsub.sh
qsub snake_bwahic_9899100_qsub.sh 

##############side step
qsub run_metaphlan_press.sh
cd $WRK/metaphlan/
/programs/MetaPhlAn-2.0/utils/merge_metaphlan_tables.py *_profile.txt > ${FOLDER}_metaphlan.txt
#manually create this file
mgm_hic_pairs_press.csv
#repopulate this file and run --makes the stacked chart, the bray-curtis clustering, and the difference plot
Rscript /workdir/users/agk85/press/scripts/metaphlan_press.R 
########################################



#some sort of catting of the trans reads into the hic/mapping folder----because you did this once upon a time
#but you might not have to do that now
#cat /workdir/users/agk85/${FOLDER}/hic/mapping/*/*_trans_primary_98.txt > /workdir/users/agk85/${FOLDER}/hic/mapping/trans_primary_98.txt
#cat /workdir/users/agk85/${FOLDER}/hic/mapping/*/*_trans_primary_99.txt > /workdir/users/agk85/${FOLDER}/hic/mapping/trans_primary_99.txt
#cat /workdir/users/agk85/${FOLDER}/hic/mapping/*/*_trans_primary_100.txt > /workdir/users/agk85/${FOLDER}/hic/mapping/trans_primary_100.txt


#moot
#get the ncol format....what did i do???
#cd /workdir/users/agk85/${FOLDER}/hic/mapping/
#cut -f3,9 trans_primary_98.txt | sort | uniq -c | awk '{print $2 "\t" $3 "\t" $1}' > trans_primary_ncol_98.txt
#cut -f3,9 trans_primary_99.txt | sort | uniq -c | awk '{print $2 "\t" $3 "\t" $1}' > trans_primary_ncol_99.txt
#cut -f3,9 trans_primary_100.txt | sort | uniq -c | awk '{print $2 "\t" $3 "\t" $1}' > trans_primary_ncol_100.txt

#relink the hic
#python ~/agk/press/scripts/hic_relink_excise.py $FOLDER trans_primary_ncol_98.txt trans_primary_ncol_98_withexcise.txt

#do the two steps in one bash script
for FILE in ${WRK}/hic/mapping/*/*_trans_primary_99.txt;
do
echo $FILE;
BASE=$(echo $FILE | cut -d'.' -f1);
NCOL="${BASE}_ncol.txt";
echo $NCOL;
cut -f3,9 $FILE | sort | uniq -c | awk '{print $2 "\t" $3 "\t" $1}' > $NCOL;
WITHEXCISE=${BASE}_ncol_withexcise.txt
echo $WITHEXCISE;
python ~/agk/press/scripts/hic_relink_excise.py ${FOLDER} $NCOL $WITHEXCISE;
done

#remove eukaryotic reads from the hic-trans reads
#this does stuff in the mapping folder as well as within each hic folder
python ~/agk/press/scripts/remove_eukaryote_trans.py $FOLDER $PID

#network clustering
#change the percent identity in the snake_network script
qsub snake_network_qsub.sh
#getting args and mobile elements into respective folders
f=/workdir/users/agk85/${FOLDER}/arg_v_org/metagenomes
if [ ! -d $f ]; then mkdir -p $f; fi

#clustering args and mobile elements at 95% identity

#get card ids
cut -f1,9 ${WRK}/card/metagenomes/*/*.txt | sort | uniq | grep -v '^ORF' > ${WRK}/arg_v_org/metagenomes/card_prot_id_type.txt
cut -f1 ${WRK}/card/metagenomes/*/*.txt | sort | uniq | grep -v '^ORF'  > ${WRK}/arg_v_org/metagenomes/card_protein_ids.txt
#because CARD adds a stupid space after their ids
sed -i -e 's/ \t/\t/g' ${WRK}/arg_v_org/metagenomes/card_prot_id_type.txt
#get resfams ids
cut -f1,3 ${WRK}/resfams/metagenomes/*/*_resfams.txt | sort | uniq > ${WRK}/arg_v_org/metagenomes/resfams_prot_id_type.txt
cut -f1 ${WRK}/resfams/metagenomes/*/*_resfams.txt | sort | uniq > ${WRK}/arg_v_org/metagenomes/resfams_protein_ids.txt

#combine them and get rid of the space after the CARD ids
cat ${WRK}/arg_v_org/metagenomes/card_protein_ids.txt ${WRK}/arg_v_org/metagenomes/resfams_protein_ids.txt | tr -d " \t\r" | sort | uniq > ${WRK}/arg_v_org/metagenomes/arg_protein_ids.txt
#get all of the proteins in one reference file
cat ${WRK}/prodigal_excise/metagenomes/*/*_proteins.fna > ${WRK}/arg_v_org/metagenomes/all_proteins.fna
python /workdir/users/agk85/CDC/scripts/general_getseqs.py ${WRK}/arg_v_org/metagenomes/all_proteins.fna ${WRK}/arg_v_org/metagenomes/arg_protein_ids.txt ${WRK}/arg_v_org/metagenomes/arg_prot.fasta 0 all

#cluster them update this so it reflects the correct directory and identity threshold
qsub run_cdhit_allargs.sh
#map them, update this
qsub snake_arg_bwa_qsub.sh
#get the arg names and make a 80% coverage table of the rpkms
python /workdir/users/agk85/press/scripts/arg_scripts/arg_sample_rpkm.py /workdir/users/agk85/press/arg_v_org/metagenomes/mapping/bwa_alignments_99_99 /workdir/users/agk85/press/arg_v_org/metagenomes/mapping/bwa_alignments_99_99/arg_v_samp_99_99.txt /workdir/users/agk85/press/arg_v_org/metagenomes/mapping/bwa_alignments_99_99/arg_v_samp_99_99_names.txt /workdir/users/agk85/press

#is it time to link things?
f=/workdir/users/agk85/${FOLDER}/arg_v_org/metagenomes/histograms/original/
if [ ! -d $f ]; then mkdir -p $f; fi
f=/workdir/users/agk85/${FOLDER}/arg_v_org/metagenomes/histograms/nocorecore/
if [ ! -d $f ]; then mkdir -p $f; fi
f=/workdir/users/agk85/${FOLDER}/arg_v_org/metagenomes/histograms/nocorecorenomobilemobile/
if [ ! -d $f ]; then mkdir -p $f; fi

f=/workdir/users/agk85/${FOLDER}/arg_v_org/metagenomes/cliques/original/
if [ ! -d $f ]; then mkdir -p $f; fi
f=/workdir/users/agk85/${FOLDER}/arg_v_org/metagenomes/cliques/nocorecore/
if [ ! -d $f ]; then mkdir -p $f; fi
f=/workdir/users/agk85/${FOLDER}/arg_v_org/metagenomes/cliques/nocorecorenomobilemobile/
if [ ! -d $f ]; then mkdir -p $f; fi

f=/workdir/users/agk85/${FOLDER}/arg_v_org/metagenomes/flickering/original/
if [ ! -d $f ]; then mkdir -p $f; fi
f=/workdir/users/agk85/${FOLDER}/arg_v_org/metagenomes/flickering/nocorecore/
if [ ! -d $f ]; then mkdir -p $f; fi
f=/workdir/users/agk85/${FOLDER}/arg_v_org/metagenomes/flickering/nocorecorenomobilemobile/
if [ ! -d $f ]; then mkdir -p $f; fi



python /workdir/users/agk85/press/scripts/arg_scripts/arg_org_hic_long_original.py -a 99 -p 99 -f press -d 0 -c /workdir/users/agk85/press/ComboDesign.txt
python /workdir/users/agk85/press/scripts/arg_scripts/arg_org_hic_long_original.py -a 99 -p 99 -f press -d 1 -c /workdir/users/agk85/press/ComboDesign.txt
python /workdir/users/agk85/press/scripts/arg_scripts/arg_org_hic_long_original.py -a 99 -p 99 -f press -d 2 -c /workdir/users/agk85/press/ComboDesign.txt

python /workdir/users/agk85/press/scripts/arg_scripts/arg_org_hic_long_nocorecore.py -a 99 -p 99 -f press -d 0 -c /workdir/users/agk85/press/ComboDesign.txt
python /workdir/users/agk85/press/scripts/arg_scripts/arg_org_hic_long_nocorecore.py -a 99 -p 99 -f press -d 1 -c /workdir/users/agk85/press/ComboDesign.txt
python /workdir/users/agk85/press/scripts/arg_scripts/arg_org_hic_long_nocorecore.py -a 99 -p 99 -f press -d 2 -c /workdir/users/agk85/press/ComboDesign.txt

python /workdir/users/agk85/press/scripts/arg_scripts/arg_org_hic_long_nocorecorenomobilemobile.py -a 99 -p 99 -f press -d 0 -c /workdir/users/agk85/press/ComboDesign.txt
python /workdir/users/agk85/press/scripts/arg_scripts/arg_org_hic_long_nocorecorenomobilemobile.py -a 99 -p 99 -f press -d 1 -c /workdir/users/agk85/press/ComboDesign.txt
python /workdir/users/agk85/press/scripts/arg_scripts/arg_org_hic_long_nocorecorenomobilemobile.py -a 99 -p 99 -f press -d 2 -c /workdir/users/agk85/press/ComboDesign.txt


Rscript /workdir/users/agk85/press/scripts/arg_scripts/arg_org_histograms_taxonomic_levels_no0.R press original 99 99
Rscript /workdir/users/agk85/press/scripts/arg_scripts/arg_org_histograms_taxonomic_levels_no0.R press nocorecore 99 99
Rscript /workdir/users/agk85/press/scripts/arg_scripts/arg_org_histograms_taxonomic_levels_no0.R press nocorecorenomobilemobile 99 99

#python /workdir/users/agk85/press/scripts/arg_scripts/arg_org_hic_cliques_nocorecorenomobilemobile.py -a 99 -p 99 -f press -d 0 -c /workdir/users/agk85/press/ComboDesign.txt
#python /workdir/users/agk85/press/scripts/arg_scripts/arg_org_hic_cliques_nocorecorenomobilemobile.py -a 99 -p 99 -f press -d 1 -c /workdir/users/agk85/press/ComboDesign.txt
python /workdir/users/agk85/press/scripts/arg_scripts/arg_org_hic_cliques_nocorecorenomobilemobile.py -a 99 -p 99 -f press -d 2 -c /workdir/users/agk85/press/ComboDesign.txt

Rscript /workdir/users/agk85/press/scripts/arg_scripts/arg_org_cliques_withefflux.... press nocorecorenomobilemobile 99 99




#flickering
mv /workdir/users/agk85/${FOLDER}/arg_v_org/metagenomes/histograms/nocorecorenomobilemobile/*separated* /workdir/users/agk85/${FOLDER}/arg_v_org/metagenomes/flickering/nocorecorenomobilemobile/

##############################################contamination
mkdir ${WRK}/hic/plotting
#calculate the mismatches
python ~/agk/press/scripts/contamination_bias/hic_org_v_org.py $WRK 99 ${FOLDER}
Rscript ~/agk/press/scripts/contamination_bias/org_v_org_cleanliness.R ${FOLDER} 99


