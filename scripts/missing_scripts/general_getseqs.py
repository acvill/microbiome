#more generalized script to grab scfs of interest
#USAGE: python grab_scfs.py reference scflist outfile addname[1/0] sampname
import sys
from Bio import SeqIO

reference = sys.argv[1]
outfile = sys.argv[3]
scf_dict = SeqIO.to_dict(SeqIO.parse(reference, "fasta"))
addsampname= int(sys.argv[4])
sampname = sys.argv[5]

recs = []
scffile = open(sys.argv[2],'r')
for line in scffile:
	scfid = line.strip()
	try:
		rec = scf_dict[scfid]
		if addsampname ==1:
			if sampname not in rec.id:
				recid = rec.id
				rec.id = sampname +'_' +  recid
		recs.append(rec)
	except KeyError:
		print scfid

SeqIO.write(recs, outfile, 'fasta')
