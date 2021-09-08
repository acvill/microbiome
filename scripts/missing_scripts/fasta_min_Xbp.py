#returns contigs greater than or equal X basepairs
#USAGE: python fasta_min_Xbp.py B320-1.fa B320-1_min_500.fa 500
import sys
from Bio import SeqIO
from Bio.SeqIO.FastaIO import FastaWriter

handle = sys.argv[1]
handle2 = sys.argv[2]
length = int(sys.argv[3])
my_recs=[]

for seq_record in SeqIO.parse(handle, "fasta"):
	seqlen = len(seq_record)
	if seqlen >=length:
		my_recs.append(seq_record)


fasta_out = FastaWriter(open(handle2,'w'), wrap=0)
fasta_out.write_file(my_recs)
