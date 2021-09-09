#converts reference fasta into individual sequence fastas for use with 3C mapping
import sys
from Bio import SeqIO	
#handle = 'SMC.fasta'
handle = sys.argv[1]
for rec in SeqIO.parse(handle,'fasta'):
	outhandle = rec.id + '.fasta'
	SeqIO.write(rec, outhandle, 'fasta')
