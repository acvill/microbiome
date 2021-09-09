#$ -S /bin/bash
#$ -N isescan
#$ -V 
#$ -o /workdir/users/agk85/tools/ISEScan/log
#$ -e /workdir/users/agk85/tools/ISEScan/err
#$ -wd /workdir/users/agk85/tools/ISEScan/ #Location of your working directory
#$ -l h_vmem=10G #How much memory your job requires, default is up to 4GB if left blank
#$ -t 1-24 #The number of array jobs
#$ -q long.q@cbsubrito2

export PYTHONPATH=/programs/fastcluster_p3/lib/python3.6/site-packages
cd /workdir/users/agk85/tools/ISEScan/ssw201507
cc -Wall -O3 -pipe -fPIC -shared -rdynamic -o libssw.so ssw.c ssw.h
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:path_of_libssw.so

#Set directories
WRK=/workdir/users/agk85
DESIGN_FILE=${WRK}/CDC/GenomeDesign.txt
#Create design file of file names
        DESIGN=$(sed -n "${SGE_TASK_ID}p" $DESIGN_FILE)
        NAME=`basename "$DESIGN"`

SCF=$WRK/CDC/prodigal/genomes/${NAME}/${NAME}_scaffold.fasta
READ=$WRK/tools/ISEScan/ssw201507/genomes/${NAME}_scaffold.fasta
cp $SCF $READ

OUT=$WRK/tools/ISEScan/ssw201507
cd $OUT

python3 /workdir/users/agk85/tools/ISEScan/isescan.py $READ proteome hmm
