# get a table of phage contigs and the percent of the contig that has phage on it
import glob
outhandle = '/workdir/users/agk85/CDC/prodigal/metagenomes2/phage_percent.txt'
infiles = glob.glob('/workdir/users/agk85/CDC/prodigal/metagenomes2/*/PFPR_tab.txt')
with open(outhandle,'w') as outfile:
	for inhandle in infiles:
		with open(inhandle) as infile:
			header = infile.readline()
			for line in infile:
				patient= line.split('-')[0]
				sample = line.split('\t')[0].split('_')[0]
				contig = line.split('\t')[0]
				contig_size= int(line.split('\t')[1])
				phage_length= int(line.split('\t')[5])
				phage_percent = 100 * (phage_length/float(contig_size))
				outfile.write('{0}\t{1}\t{2}\t{3}\t{4}\n'.format(patient, sample,contig,str(contig_size),str(phage_percent)))
