#blast line B309-2_scaffold_15467_2 rep8_2_repA(pEJ97-1)_AJ49170    77.059  170     19      13      431     596     389     542     2.37e-17        82.4
#sort -k1,1 -k12,12gr -k11,11g -k3,3gr temp.out | sort -u -k1,1 --merge > best
#filters blast output based on identity and coverage of subject 
#USAGE python blast_filter.py db.fasta blast_output.out blast_output_filter.out 80 60
#assumes outfmt = 6 

from Bio import SeqIO
import sys

reference = sys.argv[1]
ref_dict = SeqIO.to_dict(SeqIO.parse(reference, "fasta"))
infile = open(sys.argv[2],'r')
outfile = open(sys.argv[3],'w')
pidthresh = float(sys.argv[4])
covgthresh = float(sys.argv[5])

for line in infile:
	fields = line.strip().split('\t')
	query = fields[0]
	subject = fields[1]
	pid = float(fields[2])
	srec = ref_dict[subject]
	covg = 100*abs(float(fields[9]) - float(fields[8]))/len(ref_dict[subject])
	if ((pid >= pidthresh) and (covg >=covgthresh)):
		outfile.write(line)

outfile.close()
infile.close()
	
