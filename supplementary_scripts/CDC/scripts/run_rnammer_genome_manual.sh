for SGE_TASK_ID in {1..2};
do
#Set dirs
WRK=/workdir/users/agk85/CDC
OUTDIR=$WRK/spades/round12 ## output
#Create design file of file names
DESIGN_FILE=$WRK/GenomeDesign_r12.txt  #Your list of file names
NAME=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
SCF=${OUTDIR}/${NAME}/${NAME}_scaffold_min_500.fasta ##Location of your assembly scaffolds.fasta

################# RNAMMER ####################
RNAMMER=/programs/rnammer-1.2/rnammer

echo $NAME RNAMMER start

perl $RNAMMER -S bac -m ssu -f ${OUTDIR}/16S/${NAME}.16S.fasta $SCF

/programs/ncbi-blast-2.3.0+/bin/blastn -query ${OUTDIR}/16S/${NAME}.16S.fasta -db /workdir/users/agk85/CDC/rnammer/gg_13_5_db -out ${OUTDIR}/16S/${NAME}.16S.fasta.out -num_threads 1 -outfmt 6       
sort -k1,1 -k12,12gr -k11,11g -k3,3gr ${OUTDIR}/16S/${NAME}.16S.fasta.out | sort -u -k1,1 --merge > ${OUTDIR}/16S/${NAME}.16S.fasta.out.best


echo $NAME RNAMMER complete

done
