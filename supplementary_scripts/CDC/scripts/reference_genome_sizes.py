#reference_genome_sizes.py
import sys
from Bio import SeqIO
inhandle = sys.argv[1]
outhandle = sys.argv[2]

with open(outhandle,'w') as outfile:
	for rec in SeqIO.parse(inhandle,'fasta'):
		recid = rec.id
		reclen = len(rec)
		outfile.write(rec.id + '\t' + str(reclen) + '\n')
