import glob

allfiles=glob.glob('/home/britolab/data/CDC/trimmedReads/round**/metagenome/lane**/*.fastq.gz')
allsamples = []
for f in allfiles:
	allsamples.append(f.split('.')[0].split('/')[9])

samples = list(set(allsamples))
samples.sort()


outfile = '/workdir/users/agk85/CDC/MetaDesign_all.txt'
with open(outfile,'w') as outf:
	for samp in samples:
		outf.write(samp + '\n')
