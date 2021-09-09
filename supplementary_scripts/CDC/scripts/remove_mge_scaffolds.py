#remove mge_scaffolds from scaffold fasta file
import sys
from Bio import SeqIO

inhandle = sys.argv[1]
combo_table_handle = sys.argv[2]
outhandle = sys.argv[3]

#inhandle = '/workdir/users/agk85/CDC/prodigal_excise/metagenomes2/B320-1/B320-1_scaffold.fasta'
#combo_table_handle='B320-1_master_scf_table_binary.txt'
#whether or not a ctdict 
ctdict = {}
with open(combo_table_handle) as ct:
	#0ScfID   1Plasmid_Finder  2Full_Plasmids   3Relaxase        4Resfams 5Perfect 6CARD    7ISEScan 8Phage_Finder    9Phaster 10VOGS    11VF      12tRNASCAN        13Imme    14Aclame_plasmid  15Aclame_phage    16Amphora 17Rnammer 18Maxbin  19Best_org
	#1,2,3,7,8,9,10,13,14,15
	header = ct.readline()
	headernames = header.strip().split('\t')
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
for rec in SeqIO.parse(inhandle,'fasta'):
	scfid = rec.id
	if scfid in ctdict.keys():
		if ctdict[scfid] == 'nomge':
			recs.append(rec)


SeqIO.write(recs, outhandle, 'fasta')
	
	

