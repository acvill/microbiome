run prodigal_min_phage

run prodigal_identify_phage
run prodigal_identify_trnascan_phage
#keep tabs on things to make sure everything runs properly
#make sure that isescan has its cluster files in the right folder
#when it gets past gene identification
run cd_hit 
run snake_index
run snake_bwa
run snake_indexhic
run snake_bwahic

#afte

run run_master_scf_hic.sh


