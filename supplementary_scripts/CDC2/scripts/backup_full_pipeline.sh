####QC SECTION####

####ASSEMBLY SECTION####

####ANNOTATION SECTION####

####BINNING SECTION####

####KRAKEN SECTION####

####NETWORK SECTION####
#so we scrapped this but idk what I actually need for some programs

####CLEANLINESS SECTION####

####ARG SECTION####

####MGE SECTION####
#this grabs all of the mobile genes from all of the different sources including contigs--wraps over the whole contig and grabs all the genes
qsub run_protseqs_ofinterest.sh
#cat all of the fnas into mobile_genes.fn
cat ~/agk/CDC2/mobile/metagenomes/*_mge.fna > ~/agk/CDC2/mobile/metagenomes/mobile_proteins.fna

#cd-hit
bash ~/agk/CDC2/scripts/mge_scripts/run_cdhit_all.sh

#get the cd-hit table
python ~/agk/CDC2/scripts/mge_scripts/cdhit_output_to_table.py CDC2

#get all of the gene_ids
grep '>' ~/agk/CDC2/mobile/metagenomes/mobile_proteins.fna > ~/agk/CDC2/mobile/metagenomes/gene_ids.txt
python ~/agk/CDC2/scripts/mge_scripts/grab_mge_info.py CDC2
sed -i -e "s/'/ prime/g" ~/agk/CDC2/mobile/metagenomes/mge_95_nr.fna.clstr.desc # to make sure the primes are not disrupting R


#prepare machinery genes
#cat ~/agk/CDC2/hicpro/output/*_output/hic_results/data/*/*_trans_primary_0_ncol_withexcise_noeuks.txt > ~/agk/CDC2/mobile/metagenomes/CDC+healthy_trans_primary_ncol_0_withexcise_noeuks.txt

####missing 
#get samples
#


#####HISTOGRAM SECTION#####
#WARNING# I think this is currently outputting in bins2 so change that back at some point
qsub /workdir/users/agk85/CDC2/histogram_scripts/run_contig_vs_bin_das1.sh
#alternatives
#screen bash run_contig_vs_bin_das1_manual.sh
#screen bash run_contig_vs_bin_das1_single.sh 2 #or whatever number of interest

#if you want to keep track of the overlap (so if the hic supports the cluster, but is not a 
qsub /workdir/users/agk85/CDC2/histogram_scripts/run_contig_vs_bin_das1_hicsupport.sh
##then what do you want to do with it?
##some sort of metric---2 and 5, what proportion of contigs 

#screen
#15s, 20s, 9 minutes, 9 minutes
time bash /workdir/users/agk85/CDC2/scripts/histogram_scripts/run_arg_histogram_das2.sh
time bash /workdir/users/agk85/CDC2/scripts/histogram_scripts/run_arg_histogram_das5.sh
time bash /workdir/users/agk85/CDC2/scripts/histogram_scripts/run_mge_histogram_das2.sh
time bash /workdir/users/agk85/CDC2/scripts/histogram_scripts/run_mge_histogram_das5.sh

#plotting the histograms laid out
#screen 6s for each arg, 4-5 min for each mge
bash ~/agk/CDC2/scripts/histogram_scripts/run_histogram_plotting.sh
#plotting stacked
#screen args 7 sec, mges 4-5 min (4 of each arg/mge * 2/5 * 1+/2+ = 8 options)
bash ~/agk/CDC2/scripts/histogram_scripts/run_histogram_stacked_plotting.sh


####ORG ORG NETWORK SECTION####

#This makes the bintables in the das folder
bash ~/agk/CDC2/scripts/org_org_scripts/run_make_bin_table.sh
#this gets the lists of taxa that are in the bins
bash ~/agk/CDC2/scripts/org_org_scripts/get_bin_taxa.sh

bash ~/agk/CDC2/scripts/org_org_scripts/run_taxa_taxa_prep.sh

OUT=/workdir/users/agk85/CDC2/bins/org_org_figures
if [ ! -d $OUT ]; then mkdir -p $OUT; fi
#
mv  ~/agk/CDC2/bins/Org_org*.pdf $OUT
#copy them to bring down
cp ${OUT}/*.pdf ~/CDC_figures/org_org


####JACCARD####
#this is a kindcp *.pdf ~/CDC_figures/subsamplingcp *.pdf ~/CDC_figures/subsamplingcp *.pdf ~/CDC_figures/subsamplingcp *.pdf ~/CDC_figures/subsamplingcp *.pdf ~/CDC_figures/subsampling of hacked way of getting at organism abundance and connections
#seconds
Rscript ~/agk/CDC2/scripts/org_org_scripts/plotting_metaphlan_jaccard.R
Rscript ~/agk/CDC2/scripts/org_org_scripts/plotting_taxa_taxa_jaccard.R /workdir/users/agk85/CDC2/bins/arg_das_2_taxa_taxa_counts.txt 2 arg
Rscript ~/agk/CDC2/scripts/org_org_scripts/plotting_taxa_taxa_jaccard.R /workdir/users/agk85/CDC2/bins/arg_das_5_taxa_taxa_counts.txt 5 arg
Rscript ~/agk/CDC2/scripts/org_org_scripts/plotting_taxa_taxa_jaccard.R /workdir/users/agk85/CDC2/bins/mge_das_2_taxa_taxa_counts.txt 2 mge
Rscript ~/agk/CDC2/scripts/org_org_scripts/plotting_taxa_taxa_jaccard.R /workdir/users/agk85/CDC2/bins/mge_das_5_taxa_taxa_counts.txt 5 mge

#move them to the distance folder

OUT=/workdir/users/agk85/CDC2/bins/distance_figures
if [ ! -d $OUT ]; then mkdir -p $OUT; fi
mv ~/agk/CDC2/bins/*distance*.pdf $OUT
#copy them to bring down 
cp ${OUT}/*distance*.pdf ~/CDC_figures/distance


####LINELISTS##### #prep for heatmaps
#6seconds
time python ~/agk/CDC2/scripts/histogram_scripts/linelists.py 

cat ~/agk/CDC2/bins/*_das_2_argtaxa_linelist.txt > ~/agk/CDC2/bins/Together_das_2_argtaxa_linelist.txt
cat ~/agk/CDC2/bins/*_das_5_argtaxa_linelist.txt > ~/agk/CDC2/bins/Together_das_5_argtaxa_linelist.txt
cat ~/agk/CDC2/bins/*_das_2_mgetaxa_linelist.txt > ~/agk/CDC2/bins/Together_das_2_mgetaxa_linelist.txt
cat ~/agk/CDC2/bins/*_das_5_mgetaxa_linelist.txt > ~/agk/CDC2/bins/Together_das_5_mgetaxa_linelist.txt

cut -f1,2,3,4,6,7,8,9 ~/agk/CDC2/bins/Together_das_2_argtaxa_linelist.txt | sort | uniq | cut -f 1,3,4,5,6,7,8 | sort | uniq -c | sed 's/; /;/g' | sed "s/^[ \t]*//" | sed '0,/\\ /{s/\ /\t/}' > ~/agk/CDC2/bins/Together_das_2_argtaxa_patientcount.txt
cut -f1,2,3,4,6,7,8,9 ~/agk/CDC2/bins/Together_das_5_argtaxa_linelist.txt | sort | uniq | cut -f 1,3,4,5,6,7,8 | sort | uniq -c | sed 's/; /;/g' | sed "s/^[ \t]*//" | sed '0,/\\ /{s/\ /\t/}'> ~/agk/CDC2/bins/Together_das_5_argtaxa_patientcount.txt
cut -f1,2,3,4,6,7,8,9 ~/agk/CDC2/bins/Together_das_2_mgetaxa_linelist.txt | sort | uniq | cut -f 1,3,4,5,6,7,8 | sort | uniq -c | sed 's/; /;/g' | sed "s/^[ \t]*//" | sed '0,/\\ /{s/\ /\t/}'> ~/agk/CDC2/bins/Together_das_2_mgetaxa_patientcount.txt
cut -f1,2,3,4,6,7,8,9 ~/agk/CDC2/bins/Together_das_5_mgetaxa_linelist.txt | sort | uniq | cut -f 1,3,4,5,6,7,8 | sort | uniq -c | sed 's/; /;/g' | sed "s/^[ \t]*//" | sed '0,/\\ /{s/\ /\t/}'> ~/agk/CDC2/bins/Together_das_5_mgetaxa_patientcount.txt

#heatmap

Rscript ~/agk/CDC2/scripts/arg_scripts/heatmaps_patientshare.R arg 2 Together_das_2_argtaxa_patientcount.txt
Rscript ~/agk/CDC2/scripts/arg_scripts/heatmaps_patientshare.R arg 5 Together_das_5_argtaxa_patientcount.txt
Rscript ~/agk/CDC2/scripts/arg_scripts/heatmaps_patientshare.R mge 2 Together_das_2_mgetaxa_patientcount.txt
Rscript ~/agk/CDC2/scripts/arg_scripts/heatmaps_patientshare.R mge 5 Together_das_5_mgetaxa_patientcount.txt

cp ~/agk/CDC2/bins/heatmap_patientshare_* ~/CDC_figures/heatmaps

####HEATMAP_MINPATIENTS####

Rscript ~/agk/CDC2/scripts/arg_scripts/heatmaps_patientshare_iterate.R arg 2 4 Together_das_2_argtaxa_patientcount.txt
Rscript ~/agk/CDC2/scripts/arg_scripts/heatmaps_patientshare_iterate.R arg 5 4 Together_das_5_argtaxa_patientcount.txt
Rscript ~/agk/CDC2/scripts/arg_scripts/heatmaps_patientshare_iterate.R mge 2 4 Together_das_2_mgetaxa_patientcount.txt
Rscript ~/agk/CDC2/scripts/arg_scripts/heatmaps_patientshare_iterate.R mge 5 4 Together_das_5_mgetaxa_patientcount.txt

cp ~/agk/CDC2/bins/heatmap_patientshare_* ~/CDC_figures/heatmaps



####FLICKERING####
#this is the all together metric from long ago
OUT=/workdir/users/agk85/CDC2/bins/flickering
if [ ! -d $OUT ]; then mkdir -p $OUT; fi
#4 seconds and 12 seconds for arg/mge
bash ~/agk/CDC2/scripts/flickering_scripts/run_flickering_arg_2.sh
bash ~/agk/CDC2/scripts/flickering_scripts/run_flickering_arg_5.sh
bash ~/agk/CDC2/scripts/flickering_scripts/run_flickering_mge_2.sh
bash ~/agk/CDC2/scripts/flickering_scripts/run_flickering_mge_5.sh

#combine all four schemes
head -1 ${OUT}/arg_org_flickering_all_2.txt > ${OUT}/flickering.txt
tail -n +2 -q ${OUT}/*_org_flickering_all_*.txt >> ${OUT}/flickering.txt

Rscript ~/agk/CDC2/scripts/flickering_scripts/gene_flickering.R

####SUBSAMPLING####
#this one does the python script
qsub ~/agk/CDC2/scripts/subsampling_scripts/run_subsampling.sh
#once it finishes then you can run:
bash ~/agk/CDC2/scripts/subsampling_scripts/run_subsampling_combine.sh

#to get it down
cp ~/agk/CDC2/resampling/*.pdf ~/CDC_figures/subsampling

####SUPPORT####
#how many connections are supported by hic
#how many trans reads support bins

qsub ~/agk/CDC2/scripts/supportive_scripts/run_contig_vs_bin_das1_hicsupport.sh
#run this later
#TODO #strted this 10/21/2019 ealry morning
qsub ~/agk/CDC2/scripts/supportive_scripts/run_count_trans_binsupport.sh

bash ~/agk/CDC2/scripts/supportive_scripts/run_supportive.sh
#This is included in run_supportive.sh
#Rscript ~/agk/CDC2/scripts/supportive_scripts/plotting_support.R

#move it to the main folder
cp ~/agk/CDC2/bins_hicsupport/hic_support_*__.pdf ~/CDC_figures/hic_support
####TIMELAPSE####

OUT=/workdir/users/agk85/CDC2/bins/timelapse
if [ ! -d $OUT ]; then mkdir -p $OUT; fi
bash ~/agk/CDC2/scripts/timelapse_scripts/run_connections_arg_2.sh
bash ~/agk/CDC2/scripts/timelapse_scripts/run_connections_arg_5.sh
bash ~/agk/CDC2/scripts/timelapse_scripts/run_connections_mge_2.sh
bash ~/agk/CDC2/scripts/timelapse_scripts/run_connections_mge_5.sh

bash ~/agk/CDC2/scripts/timelapse_scripts/run_timelapse_arg_2.sh
bash ~/agk/CDC2/scripts/timelapse_scripts/run_timelapse_arg_5.sh
bash ~/agk/CDC2/scripts/timelapse_scripts/run_timelapse_mge_2.sh
bash ~/agk/CDC2/scripts/timelapse_scripts/run_timelapse_mge_5.sh

cp $OUT/*.pdf ~/CDC_figures/timelapse


####MIN DIST####
#Still in progress, can't figure out the numbers)
[
time python ~/agk/CDC2/scripts/arg_scripts/min_genedist_to_hicread.py 2 arg
time python ~/agk/CDC2/scripts/arg_scripts/min_genedist_to_hicread.py 5 arg
time python ~/agk/CDC2/scripts/arg_scripts/min_genedist_to_hicread.py 2 mge
time python ~/agk/CDC2/scripts/arg_scripts/min_genedist_to_hicread.py 5 mge

Rscript ~/agk/CDC2/scripts/arg_scripts/min_genedist_to_hicread_plotting.R 2 arg
Rscript ~/agk/CDC2/scripts/arg_scripts/min_genedist_to_hicread_plotting.R 5 arg
Rscript ~/agk/CDC2/scripts/arg_scripts/min_genedist_to_hicread_plotting.R 2 mge
Rscript ~/agk/CDC2/scripts/arg_scripts/min_genedist_to_hicread_plotting.R 5 mge
cp ~/agk/CDC2/args/min_dist/*.pdf ~/CDC_figures/min_dist



####HGT_COMPARISON####
OUT=/workdir/users/agk85/CDC2/bins/hgt_comparisons
if [ ! -d $OUT ]; then mkdir -p $OUT; fi
#first two 1.5 min
time bash ~/agk/CDC2/scripts/hgt_scripts/run_hgt_comparisons_arg_2.sh
time bash ~/agk/CDC2/scripts/hgt_scripts/run_hgt_comparisons_arg_5.sh

#these take forever put them in a screen unless you deal with list lookup
time bash ~/agk/CDC2/scripts/hgt_scripts/run_hgt_comparisons_mge_2.sh
time bash ~/agk/CDC2/scripts/hgt_scripts/run_hgt_comparisons_mge_5.sh

####READ_DISTRIBUTIONS
python ~/agk/CDC2/scripts/read_distribution_scripts/hic_scatterplots.py
Rscript ~/agk/CDC2/scripts/read_distribution_scripts/hic_length_abundance_plotting.R
cp ~/agk/CDC2/read_distributions/*.pdf ~/CDC_figures/read_distributions


####ENTEROS####
Rscript ~/agk/CDC2/scripts/enteros_scripts/arg_enterobacteriacaeae.R
cp ~/agk/CDC2/args/enteros/ARG_enterobacteriaceae.pdf ~/CDC_figures/enteros
