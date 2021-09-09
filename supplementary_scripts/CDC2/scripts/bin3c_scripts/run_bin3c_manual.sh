for SGE_TASK_ID in {1..44};
do
WRK=/workdir/users/agk85/CDC2
DESIGN_FILE=$WRK/MetaDesign.txt #changed from rerun
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`


echo bin3C ${NAME} `date`

OUT=$WRK/bin3c/${NAME}
if [ ! -d $OUT ]; then mkdir -p $OUT; fi
cd $OUT

#hic reads
DATA=/workdir/data/CDC/hic/merged
R1=$DATA/${NAME}hic.1.fastq
R2=$DATA/${NAME}hic.2.fastq

/workdir/users/agk85/tools/bwa/bwa mem -5SP -t 20 $WRK/hic/mapping/references/${NAME}_scaffold $R1 $R2 > ${OUT}/${NAME}_hic2ctg_unsorted.sam

samtools view -@ 30 -F 0x904 -bh ${OUT}/${NAME}_hic2ctg_unsorted.sam > ${OUT}/${NAME}_hic2ctg_unsorted_nss.bam
samtools sort -@ 30 -n -o ${OUT}/${NAME}_hic2ctg_sorted_nss.bam ${OUT}/${NAME}_hic2ctg_unsorted_nss.bam
#--min-mapq 30

~/agk/bin3C/bin/python2 ~/agk/bin3C/bin3C.py mkmap -e DpnII  --min-signal 2 -v $WRK/prodigal_excise/metagenomes/${NAME}/${NAME}_scaffold.fasta ${OUT}/${NAME}_hic2ctg_sorted_nss.bam $WRK/bin3c/${NAME}/${NAME}_bin3c_out

~/agk/bin3C/bin/python2 ~/agk/bin3C/bin3C.py cluster --min-signal 2 -v ${OUT}/${NAME}_bin3c_out/contact_map.p.gz ${OUT}/${NAME}_bin3c_clust
echo finished $NAME

${OUT}/${NAME}_bin3c_clust/cluster_plot.png ${OUT}/${NAME}_bin3c_clust/${NAME}_cluster_plot.png
done
