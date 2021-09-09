#awk '$6 ~ /plasmid_/' B309-1_master_protein_table.txt
#
#USAGE: python protseqs_ofinterest.py
####################################################################################

from Bio import SeqIO
import os
import sys
name = sys.argv[1]
not_included= open('/workdir/users/agk85/CDC/tables/metagenomes/not_included.txt','w')

phagedict ={}
otherdict = {}
orgdict = {}
plasmiddict={}
isdict = {}
protdict = {}
print(name)
protfile = '/workdir/users/agk85/CDC/prodigal_excise/metagenomes2/' + name + '/' + name + '_proteins.fna'
for rec in SeqIO.parse(protfile, "fasta"):
	protdict[rec.id] = str(rec.seq)



#Relaxase
print('relaxase')
with open('/workdir/users/agk85/CDC/plasmids/metagenomes2/' + name + '/' + name + '_relaxase.txt','r') as relaxase:
	#relaxase_dict = {}
	for line in relaxase:
		id = line.split('\t')[0]
		seq = protdict[id]
		plasmiddict[id] = seq

#ARGs
# print('resfams')
# with open('/workdir/users/agk85/CDC/resfams/metagenomes2/' + name + '/' + name + '_resfams.txt','r') as resfam:
# 	for line in resfam:
# 		id = line.split('\t')[0]
# 		seq = protdict[id]
# 		argdict[id] = seq
# 
# #card
# print('card')
# with open('/workdir/users/agk85/CDC/card/metagenomes2/' + name + '/' + name + '.txt','r') as card:
# 	header = card.readline()
# 	for line in card:
# 		id = line.split('\t')[0].split(' ')[0]
# 		seq = protdict[id]
# 		argdict[id] = seq	

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

#phage--vogs
print('vogs')
with open('/workdir/users/agk85/CDC/phage/metagenomes2/' + name + '/' + name + '_vogs.txt.best.filter','r') as vogs:
	for line in vogs:
		id = line.split('\t')[0]
		seq = protdict[id]
		phagedict[id] = seq

#phage--phaster
print('phaster')
with open('/workdir/users/agk85/CDC/phage/metagenomes2/' + name + '/' + name + '_phaster_filter.out','r') as phaster:
	for line in phaster:
		id = line.split('\t')[0]
		seq = protdict[id]
		phagedict[id] = seq

#aclame--all
print('aclame')
#vir = phage, plasmid = plasmid, proph = phage
with open('/workdir/users/agk85/CDC/aclame/metagenomes2/' + name + '/' + name + '_aclame_filter.out','r') as aclame:
	for line in aclame:
		id = line.split('\t')[0]
		type = line.split('\t')[1].split(':')[1]
		seq = protdict[id]
		if type == 'plasmid':
			plasmiddict[id] = seq
		if type == 'proph':
			phagedict[id] = seq
		if type == 'vir':
			phagedict[id] = seq

#phagefinder
print('phagefinder')
with open('/workdir/users/agk85/CDC/prodigal_excise/metagenomes2/' + name + '/' + name + '_phagefinder.txt','r') as phagefinder:
	for line in phagefinder:
		flag = 0
		start = int(line.split('\t')[2])
		stop = int(line.strip().split('\t')[3])
		id = line.split('\t')[0].split('>')[1]
		with open('/workdir/users/agk85/CDC/prodigal_excise/metagenomes2/' + name + '/' + name + '_proteins.fna') as pf:
			for protline in pf:
				if protline[0] == '>':
					#check to make sure the scaffold is the same
					if id.split('_')[2] == protline.split('_')[2]:
						#grab the beginning and end positions of the protein and the protein id
						b = int(protline.split(' # ')[1])
						e = int(protline.split(' # ')[2])
						prot = protline.split(' ')[0].split('>')[1]
						#if they overlap and if the overlapping section covers more than 50% of length
						if (start < e and stop > b and (float(min(e-start, stop -b, stop-start, e-b)))/(e-b)>0.5):
							seq = protdict[prot]
							protid = protline.split('>')[1].split(' ')[0]
							phagedict[protid] = seq
							flag = 1
		if flag == 0:
			not_included.write(line)

from Bio import SeqIO
scf_dict  = SeqIO.index("/workdir/users/agk85/CDC/prodigal_excise/metagenomes2/"+name+"/"+name+"_scaffold.fasta", "fasta")
print('isescan')
#isescan #### NEEDS OVERLAPPING 
with open('/workdir/users/agk85/CDC/iselements/metagenomes/prediction/' + name + '_isescan.txt','r') as isescan:
	for line in isescan:
		#flag = 0
		#start = int(line.split('\t')[2])
		#stop = int(line.strip().split('\t')[3])
		id = line.split('\t')[0].split('>')[1]
		seq = str(scf_dict[id].seq)
		isdict[id]= seq

print('plasmid_finder')
with open('/workdir/users/agk85/CDC/plasmids/metagenomes2/' + name + '/' + name + '_plasmidgenes_filter.out') as plasmid_finder: 
	for line in plasmid_finder:
		flag = 0
		start = int(line.split('\t')[6])
		stop = int(line.split('\t')[7])
		id = line.split('\t')[0]
		with open('/workdir/users/agk85/CDC/prodigal_excise/metagenomes2/' + name + '/' + name + '_proteins.fna') as pf:
			for protline in pf: 
				if protline[0] == '>':
					#check to make sure the scaffold is the same
					if id.split('_')[2] == protline.split('_')[2]:
						#grab the beginning and end positions of the protein and the protein id
						b = int(protline.split(' # ')[1])
						e = int(protline.split(' # ')[2])
						prot = protline.split(' ')[0].split('>')[1]
						#if they overlap and if the overlapping section covers more than 50% of IS element length
						if start < e and stop > b and (float(min(e-start, stop -b, stop-start, e-b)))/(e-b)>0.5:
							seq = protdict[prot]
							protid = protline.split('>')[1].split(' ')[0]
							plasmiddict[protid] = seq
							flag = 1
		if flag == 0:
			not_included.write(line)

print('fullplasmids')
with open('/workdir/users/agk85/CDC/plasmids/metagenomes2/' + name + '/' + name + '_fullplasmids_filter.out','r') as fullplasmids:
	for line in fullplasmids:
		flag = 0
		start = int(line.split('\t')[6])
		stop = int(line.split('\t')[7])
		id = line.split('\t')[0]
		with open('/workdir/users/agk85/CDC/prodigal_excise/metagenomes2/' + name + '/' + name + '_proteins.fna') as pf:
			for protline in pf: 
				if protline[0] == '>':
					#check to make sure the scaffold is the same
					if id.split('_')[2] == protline.split('_')[2]:
						#grab the beginning and end positions of the protein and the protein id
						b = int(protline.split(' # ')[1])
						e = int(protline.split(' # ')[2])
						prot = protline.split(' ')[0].split('>')[1]
						#if they overlap and if the overlapping section covers more than 50% of IS element length
						if start < e and stop > b and (float(min(e-start, stop -b, stop-start, e-b)))/(e-b)>0.5:
							seq = protdict[prot]
							protid = protline.split('>')[1].split(' ')[0]
							plasmiddict[protid] = seq
							flag = 1
		if flag == 0:
			not_included.write(line)



print('rnammer')
from Bio import SeqIO
scf_dict  = SeqIO.parse("/workdir/users/agk85/CDC/rnammer/metagenomes2/"+name+"_16S.fasta", "fasta")
for rec in scf_dict:
	orgdict[rec.id] = str(rec.seq)


print('imme')
with open('/workdir/users/agk85/CDC/imme/metagenomes2/'  + name + '/' + name + '_imme_filter.out','r') as imme:
	for line in imme:
		flag = 0
		start = int(line.split('\t')[6])
		stop = int(line.split('\t')[7])
		id = line.split('\t')[0]
		with open('/workdir/users/agk85/CDC/prodigal_excise/metagenomes2/' + name + '/' + name + '_proteins.fna') as pf:
			for protline in pf: 
				if protline[0] == '>':
					#check to make sure the scaffold is the same
					if id.split('_')[2] == protline.split('_')[2]:
						#grab the beginning and end positions of the protein and the protein id
						b = int(protline.split(' # ')[1])
						e = int(protline.split(' # ')[2])
						prot = protline.split(' ')[0].split('>')[1]
						#if they overlap and if the overlapping section covers more than 50% of IS element length
						if (start < e and stop > b and (float(min(e-start, stop -b, stop-start, e-b)))/(e-b)>0.5):
							seq = protdict[prot]
							protid = protline.split('>')[1].split(' ')[0]
							otherdict[protid] = seq
							flag = 1
		if flag == 0:
			not_included.write(line)








with open('/workdir/users/agk85/CDC/tables/metagenomes/' + name + '_other.fna', 'w') as other_outfile:
	for id,seq in otherdict.iteritems():
		other_outfile.write('>other_' + id + '\n' + seq + '\n')

with open('/workdir/users/agk85/CDC/tables/metagenomes/' + name + '_org.fna', 'w') as org_outfile:
	for id,seq in orgdict.iteritems():
		org_outfile.write('>org_' + id + '\n' + seq + '\n')

with open('/workdir/users/agk85/CDC/tables/metagenomes/' + name + '_plasmid.fna', 'w') as plasmid_outfile:
	for id,seq in plasmiddict.iteritems():
		plasmid_outfile.write('>plasmid_' + id + '\n' + seq + '\n')

with open('/workdir/users/agk85/CDC/tables/metagenomes/' + name + '_phage.fna', 'w') as phage_outfile:
	for id,seq in phagedict.iteritems():
		phage_outfile.write('>phage' + id + '\n' + seq + '\n')

with open('/workdir/users/agk85/CDC/tables/metagenomes/' + name + '_is.fna', 'w') as is_outfile:
	for id,seq in isdict.iteritems():
		is_outfile.write('>is_' + id + '\n' + seq + '\n')





