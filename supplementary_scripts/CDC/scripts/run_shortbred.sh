#$ -S /bin/bash
#$ -N CDC_shortbred
#$ -o /workdir/users/agk85/CDC/shortbred/log
#$ -e /workdir/users/agk85/CDC/shortbred/err
#$ -pe parenv 4
#$ -l h_vmem=4G
#$ -q short.q@cbsubrito2
#$ -t 1-88

WRK=/workdir/users/agk85/CDC
SAMPLELIST=${WRK}/MetaDesign_all.txt
SAMPLE=$(head -n $SGE_TASK_ID $SAMPLELIST | tail -n 1)

DIR=/workdir/data/CDC/metagenomes/merged/unzip
cd ${DIR}
OUTDIR=${WRK}/shortbred/metagenomes2
TEMPDIR=${OUTDIR}/${SAMPLE}_TEMP
mkdir $TEMPDIR

################# SHORTBRED ######################
export PATH=/programs/shortbred_0.9.5:/programs/usearch10.0.240:/programs/diamond-0.8.34:/programs/cd-hit-v4.6.1-2012-08-27:/programs/muscle:$PATH
SHORTBRED=/programs/shortbred_0.9.5/shortbred_quantify.py
MARKERS=/programs/shortbred_0.9.5/sample_markers/ShortBRED_ABR_150bp_markers.faa

F=${DIR}/${SAMPLE}.1.fastq
R=${DIR}/${SAMPLE}.2.fastq
# FS=${DIR}/${SAMPLE}.1.solo.fastq
# RS=${DIR}/${SAMPLE}.2.solo.fastq

echo started shortbred `date` $SAMPLE

python $SHORTBRED --markers $MARKERS --wgs $F $R --results ${OUTDIR}/${SAMPLE}.shortbred.results --tmp $TEMPDIR --threads 4


echo finished shortbred `date` $SAMPLE
