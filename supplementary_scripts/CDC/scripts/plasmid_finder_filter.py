#blast line B309-2_scaffold_15467_2 rep8_2_repA(pEJ97-1)_AJ49170    77.059  170     19      13      431     596     389     542     2.37e-17        82.4
#sort -k1,1 -k12,12gr -k11,11g -k3,3gr temp.out | sort -u -k1,1 --merge > best
#USAGE: python plasmid_finder_filter.py /workdir/users/agk85/CDC/plasmids/metagenomes/B314-1/B314-1_plasmidgenes.out.best' '/workdir/users/agk85/CDC/plasmids/metagenomes/B314-1/B314-1_plasmid.gff' '/workdir/users/agk85/CDC/prodigal/metagenomes/B314-1/B314-1_proteins.faa' '/workdir/users/agk85/CDC/plasmids/metagenomes/B314-1/B314-1_modified.tbl.txt'
from Bio import SeqIO
import sys

reference = '/workdir/users/agk85/CDC/plasmids/plasmid_db.fsa'
ref_dict = SeqIO.to_dict(SeqIO.parse(reference, "fasta"))

infile = open(sys.argv[1],'r')
#infile = open('/workdir/users/agk85/CDC/plasmids/metagenomes/B314-1/B314-1_plasmidgenes.out.best','r')
gff = open(sys.argv[2],'w')
#gff = open('/workdir/users/agk85/CDC/plasmids/metagenomes/B314-1/B314-1_plasmid.gff','w')

#protfile = '/workdir/users/agk85/CDC/prodigal/metagenomes/B314-1/B314-1_proteins.faa'
protfile = sys.argv[3]
#relaxase = '/workdir/users/agk85/CDC/plasmids/metagenomes/B314-1/B314-1_modified.tbl.txt'
relaxase = sys.argv[4]

gff.write('##gff-version 3\n')
plasmid_counter = {}
for line in infile:
	fields = line.strip().split('\t')
	query = fields[0]
	subject = fields[1]
	pid = float(fields[2])
	srec = ref_dict[subject]
	covg = 100*(float(fields[9]) - float(fields[8]))/len(ref_dict[subject])
	if ((pid >= 80) and (covg >=60)):
		print line
		qstart = fields[6]
		qend = fields[7]
		score = fields[11]
		try:
			pcount = plasmid_counter[query]
			plasmid_counter[query] = plasmid_counter[query] + 1
		except KeyError:
			pcount = 1
			plasmid_counter[query] = 1
		gff.write('{0}\tPlasmidFinder\tplasmid\t{1}\t{2}\t{3}\t.\t0\tID={4};subject={5}\n'.format(query, qstart, qend, score, query + '_plasmid' + str(pcount), subject))



protdict = SeqIO.to_dict(SeqIO.parse(protfile, "fasta"))

relaxasefile = open(relaxase,'r')
for line in relaxasefile:
	fields = line.strip().split('\t')
	query = fields[0]
	score = fields[4]
	scfparts = fields[0].split('_')
	gene = scfparts.pop(len(scfparts)-1)
	scf = '_'.join(scfparts)
	rec = protdict[query]
	qstart = rec.description.split(' # ')[1]
	qstop = rec.description.split(' # ')[2]
	strand = rec.description.split(' # ')[3].split('1')[0]
	gff.write('{0}\tPfam\tCDS\t{1}\t{2}\t{3}\t.\t0\tID={4};subject=relaxase\n'.format(scf, qstart, qstop, score, query))


gff.close()
infile.close()
