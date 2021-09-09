#blast line B309-2_scaffold_15467_2 rep8_2_repA(pEJ97-1)_AJ49170    77.059  170     19      13      431     596     389     542     2.37e-17        82.4
#sort -k1,1 -k12,12gr -k11,11g -k3,3gr temp.out | sort -u -k1,1 --merge > best
#filters blast output based on identity and coverage of query 
#USAGE python blast_filter.py db.fasta blast_output.out blast_output_filter.out 80 60 1000
#assumes outfmt = 6 

from Bio import SeqIO
import sys

queryhandle = sys.argv[1]
inhandle = sys.argv[2]
infile = open(inhandle,'r')
outfile = open(sys.argv[3],'w')
pidthresh = float(sys.argv[4])
covgthresh = float(sys.argv[5])
sizethresh = float(sys.argv[6])
query_dict = SeqIO.to_dict(SeqIO.parse(queryhandle, "fasta"))


for line in infile:
	fields = line.strip().split('\t')
	query = fields[0]
	subject = fields[1]
	pid = float(fields[2])
	query_covg = 100*abs(float(fields[7]) - float(fields[6]))/len(query_dict[query])
	size = abs(float(fields[9]) - float(fields[8]))
	if ((pid >= pidthresh) and (query_covg >=covgthresh) and (size>= sizethresh)):
		outfile.write(line)


outfile.close()
infile.close()

