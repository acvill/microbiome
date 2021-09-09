#master table for proteins
#awk '$6 ~ /plasmid_/' B309-1_master_protein_table.txt
#
#USAGE: python protseqs_ofinterest.py
####################################################################################

from Bio import SeqIO
import os

phagedict ={}
argdict = {}
orgdict = {}
plasmiddict={}
isdict = {}
not_included= open('/workdir/users/agk85/CDC/tables/metagenomes/not_included.txt','w')
names=[]
namefile = '/workdir/users/agk85/CDC/MetaDesign_rerun.txt'
with open(namefile) as nf:
	for line in nf:
		name = line.strip()
		patient = line.split('-')[0]
		names.append(name)

names = ['B309-1']

for name in names:
	protdict = {}
	protfile = '/workdir/users/agk85/CDC/prodigal/metagenomes/' + name + '/' + name + '_proteins.fna'
	for rec in SeqIO.parse(protfile, "fasta"):
		protdict[rec.id] = str(rec.seq)
	
	#Relaxase
	with open('/workdir/users/agk85/CDC/plasmids/metagenomes/' + name + '/' + name + '_modified.tbl.txt','r') as relaxase:
		#relaxase_dict = {}
		for line in relaxase:
			id = line.split('\t')[0].split(' ')[0]
			seq = protdict[id]
			plasmiddict[id] = seq
	
	#ARGs
	with open('/workdir/users/agk85/CDC/resfams/metagenomes/' + name + '/' + name + '_resfams.txt','r') as resfam:
		for line in resfam:
			id = line.split('\t')[2]
			seq = protdict[id]
			argdict[id] = seq
	
	#card
	with open('/workdir/users/agk85/CDC/card/metagenomes/' + name + '/' + name + '.txt','r') as card:
		header = card.readline()
		for line in card:
			id = line.split('\t')[0].split(' ')[0]
			seq = protdict[id]
			argdict[id] = seq	
	
	#amphora Using the protein supplied amphora analysis---don't think it's much different to amphora calling genes itself
	with open('/workdir/users/agk85/CDC/amphora/metagenomes/prot_amphora/' + name + '/' + name + '_phylotype.txt','r') as amphora:
		header = amphora.readline()
		for line in amphora:
			id = line.split('\t')[0]
			seq = protdict[id]
			orgdict[id] = seq
	
	#phage--vogs
	with open('/workdir/users/agk85/CDC/phage/metagenomes/' + name + '/' + name + '_modified_vogs.txt.best.filter','r') as vogs:
		for line in vogs:
			id = line.split('\t')[2]
			seq = protdict[id]
			phagedict[id] = seq
	
	#phage--phaster
	with open('/workdir/users/agk85/CDC/phage/metagenomes/' + name + '/' + name + '_phaster_filter.out','r') as phaster:
		for line in phaster:
			id = line.split('\t')[0]
			seq = protdict[id]
			phagedict[id] = seq
	
	#aclame--all
	#vir = phage, plasmid = plasmid, proph = phage
	with open('/workdir/users/agk85/CDC/aclame/metagenomes/' + name + '/' + name + '_aclame_filter.out','r') as aclame:
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
	#B309-1_scaffold_63_75 #
	with open('/workdir/users/agk85/CDC/prodigal/metagenomes/' + name + '/PFPR_tab.txt','r') as phagefinder:
		for line in phagefinder:
			start = line.split('\t')[13]
			stop = line.split('\t')[14]
			startnum = int(start.split('_')[3])
			stopnum = int(stop.split('_')[3])
			for i in range(startnum, stopnum +1):
				id = line.split('\t')[0] + '_' + str(i)
				seq = protdict[id]
				phagedict[id] = seq
	
	#isescan #### NEEDS OVERLAPPING 
	with open('/workdir/users/agk85/CDC/iselements/metagenomes/prediction/' + name + '.fna.gff','r') as isescan:
		header = isescan.readline()
		for line in isescan:
			if line.split('\t')[2] == 'insertion_sequence':
				flag = 0
				start = int(line.split('\t')[3])
				stop = int(line.split('\t')[4])
				id = line.split('\t')[0]
				with open('/workdir/users/agk85/CDC/prodigal/metagenomes/' + name + '/' + name + '_proteins.fna') as pf:
					for protline in pf: 
						if protline[0] == '>':
							if id.split('_')[2] == protline.split('_')[2]:
								b = int(protline.split(' # ')[1])
								e = int(protline.split(' # ')[2])
								prot = protline.split(' ')[0].split('>')[1]
								if start < e and stop > b and (float(min(e-start, stop -b)))/(stop-start)>0.5:
									seq = protdict[prot]
									protid = protline.split('>')[1].split(' ')[0]
									isdict[protid] = seq
									flag = 1
				if flag == 0:
					not_included.write(line)
	
	with open('/workdir/users/agk85/CDC/plasmids/metagenomes/' + name + '/' + name + '_plasmidgenes_filter.out') as plasmid_finder: 
		for line in plasmid_finder:
			flag = 0
			start = int(line.split('\t')[6])
			stop = int(line.split('\t')[7])
			id = line.split('\t')[0]
			with open('/workdir/users/agk85/CDC/prodigal/metagenomes/' + name + '/' + name + '_proteins.fna') as pf:
				for protline in pf: 
					if protline[0] == '>':
						#check to make sure the scaffold is the same
						if id.split('_')[2] == protline.split('_')[2]:
							#grab the beginning and end positions of the protein and the protein id
							b = int(protline.split(' # ')[1])
							e = int(protline.split(' # ')[2])
							prot = protline.split(' ')[0].split('>')[1]
							#if they overlap and if the overlapping section covers more than 50% of IS element length
							if start < e and stop > b and (float(min(e-start, stop -b)))/(stop-start)>0.5:
								seq = protdict[prot]
								protid = protline.split('>')[1].split(' ')[0]
								plasmiddict[protid] = seq
								flag = 1
			if flag == 0:
				not_included.write(line)
	
	with open('/workdir/users/agk85/CDC/resfams/metagenomes/' + name + '/' + name + '_perfect_filter.out','r') as perfect:
		for line in perfect:
			flag = 0
			start = int(line.split('\t')[6])
			stop = int(line.split('\t')[7])
			id = line.split('\t')[0]
			with open('/workdir/users/agk85/CDC/prodigal/metagenomes/' + name + '/' + name + '_proteins.fna') as pf:
				for protline in pf: 
					if protline[0] == '>':
						#check to make sure the scaffold is the same
						if id.split('_')[2] == protline.split('_')[2]:
							#grab the beginning and end positions of the protein and the protein id
							b = int(protline.split(' # ')[1])
							e = int(protline.split(' # ')[2])
							prot = protline.split(' ')[0].split('>')[1]
							#if they overlap and if the overlapping section covers more than 50% of IS element length
							if start < e and stop > b and (float(min(e-start, stop -b)))/(stop-start)>0.5:
								seq = protdict[prot]
								protid = protline.split('>')[1].split(' ')[0]
								argdict[protid] = seq
								flag = 1
			if flag == 0:
				not_included.write(line)						


with open('/workdir/users/agk85/CDC/tables/metagenomes/arg.fna', 'w') as arg_outfile:
	for id,seq in argdict.iteritems():
		arg_outfile.write('>' + id + '\n' + seq + '\n')

with open('/workdir/users/agk85/CDC/tables/metagenomes/org.fna', 'w') as org_outfile:
	for id,seq in orgdict.iteritems():
		org_outfile.write('>' + id + '\n' + seq + '\n')

with open('/workdir/users/agk85/CDC/tables/metagenomes/plasmid.fna', 'w') as plasmid_outfile:
	for id,seq in plasmiddict.iteritems():
		plasmid_outfile.write('>' + id + '\n' + seq + '\n')

with open('/workdir/users/agk85/CDC/tables/metagenomes/phage.fna', 'w') as phage_outfile:
	for id,seq in phagedict.iteritems():
		phage_outfile.write('>' + id + '\n' + seq + '\n')

with open('/workdir/users/agk85/CDC/tables/metagenomes/is.fna', 'w') as is_outfile:
	for id,seq in isdict.iteritems():
		is_outfile.write('>' + id + '\n' + seq + '\n')

##########come back to this one
# #Adam's full plasmids
# with open('/workdir/users/agk85/CDC/plasmids/metagenomes/' + name + '/' + name + '_fullplasmid_filter.out','r') as full_plasmids:
# 	full_plasmids_dict = {}
# 	for line in full_plasmids:
# 		id = line.split('\t')[0]
# 		pid = line.split('\t')[2]
# 		b = line.split('\t')[6]
# 		e = line.split('\t')[7]
# 		try:
# 			full_plasmids_dict[id] = full_plasmids_dict[id] +','+ pid + '_' + b + '_' + e
# 		except KeyError:
# 			full_plasmids_dict[id] = pid + '_' + b + '_' + e







