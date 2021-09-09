#awk '$6 ~ /plasmid_/' B309-1_master_protein_table.txt
#
#USAGE: python protseqs_ofinterest.py
####################################################################################

from Bio import SeqIO
import os
import sys
name = sys.argv[1]
not_included= open('/workdir/users/agk85/CDC/tables/metagenomes/not_included.txt','w')

orgdict = {}
protdict = {}
print(name)
protfile = '/workdir/users/agk85/CDC/prodigal_excise/metagenomes2/' + name + '/' + name + '_proteins.fna'
for rec in SeqIO.parse(protfile, "fasta"):
	protdict[rec.id] = str(rec.seq)

protdict_old = {}
protfile = '/workdir/users/agk85/CDC/prodigal/metagenomes2/' + name + '/' + name + '_proteins.fna'
for rec in SeqIO.parse(protfile, "fasta"):
	protdict_old[rec.id] = str(rec.seq)	


#amphora Using the protein supplied amphora analysis---don't think it's much different to amphora calling genes itself
print('amphora')
with open('/workdir/users/agk85/CDC/amphora/metagenomes2/' + name + '/' + name + '_phylotype.txt','r') as amphora:
	header = amphora.readline()
	for line in amphora:
		id = line.split('\t')[0]
		try:
			seq = protdict[id]
			orgdict[id] = seq
		except KeyError:
			print(id)


print('rnammer')
from Bio import SeqIO
scf_dict  = SeqIO.parse("/workdir/users/agk85/CDC/rnammer/metagenomes2/"+name+"_16S.fasta", "fasta")
for rec in scf_dict:
	orgdict[rec.id] = str(rec.seq)



with open('/workdir/users/agk85/CDC/tables/metagenomes/' + name + '_org.fna', 'w') as org_outfile:
	for id,seq in orgdict.iteritems():
		org_outfile.write('>' + id + '\n' + seq + '\n')





