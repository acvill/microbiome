#$ -S /bin/bash                                 # (change the default shell to bash; can change to python if needed)
#$ -cwd                         # (start job in current directory rather than $HOME)
#$ -N get-phastzips                             # (change name of job)
#$ -o get-phastzips.$JOB_ID             # (write stdout to this file)
#$ -pe parenv 8                                 # (request a specific number of slots -here - 8; pe stands for "parallel environment"; default is 1)
#$ -M agk85@cornell.edu          # (set your email address)
#$ -m be                        # (send email at (b)eginning and (e)nd of job)
#$ -l h_vmem=16G                # (request 16GB of RAM for the job; default is 4 GB per job)
#$ -q short.q@cbsubrito2                  # (require job to run in queue short/long.q machine)

dbdir=/workdir/refdbs/phaster_phages

for refseq in $(cat $dbdir/errorzips); do
        wget -P $dbdir/errorzip_downloads http://phaster.ca/submissions/"$refseq".zip
done
