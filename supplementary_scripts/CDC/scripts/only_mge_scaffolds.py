#remove mge_scaffolds from scaffold fasta file
import sys
from Bio import SeqIO

inhandle = sys.argv[1]
combo_table_handle = sys.argv[2]
outhandle = sys.argv[3]
outhandle2 = sys.argv[4]

#inhandle = '/workdir/users/agk85/CDC/prodigal_excise/metagenomes2/B320-1/B320-1_scaffold.fasta'
#combo_table_handle='B320-1_master_scf_table_binary.txt'
#whether or not a ctdict 
ctdict = {}
with open(combo_table_handle) as ct:
	header = ct.readline()
	for line in ct:
		fields = line.split('\t')
		mge = fields[-2]
		scfid = fields[0]
		#if one of the mge columns is 1, then switch mge to 1
		if mge == '1':
			ctdict[scfid] = 'mge'
		else:	
			ctdict[scfid] = 'nomge'
		

recs = []
recs_nomge = []
for rec in SeqIO.parse(inhandle,'fasta'):
	scfid = rec.id
	if scfid in ctdict.keys():
		if ctdict[scfid] == 'mge':
			recs.append(rec)
		if ctdict[scfid] == 'nomge':
			recs_nomge.append(rec)


SeqIO.write(recs, outhandle, 'fasta')
SeqIO.write(recs_nomge, outhandle2, 'fasta')
	

