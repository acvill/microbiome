import sys

inhandle = sys.argv[1]
outhandle = sys.argv[2]

with open(inhandle) as infile:
	with open(outhandle,'w') as outfile:
		for line in infile:
			cluster = line.split('.')[1]
			contig = line.strip().split('>')[1]
			outfile.write(contig + '\t' + cluster + '\n')
