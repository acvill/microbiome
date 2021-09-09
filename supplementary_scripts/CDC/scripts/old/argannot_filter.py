#blast line B309-2_scaffold_15467_2 rep8_2_repA(pEJ97-1)_AJ49170    77.059  170     19      13      431     596     389     542     2.37e-17        82.4
#sort -k1,1 -k12,12gr -k11,11g -k3,3gr file | sort -u -k1,1 --merge > best
#USAGE: python argannot_filter.py /workdir/users/agk85/CDC/resfams/metagenomes/B309-1/B309-1_argannot_nt.out /workdir/users/agk85/CDC/resfams/metagenomes/B309-1/B309-1_argannot_nt.gff3
from Bio import SeqIO
import sys

reference = '/workdir/users/agk85/CDC/resfams/blast_db/argannot-nt-v3-march2017.fna'
ref_dict = SeqIO.to_dict(SeqIO.parse(reference, "fasta"))

infile = open(sys.argv[1],'r')
gff = open(sys.argv[2],'w')

gff.write('##gff-version 3\n')
for line in infile:
	fields = line.strip().split('\t')
	query = fields[0]
	scfparts = fields[0].split('_')
	gene = scfparts.pop(len(scfparts)-1)
	scf = '_'.join(scfparts)
	subject = fields[1]
	pid = float(fields[2])
	srec = ref_dict[subject]
	covg = 100*(float(fields[9]) - float(fields[8])+1)/len(ref_dict[subject])
	if ((pid == 100) and (covg >=100)):
		print line
		qstart = fields[6]
		qend = fields[7]
		score = fields[11]
		gff.write('{0}\tArg-annot\tCDS\t{1}\t{2}\t{3}\t.\t0\tID={4};subject={5}\n'.format(scf, qstart, qend, score, query, subject))


gff.close()
infile.close()
	
	
	
