for SGE_TASK_ID in 41 45 46 47 60;
do
# Goal is to assess the completeness and contamination of generated scaffolds using checkm
# Important to keep the memory up (over 32 GB) because checkM uses a lot!! 
#
#also if you are redoing, remember to remove output folder: checkm_lineage 

WRK=/workdir/users/agk85/CDC
DESIGN_FILE=$WRK/MetaDesign_all.txt
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

FOLDER=$WRK/maxbin/${NAME}
OUT=$WRK/maxbin/${NAME}/checkm_lineage

 if [ ! -d $OUT ]; then mkdir -p $OUT; fi

LOG=$WRK/maxbin/log/maxbin_$JOB_ID_${NAME}.out

echo start checkm ${NAME} `date` >> $LOG 2>&1

#run checkm
source  /programs/checkm_161011/init
checkm lineage_wf -t 8 -x fasta /workdir/users/agk85/CDC/maxbin/metagenomes3/${NAME} $OUT

#this runs a different version of the QA step to output your quality information...it gets printed to stdout which is weird, so I'm not sure if I'm doing something wrong, but I pipe it into grep to remove the weird lines that are formatting and then into sample.qa
checkm qa -o 2 ${OUT}/lineage.ms $OUT | grep -v '^-' > ${OUT}/${NAME}.qa
checkm bin_qa_plot --image_type pdf -x fasta $OUT $FOLDER plots

#plotting
#checkm coding_plot -x fasta --image_type pdf $OUT $FOLDER plots 50
checkm marker_plot --image_type pdf -x fasta $OUT $FOLDER plots
checkm gc_plot --image_type pdf -x fasta . plots 50


echo end checkm ${NAME} `date` >> $LOG 2>&1
done
