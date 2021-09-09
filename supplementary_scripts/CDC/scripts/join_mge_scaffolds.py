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
		mge = 0
		fields = line.split('\t')
		if (fields[1] =='1' or fields[2] =='1' or fields[3] =='1' or fields[7] =='1' or fields[8] =='1' or fields[9] =='1' or fields[10] =='1' or fields[13] =='1' or fields[14] =='1' or fields[15] =='1'):
			mge = 1
		scfid = fields[0]
		#if one of the mge columns is 1, then switch mge to 1
		if mge == 1:
			ctdict[scfid] = 'mge'
		else:	
			ctdict[scfid] = 'nomge'
		

recs = []
for rec in SeqIO.parse(inhandle,'fasta'):
	scfid = rec.id
	if ctdict[scfid] == 'mge':
		recs.append(rec)


SeqIO.write(recs, outhandle, 'fasta')
	
	

