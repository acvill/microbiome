#addname_fasta.py
#USAGE python addname_fasta.py seqfile name outfile

from Bio import SeqIO
import sys
inhandle = sys.argv[1]
label = sys.argv[2]
outhandle = sys.argv[3]
recs = []
records = SeqIO.parse(inhandle,'fasta')
for rec in records:
	rec.id = label + '_' + rec.id
	recs.append(rec)


SeqIO.write(recs, outhandle, 'fasta')

