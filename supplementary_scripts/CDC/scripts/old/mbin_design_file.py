from Bio import SeqIO
infile = open('mbin.summary','r')
outfile = open('mbinDesign.txt','w')
header = infile.readline()
for line in infile:
	name = line.strip().split('\t')[0]
	records = list(SeqIO.parse(name, "fasta"))
	c = len(records)
	completeness = float(line.strip().split('\t')[2].split('%')[0])
	size = float(line.strip().split('\t')[3])
	gc = line.strip().split('\t')[4]
	if (completeness > 75 and c< 175*size/1000000):
		outfile.write(name + '\n')
		print name, completeness, c, size
