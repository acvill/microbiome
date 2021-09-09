#master table for scaffolds
#awk '$6 ~ /plasmid_/' B309-1_master_scf_table.txt
#
#USAGE: python master_scf_table.py B309-1 B309
import sys

def add_program(ldict, p_dict, scfid,ident):
	try:
		ldict[scfid] = ldict[scfid] + '\t' + ident + p_dict[id]
	except KeyError:
		ldict[scfid] = ldict[scfid] + '\t' + '.' 

#hardcoded
name = sys.argv[1]
patient = sys.argv[2]
#name = 'B309-1'
#patient = 'B309'

# with open('/workdir/users/agk85/CDC/prodigal/metagenomes/combined_prots/' + patient + '_nr.fna.clstr','r') as infile:
# 	clusterdict = {}
# 	clusternum_map = {}
# 	for line in infile:
# 		if line[0] == '>':
# 			cluster = line.strip().split(' ')[1]
# 		else:
# 			prot =  line.split('>')[1].split('.')[0]
# 			clusterdict[prot] = cluster
# 			if '*' in line:
# 				clusternum_map[cluster] = prot

# 
# with open('/workdir/users/agk85/CDC/mapping/metagenomes/bwa_alignments/' + name + '.rpkm.txt','r') as rpkm:
# 	rpkmdict = {}
# 	header = rpkm.readline()
# 	for line in rpkm:
# 		id = line.split(',')[0]
# 		stat = str(round(float(line.split(',')[1]),2))
# 		coverage = str(round(float(line.strip().split(',')[2]),2))
# 		rpkmdict[id] = stat + "_" + coverage
# 

protdict = {}
with open('/workdir/users/agk85/CDC/prodigal/metagenomes2/' + name + '/' + name + '_proteins.faa','r') as prot:
	for line in prot:
		if line[0] == '>':
			id = line.split('>')[1].split(' ')[0]
			b = line.split(' # ')[1]
			e = line.split(' # ')[2]
			#clusternum = clusterdict[id]
			#prot = clusternum_map[clusternum]
			#try:
			#	stat = rpkmdict[prot]
			#except KeyError:
			#	stat = 'NA'
			protdict[id] = b+'_' + e


ids = []
with open('/workdir/users/agk85/CDC/prodigal/metagenomes2/' + name + '/' + name + '_scaffold.fasta','r') as infile:
	for line in infile:
		if line[0] == '>':
			id = line.split(' ')[0].split('>')[1]
			ids.append(id)


# #phage finder 
# with open('/workdir/users/agk85/CDC/prodigal/metagenomes/' + name + '/PFPR_tab.txt','r') as phagefinder:
# 	pf_dict = {}
# 	header = phagefinder.readline()
# 	for line in phagefinder:
# 		id = line.split('\t')[0]
# 		b = line.split('\t')[3]
# 		e = line.split('\t')[4]
# 		try:
# 			pf_dict[id] = pf_dict[id]  + ',' + b + '_' + e
# 		except KeyError:
# 			pf_dict[id] = b + '_' + e

# #virFinder	
# with open('/workdir/users/agk85/CDC/phage/metagenomes/' + name + '/' + name + '_virfinder.txt','r') as virfinder:
# 	header = virfinder.readline()
# 	vf_dict = {}
# 	for line in virfinder:
# 		id = line.split('\t')[1].split('"')[1].split(' ')[0]
# 		pval = str(round(float(line.strip().split('\t')[4]),4))
# 		vf_dict[id] = pval

# #cbar
# with open('/workdir/users/agk85/CDC/plasmids/metagenomes/' + name + '/' + name + '_cbar.txt','r') as cbar:
# 	header = cbar.readline()
# 	cbar_dict = {}
# 	for line in cbar:
# 		id = line.split('\t')[0]
# 		type = line.strip().split('\t')[2]
# 		cbar_dict[id] = type

# #plasmidFinder
# with open('/workdir/users/agk85/CDC/plasmids/metagenomes/' + name + '/' + name + '_plasmidgenes_filter.out','r') as plasmid_finder:
# 	plasmid_finder_dict = {}
# 	for line in plasmid_finder:
# 		id = line.split('\t')[0]
# 		pid = line.split('\t')[2]
# 		b = line.split('\t')[6]
# 		e = line.split('\t')[7]
# 		try:
# 			plasmid_finder_dict[id] = plasmid_finder_dict[id] +',' + pid + '_' + b + '_' + e
# 		except KeyError:
# 			plasmid_finder_dict[id] = pid + '_' + b + '_' + e
# 
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
# 
# #Relaxase
# with open('/workdir/users/agk85/CDC/plasmids/metagenomes/' + name + '/' + name + '_modified.tbl.txt','r') as relaxase:
# 	relaxase_dict = {}
# 	for line in relaxase:
# 		idinfo = line.split('_')
# 		id = idinfo[0] + '_scaffold_' + idinfo[2]
# 		b_e = protdict[line.split('\t')[0]]
# 		eval = line.split('\t')[3]
# 		try:
# 			relaxase_dict[id] = relaxase_dict[id] +',' + eval +'|' + b_e 
# 		except KeyError:
# 			relaxase_dict[id] = eval +'|' + b_e


#resfams
with open('/workdir/users/agk85/CDC/resfams/metagenomes2/' + name + '/' + name + '_resfams.txt','r') as resfam:
	resfam_dict = {}
	for line in resfam:
		idinfo = line.split('\t')[0].split('_')
		id = idinfo[0] + '_scaffold_' + idinfo[2]
		type = line.split('\t')[2]
		eval = line.split('\t')[3]
		b_e =  protdict[line.split('\t')[0]]
		try:
			resfam_dict[id] = resfam_dict[id] +',' + type + '|' + eval +'|' + b_e 
		except KeyError:
			resfam_dict[id] = type + '|' + eval +'|' + b_e 

# #perfect 100% identity to sequence XXX coverage of reference sequence
# with open('/workdir/users/agk85/CDC/resfams/metagenomes/' + name + '/' + name + '_perfect_filter.out','r') as perfect:
# 	perfect_dict = {}
# 	for line in perfect:
# 		id = line.split('\t')[0]
# 		pid = line.split('\t')[2]
# 		b = line.split('\t')[6]
# 		e = line.split('\t')[7]
# 		try:
# 			perfect[id] = perfect_dict[id] +','+ pid + '_' + b + '_' + e
# 		except KeyError:
# 			perfect_dict[id] = pid + '_' + b + '_' + e
# 
# 
# #isescan
# with open('/workdir/users/agk85/CDC/iselements/metagenomes/prediction/' + name + '.fna.gff','r') as isescan:
# 	header = isescan.readline()
# 	isescan_dict = {}
# 	for line in isescan:
# 		id = line.split('\t')[0]
# 		type = line.split('\t')[2]
# 		b = line.split('\t')[3]
# 		e = line.split('\t')[4]
# 		try:
# 			isescan_dict[id] = isescan_dict[id] + ',' + type + '|' + b + '_' + e
# 		except KeyError:
# 			isescan_dict[id] = type + '|' + b + '_' + e



#amphora Using the protein supplied amphora analysis---don't think it's much different to amphora calling genes itself
with open('/workdir/users/agk85/CDC/amphora/metagenomes2/' + name + '/' + name + '_phylotype.txt','r') as amphora:
	header = amphora.readline()
	amphora_dict = {}
	for line in amphora:
		idinfo = line.split('\t')[0].split('_')
		id = idinfo[0] + '_scaffold_' + idinfo[2]
		last = line.strip().split('\t')[-1]
		try:
			amphora_dict[id] = amphora_dict[id] + ',' + last
		except KeyError:
			amphora_dict[id] = last
# 
# #card
# with open('/workdir/users/agk85/CDC/card/metagenomes/' + name + '/' + name + '.txt','r') as card:
# 	header = card.readline()
# 	card_dict = {}
# 	for line in card:
# 		idinfo = line.split('\t')[0].split('_')
# 		id = idinfo[0] + '_scaffold_' + idinfo[2]
# 		b_e =  protdict[line.split('\t')[0].split(' ')[0]]
# 		arg = line.split('\t')[8]
# 		arg2 = '-'.join(arg.split(' '))
# 		try:
# 			card_dict[id] = card_dict[id] + ',' + arg2 + '|' + b_e
# 		except KeyError:
# 			card_dict[id] = arg2 + '|' + b_e
# 
# 
# #vogs ----currently rerunning
# with open('/workdir/users/agk85/CDC/phage/metagenomes/' + name + '/' + name + '_modified_vogs.txt.best.filter','r') as vogs:
# 	vogs_dict = {}
# 	for line in vogs:
# 		idinfo = line.split('\t')[2].split('_')
# 		id = idinfo[0] + '_scaffold_' + idinfo[2]
# 		b_e =  protdict[line.split('\t')[2]]
# 		vog = line.split('\t')[0]
# 		bit = line.split('\t')[4]
# 		try:
# 			vogs_dict[id] =vogs_dict[id] + ',' + vog + '|' + bit + '|' + b_e
# 		except KeyError:
# 			vogs_dict[id] =vog + '|' + bit + '|' + b_e
# 
# gaemr
# 16S gene on contig rnammer
# imme
# aclame

############################TODO
####################THIS ISN't the right id (protein id) 
#fixed it but keep an eye on it as it hasn't bee tested
#phaster
# with open('/workdir/users/agk85/CDC/phage/metagenomes/' + name + '/' + name + '_phaster_filter.out','r') as phaster:
# 	phaster_dict = {}
# 	for line in phaster:
# 		idinfo = line.split('\t')[2].split('_')
# 		id = idinfo[0] + '_scaffold_' + idinfo[2]
# 		b_e =  protdict[line.split('\t')[2]]
# 		pid = line.split('\t')[2]
# 		try:
# 			phaster_dict[id] = phaster_dict[id] +',' + pid + '|' + b_e
# 		except KeyError:
# 			phaster_dict[id] = pid + '|' + b_e
# 

# final aggregation
linedict = {}
header = '1.ScfID\t6.Resfams(type|eval|start_stop_rpkm_covg)\t14.Amphora(best_taxonomy(confidence))\n'
for id in ids:
	linedict[id] = id  #1
	#add_program(linedict, cbar_dict, id, "") #2
	#add_program(linedict, plasmid_finder_dict,id, "plasmid_") #3
	#add_program(linedict, full_plasmids_dict,id, "plasmid_") #4
	#add_program(linedict, relaxase_dict, id, "plasmid_") #5
	add_program(linedict, resfam_dict, id, "ARG_") #6
	#add_program(linedict, perfect_dict, id, "ARG_") #7
	#add_program(linedict, card_dict, id, "ARG_") #8
	#add_program(linedict, isescan_dict, id, "IS_") #9
	#add_program(linedict, pf_dict, id, "phage_") #10
	#add_program(linedict, phaster_dict, id, "phage_")#11
	#add_program(linedict, vf_dict, id, "") #12
	#add_program(linedict, vogs_dict, id, "phagevog_") #13
	add_program(linedict, amphora_dict, id, "amphora_") #14 #need to rerun


#write linedict
outfile = open('/workdir/users/agk85/CDC/combo_tables/metagenomes2/' + name + '_master_scf_table.txt','w')
outfile.write(header)
for id in ids:
	outfile.write(linedict[id] + '\n')


outfile.close()

