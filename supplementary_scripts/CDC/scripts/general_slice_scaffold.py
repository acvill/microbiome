#general_slice_scaffolds.py
#USAGE: python general_slice_scaffolds.pf B309-1_scaffold.fasta B309-1_scf_start_stop.txt B309-1_sliced.fasta
import sys
from Bio import SeqIO

reference = sys.argv[1]

#this has to be of the format: scaffold start stop
scffile = open(sys.argv[2],'r')

outfile = sys.argv[3]
scf_dict = SeqIO.to_dict(SeqIO.parse(reference, "fasta"))

recs = []
for line in scffile:
        scfid = line.split('\t')[0]
        start = line.split('\t')[1]
        stop = line.split('\t')[2].strip()
        try:
                rec = scf_dict[scfid]
                newrec = rec[start, stop]
                recs.append(newrec)
        except KeyError:
                print scfid

SeqIO.write(recs, outfile, 'fasta')
