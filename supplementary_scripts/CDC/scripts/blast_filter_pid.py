#blast line B309-2_scaffold_15467_2 rep8_2_repA(pEJ97-1)_AJ49170    77.059  170     19      13      431     596     389     542     2.37e-17        82.4
#sort -k1,1 -k12,12gr -k11,11g -k3,3gr temp.out | sort -u -k1,1 --merge > best
#filters blast output based on identity and coverage of subject 
#USAGE python blast_filter.py blast_output.out blast_output_filter.out 80
#assumes outfmt = 6 

from Bio import SeqIO
import sys

infile = open(sys.argv[1],'r')
outfile = open(sys.argv[2],'w')
pidthresh = float(sys.argv[3])

for line in infile:
	fields = line.strip().split('\t')
	query = fields[0]
	subject = fields[1]
	pid = float(fields[2])
	if (pid >= pidthresh):
		outfile.write(line)

outfile.close()
infile.close()
	
