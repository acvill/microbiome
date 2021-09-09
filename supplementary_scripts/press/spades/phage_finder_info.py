#python file to make phage_finder_info.txt
#scaffold/contig/assembly_ID size_of_molecule feat_name end5 end3 com_name
#NC_002947       6181863 PP4178_gi26990870-NC_002947     4721594 4720869 dienelactone hydrolase family protein
# python phage_finder_info.py scaffold_min2000.fa dna.fna
import sys
from Bio import SeqIO
refdict = {}
#ref = 'scaffold_min2000.fa'
ref = sys.argv[1]
for seq_rec in SeqIO.parse(ref,'fasta'):
	refdict[seq_rec.id] = len(seq_rec)



#infile = 'dna.fna'
infile = sys.argv[2]
outfile = open(sys.argv[3],'w')
for seq_rec in SeqIO.parse(infile, 'fasta'):
	l = len(seq_rec)
	seqid = seq_rec.description
	contig = '_'.join(seqid.split(' ')[0].split('_')[:-1])
	size = str(refdict[contig])
	orf_id = seqid.split(' ')[0]
	start = seqid.split(' # ')[1]
	stop = seqid.split(' # ')[2]
	description = seqid.strip().split(' # ')[4]
	outfile.write('{}\t{}\t{}\t{}\t{}\t{}\n'.format(contig, size, orf_id, start, stop, description))



outfile.close()
