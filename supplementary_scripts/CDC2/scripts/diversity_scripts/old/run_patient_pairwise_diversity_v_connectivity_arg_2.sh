WRK=/workdir/users/agk85/CDC2

#FILES
CONTACT_THRESH=2
GENE=arg
GENECLUSTER=$WRK/args/args_99_nr.fna.clstr.tbl
SCRIPT=$WRK/scripts/diversity_scripts/patient_pairwise_diversity_v_connectivity.py

CONNECTIONS=$WRK/bins/connections_${GENE}_org_all_${CONTACT_THRESH}.txt
OUTFILE=$WRK/bins/diversity_figures/${GENE}_${CONTACT_THRESH}_patient_pairwise_connection_counts.txt
#GENECLUSTER=$WRK/mobile/metagenomes/mge_99_nr.fna.clstr.tbl
#GENE=mge
echo get relevant gene taxonomies
time python $SCRIPT -c $CONNECTIONS -gc $GENECLUSTER -o $OUTFILE

