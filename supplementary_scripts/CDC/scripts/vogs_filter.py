#filter_vogs
#bit score of at least 40
#viral quotient = 1
#USAGE: python vogs_filter.py B309-1_modified_vogs.txt.best
import sys
inhandle = sys.argv[1]
vqdict = {}
with open('/workdir/users/agk85/CDC/phage/ViralQuotient.txt','r') as vqfile:
	for line in vqfile:
		vogid = line.split('\t')[0]
		vq = line.strip().split('\t')[3]
		vqdict[vogid] = vq


with open(inhandle,'r') as infile:
	with open(inhandle + '.filter', 'w') as outfile:
		for line in infile:
			bit = float(line.split('\t')[4])
			vogid = line.split('\t')[2]
			if bit > 40:
				if vqdict[vogid] == '1.0':
					outfile.write(line)
				
	

