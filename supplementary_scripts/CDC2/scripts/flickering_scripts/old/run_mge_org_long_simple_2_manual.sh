WRK=/workdir/users/agk85/CDC2

#FILES
CONTACT_THRESH=2
SCRIPT=$WRK/scripts/flickering_scripts/mge_org_long_simple.py

CVB=$WRK/bins/all_das_1_contigs_v_bins_all.txt
BINTABLE=$WRK/das/all_bintables.txt
CHECKM=$WRK/das/all.stats
GENECLUSTER=$WRK/args/args_99_nr.fna.clstr.tbl
GENE=arg
#GENECLUSTER=$WRK/mobile/metagenomes/mge_99_nr.fna.clstr.tbl
#GENE=mge
time python $SCRIPT -b $BINTABLE -i $CVB -m $CONTACT_THRESH -c $CHECKM -gc $GENECLUSTER -g $GENE


#FILES
CONTACT_THRESH=5
time python $SCRIPT -b $BINTABLE -i $CVB -m $CONTACT_THRESH -c $CHECKM -gc $GENECLUSTER -g $GENE


#FILES
CONTACT_THRESH=5
GENECLUSTER=$WRK/mobile/metagenomes/mge_99_nr.fna.clstr.tbl
GENE=mge
time python $SCRIPT -b $BINTABLE -i $CVB -m $CONTACT_THRESH -c $CHECKM -gc $GENECLUSTER -g $GENE


time CONTACT_THRESH=5
python $SCRIPT -b $BINTABLE -i $CVB -m $CONTACT_THRESH -c $CHECKM -gc $GENECLUSTER -g $GENE

