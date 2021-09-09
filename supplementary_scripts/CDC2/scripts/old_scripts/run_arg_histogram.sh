WRK=/workdir/users/agk85/CDC2

CONTACT_THRESH=5
PATIENT=B314
python $WRK/scripts/arg_histogram_prep.py -i ${WRK}/bins/${PATIENT}-1_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-2_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-3_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-4_das_2_contigs_v_bins.txt -o ${WRK}/bins/${PATIENT}_das_${CONTACT_THRESH}_argtaxa.txt -a ${WRK}/args/args_99_nr.fna.clstr.tbl -p ${PATIENT} -c ${CONTACT_THRESH}
python $WRK/scripts/arg_histogram_prep.py -i ${WRK}/bins/${PATIENT}-1_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-2_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-3_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-4_network_${CONTACT_THRESH}_contigs_v_bins.txt -o ${WRK}/bins/${PATIENT}_network_${CONTACT_THRESH}_argtaxa.txt -a ${WRK}/args/args_99_nr.fna.clstr.tbl -p ${PATIENT} -c ${CONTACT_THRESH}
Rscript $WRK/scripts/histogram_arg_plotting.R $WRK/bins/${PATIENT}_das_${CONTACT_THRESH}_argtaxa.txt $WRK/bins/${PATIENT}_network_${CONTACT_THRESH}_argtaxa.txt 


PATIENT=B316
python $WRK/scripts/arg_histogram_prep.py -i ${WRK}/bins/${PATIENT}-1_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-2_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-3_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-4_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-5_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-6_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-7_das_2_contigs_v_bins.txt -o ${WRK}/bins/${PATIENT}_das_${CONTACT_THRESH}_argtaxa.txt -a ${WRK}/args/args_99_nr.fna.clstr.tbl -p ${PATIENT} -c ${CONTACT_THRESH}
python $WRK/scripts/arg_histogram_prep.py -i ${WRK}/bins/${PATIENT}-1_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-2_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-3_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-4_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-5_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-6_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-7_network_${CONTACT_THRESH}_contigs_v_bins.txt -o ${WRK}/bins/${PATIENT}_network_${CONTACT_THRESH}_argtaxa.txt -a ${WRK}/args/args_99_nr.fna.clstr.tbl -p ${PATIENT} -c ${CONTACT_THRESH}
Rscript $WRK/scripts/histogram_arg_plotting.R $WRK/bins/${PATIENT}_das_${CONTACT_THRESH}_argtaxa.txt $WRK/bins/${PATIENT}_network_${CONTACT_THRESH}_argtaxa.txt 


PATIENT=B320
python $WRK/scripts/arg_histogram_prep.py -i ${WRK}/bins/${PATIENT}-1_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-2_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-3_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-5_das_2_contigs_v_bins.txt -o ${WRK}/bins/${PATIENT}_das_${CONTACT_THRESH}_argtaxa.txt -a ${WRK}/args/args_99_nr.fna.clstr.tbl -p ${PATIENT} -c ${CONTACT_THRESH}
python $WRK/scripts/arg_histogram_prep.py -i ${WRK}/bins/${PATIENT}-1_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-2_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-3_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-5_network_${CONTACT_THRESH}_contigs_v_bins.txt -o ${WRK}/bins/${PATIENT}_network_${CONTACT_THRESH}_argtaxa.txt -a ${WRK}/args/args_99_nr.fna.clstr.tbl -p ${PATIENT} -c ${CONTACT_THRESH}
Rscript $WRK/scripts/histogram_arg_plotting.R $WRK/bins/${PATIENT}_das_${CONTACT_THRESH}_argtaxa.txt $WRK/bins/${PATIENT}_network_${CONTACT_THRESH}_argtaxa.txt 


PATIENT=B331
python $WRK/scripts/arg_histogram_prep.py -i ${WRK}/bins/${PATIENT}-1_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-2_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-3_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-4_das_2_contigs_v_bins.txt -o ${WRK}/bins/${PATIENT}_das_${CONTACT_THRESH}_argtaxa.txt -a ${WRK}/args/args_99_nr.fna.clstr.tbl -p ${PATIENT} -c ${CONTACT_THRESH}
python $WRK/scripts/arg_histogram_prep.py -i ${WRK}/bins/${PATIENT}-1_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-2_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-3_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-4_network_${CONTACT_THRESH}_contigs_v_bins.txt -o ${WRK}/bins/${PATIENT}_network_${CONTACT_THRESH}_argtaxa.txt -a ${WRK}/args/args_99_nr.fna.clstr.tbl -p ${PATIENT} -c ${CONTACT_THRESH}
Rscript $WRK/scripts/histogram_arg_plotting.R $WRK/bins/${PATIENT}_das_${CONTACT_THRESH}_argtaxa.txt $WRK/bins/${PATIENT}_network_${CONTACT_THRESH}_argtaxa.txt 

PATIENT=B335
python $WRK/scripts/arg_histogram_prep.py -i ${WRK}/bins/${PATIENT}-1_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-2_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-3_das_2_contigs_v_bins.txt -o ${WRK}/bins/${PATIENT}_das_${CONTACT_THRESH}_argtaxa.txt -a ${WRK}/args/args_99_nr.fna.clstr.tbl -p ${PATIENT} -c ${CONTACT_THRESH}
python $WRK/scripts/arg_histogram_prep.py -i ${WRK}/bins/${PATIENT}-1_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-2_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-3_network_${CONTACT_THRESH}_contigs_v_bins.txt -o ${WRK}/bins/${PATIENT}_network_${CONTACT_THRESH}_argtaxa.txt -a ${WRK}/args/args_99_nr.fna.clstr.tbl -p ${PATIENT} -c ${CONTACT_THRESH}
Rscript $WRK/scripts/histogram_arg_plotting.R $WRK/bins/${PATIENT}_das_${CONTACT_THRESH}_argtaxa.txt $WRK/bins/${PATIENT}_network_${CONTACT_THRESH}_argtaxa.txt 

PATIENT=B357
python $WRK/scripts/arg_histogram_prep.py -i ${WRK}/bins/${PATIENT}-1_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-2_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-3_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-4_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-5_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-6_das_2_contigs_v_bins.txt -o ${WRK}/bins/${PATIENT}_das_${CONTACT_THRESH}_argtaxa.txt -a ${WRK}/args/args_99_nr.fna.clstr.tbl -p ${PATIENT} -c ${CONTACT_THRESH}
python $WRK/scripts/arg_histogram_prep.py -i ${WRK}/bins/${PATIENT}-1_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-2_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-3_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-4_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-5_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-6_network_${CONTACT_THRESH}_contigs_v_bins.txt -o ${WRK}/bins/${PATIENT}_network_${CONTACT_THRESH}_argtaxa.txt -a ${WRK}/args/args_99_nr.fna.clstr.tbl -p ${PATIENT} -c ${CONTACT_THRESH}
Rscript $WRK/scripts/histogram_arg_plotting.R $WRK/bins/${PATIENT}_das_${CONTACT_THRESH}_argtaxa.txt $WRK/bins/${PATIENT}_network_${CONTACT_THRESH}_argtaxa.txt 

PATIENT=B370
python $WRK/scripts/arg_histogram_prep.py -i ${WRK}/bins/${PATIENT}-1_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-2_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-3_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-4_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-5_das_2_contigs_v_bins.txt -o ${WRK}/bins/${PATIENT}_das_${CONTACT_THRESH}_argtaxa.txt -a ${WRK}/args/args_99_nr.fna.clstr.tbl -p ${PATIENT} -c ${CONTACT_THRESH}
python $WRK/scripts/arg_histogram_prep.py -i ${WRK}/bins/${PATIENT}-1_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-2_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-3_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-4_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-5_network_${CONTACT_THRESH}_contigs_v_bins.txt -o ${WRK}/bins/${PATIENT}_network_${CONTACT_THRESH}_argtaxa.txt -a ${WRK}/args/args_99_nr.fna.clstr.tbl -p ${PATIENT} -c ${CONTACT_THRESH}
Rscript $WRK/scripts/histogram_arg_plotting.R $WRK/bins/${PATIENT}_das_${CONTACT_THRESH}_argtaxa.txt $WRK/bins/${PATIENT}_network_${CONTACT_THRESH}_argtaxa.txt 


PATIENT=US3
python $WRK/scripts/arg_histogram_prep.py -i ${WRK}/bins/${PATIENT}-8_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-10_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-12_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-14_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-16_das_2_contigs_v_bins.txt -o ${WRK}/bins/${PATIENT}_das_${CONTACT_THRESH}_argtaxa.txt -a ${WRK}/args/args_99_nr.fna.clstr.tbl -p ${PATIENT} -c ${CONTACT_THRESH}
python $WRK/scripts/arg_histogram_prep.py -i ${WRK}/bins/${PATIENT}-8_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-10_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-12_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-14_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-16_network_${CONTACT_THRESH}_contigs_v_bins.txt -o ${WRK}/bins/${PATIENT}_network_${CONTACT_THRESH}_argtaxa.txt -a ${WRK}/args/args_99_nr.fna.clstr.tbl -p ${PATIENT} -c ${CONTACT_THRESH}
Rscript $WRK/scripts/histogram_arg_plotting.R $WRK/bins/${PATIENT}_das_${CONTACT_THRESH}_argtaxa.txt $WRK/bins/${PATIENT}_network_${CONTACT_THRESH}_argtaxa.txt 


PATIENT=US8
python $WRK/scripts/arg_histogram_prep.py -i ${WRK}/bins/${PATIENT}-1_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-2_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-3_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-4_das_2_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-5_das_2_contigs_v_bins.txt -o ${WRK}/bins/${PATIENT}_das_${CONTACT_THRESH}_argtaxa.txt -a ${WRK}/args/args_99_nr.fna.clstr.tbl -p ${PATIENT} -c ${CONTACT_THRESH}
python $WRK/scripts/arg_histogram_prep.py -i ${WRK}/bins/${PATIENT}-1_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-2_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-3_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-4_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/${PATIENT}-5_network_${CONTACT_THRESH}_contigs_v_bins.txt -o ${WRK}/bins/${PATIENT}_network_${CONTACT_THRESH}_argtaxa.txt -a ${WRK}/args/args_99_nr.fna.clstr.tbl -p ${PATIENT} -c ${CONTACT_THRESH}
Rscript $WRK/scripts/histogram_arg_plotting.R $WRK/bins/${PATIENT}_das_${CONTACT_THRESH}_argtaxa.txt $WRK/bins/${PATIENT}_network_${CONTACT_THRESH}_argtaxa.txt 


#################

PATIENT=all
python $WRK/scripts/arg_histogram_prep.py \
-i ${WRK}/bins/B314-1_das_2_contigs_v_bins.txt,${WRK}/bins/B314-2_das_2_contigs_v_bins.txt,${WRK}/bins/B314-3_das_2_contigs_v_bins.txt,${WRK}/bins/B314-4_das_2_contigs_v_bins.txt,${WRK}/bins/B316-1_das_2_contigs_v_bins.txt,${WRK}/bins/B316-2_das_2_contigs_v_bins.txt,${WRK}/bins/B316-3_das_2_contigs_v_bins.txt,${WRK}/bins/B316-4_das_2_contigs_v_bins.txt,${WRK}/bins/B316-5_das_2_contigs_v_bins.txt,${WRK}/bins/B316-6_das_2_contigs_v_bins.txt,${WRK}/bins/B316-7_das_2_contigs_v_bins.txt,${WRK}/bins/B320-1_das_2_contigs_v_bins.txt,${WRK}/bins/B320-2_das_2_contigs_v_bins.txt,${WRK}/bins/B320-3_das_2_contigs_v_bins.txt,${WRK}/bins/B320-5_das_2_contigs_v_bins.txt,${WRK}/bins/B331-1_das_2_contigs_v_bins.txt,${WRK}/bins/B331-2_das_2_contigs_v_bins.txt,${WRK}/bins/B331-3_das_2_contigs_v_bins.txt,${WRK}/bins/B331-4_das_2_contigs_v_bins.txt,${WRK}/bins/B335-1_das_2_contigs_v_bins.txt,${WRK}/bins/B335-2_das_2_contigs_v_bins.txt,${WRK}/bins/B335-3_das_2_contigs_v_bins.txt,${WRK}/bins/B357-1_das_2_contigs_v_bins.txt,${WRK}/bins/B357-2_das_2_contigs_v_bins.txt,${WRK}/bins/B357-3_das_2_contigs_v_bins.txt,${WRK}/bins/B357-4_das_2_contigs_v_bins.txt,${WRK}/bins/B357-5_das_2_contigs_v_bins.txt,${WRK}/bins/B357-6_das_2_contigs_v_bins.txt,${WRK}/bins/B370-1_das_2_contigs_v_bins.txt,${WRK}/bins/B370-2_das_2_contigs_v_bins.txt,${WRK}/bins/B370-3_das_2_contigs_v_bins.txt,${WRK}/bins/B370-4_das_2_contigs_v_bins.txt,${WRK}/bins/B370-5_das_2_contigs_v_bins.txt,${WRK}/bins/US3-8_das_2_contigs_v_bins.txt,${WRK}/bins/US3-10_das_2_contigs_v_bins.txt,${WRK}/bins/US3-12_das_2_contigs_v_bins.txt,${WRK}/bins/US3-14_das_2_contigs_v_bins.txt,${WRK}/bins/US3-16_das_2_contigs_v_bins.txt,${WRK}/bins/US8-1_das_2_contigs_v_bins.txt,${WRK}/bins/US8-2_das_2_contigs_v_bins.txt,${WRK}/bins/US8-3_das_2_contigs_v_bins.txt,${WRK}/bins/US8-4_das_2_contigs_v_bins.txt,${WRK}/bins/US8-5_das_2_contigs_v_bins.txt \
-a ${WRK}/args/args_99_nr.fna.clstr.tbl -p all -c ${CONTACT_THRESH} \
-o ${WRK}/bins/all_das_${CONTACT_THRESH}_argtaxa.txt

python $WRK/scripts/arg_histogram_prep.py \
-i ${WRK}/bins/B314-1_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B314-2_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B314-3_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B314-4_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B316-1_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B316-2_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B316-3_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B316-4_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B316-5_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B316-6_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B316-7_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B320-1_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B320-2_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B320-3_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B320-5_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B331-1_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B331-2_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B331-3_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B331-4_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B335-1_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B335-2_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B335-3_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B357-1_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B357-2_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B357-3_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B357-4_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B357-5_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B357-6_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B370-1_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B370-2_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B370-3_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B370-4_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/B370-5_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/US3-8_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/US3-10_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/US3-12_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/US3-14_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/US3-16_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/US8-1_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/US8-2_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/US8-3_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/US8-4_network_${CONTACT_THRESH}_contigs_v_bins.txt,${WRK}/bins/US8-5_network_${CONTACT_THRESH}_contigs_v_bins.txt \
-a ${WRK}/args/args_99_nr.fna.clstr.tbl -p ${PATIENT} -c ${CONTACT_THRESH} \
-o ${WRK}/bins/${PATIENT}_network_${CONTACT_THRESH}_argtaxa.txt

Rscript $WRK/scripts/histogram_arg_plotting.R $WRK/bins/${PATIENT}_das_${CONTACT_THRESH}_argtaxa.txt $WRK/bins/${PATIENT}_network_${CONTACT_THRESH}_argtaxa.txt 


cd  $WRK/bins

head -1 Numbers_${CONTACT_THRESH}_B314.txt > ARG_histogram_numbers_${CONTACT_THRESH}.txt
tail -n +2 -q Numbers*.txt >> ARG_histogram_numbers_${CONTACT_THRESH}.txt

head -1 Taxa_Count_Numbers_${CONTACT_THRESH}_B314.txt > ARG_histogram_taxa_count_numbers_${CONTACT_THRESH}.txt
tail -n +2 -q Taxa_Count_Numbers*.txt >> ARG_histogram_taxa_count_numbers_${CONTACT_THRESH}.txt

head -1 Metrics_${CONTACT_THRESH}_B314.txt > ARG_histogram_metrics_${CONTACT_THRESH}.txt
tail -n +2 -q Metrics*.txt >> ARG_histogram_metrics_${CONTACT_THRESH}.txt


head -1 ${PATIENT}_das_${CONTACT_THRESH}_argtaxa.txt > Together_das_${CONTACT_THRESH}_argtaxa_together.txt
tail -n +2 -q *_das_${CONTACT_THRESH}_argtaxa.txt >> Together_das_${CONTACT_THRESH}_argtaxa_together.txt



