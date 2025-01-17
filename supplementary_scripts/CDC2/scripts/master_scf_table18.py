#master table for scaffolds
#awk '$6 ~ /plasmid_/' B309-1_master_scf_table.txt
#
#USAGE: python master_scf_table.py B309-1 B309
#this update will include anvio...
#this update will include metaphlan taxonomy
#this updpate will convert to metagenome3 for hic stuffs

import sys
from Bio import SeqIO

def add_program(ldict, p_dict, scfid,ident):
	try:
		ldict[scfid] = ldict[scfid] + '\t' + ident + p_dict[id]
	except KeyError:
		ldict[scfid] = ldict[scfid] + '\t' + '.' 

def viable_levels(taxonomy):
	#because some things don't have families...etc. go one by one back from species
	count = 0
	if 's__;' in taxonomy:
		count += 1
		if 'g__;' in taxonomy:
			count += 1
			if 'f__;' in taxonomy:
				count += 1
				if 'o__;' in taxonomy:
					count += 1 
					if 'c__;' in taxonomy:
						count += 1 
						if 'p__;' in taxonomy:
							count += 1 
							if 'k__;' in taxonomy:
								count += 1 
	good_count = 7-count 
	return good_count


def get_mode(numbers):
	counts = {k:numbers.count(k) for k in set(numbers)}
	modes = sorted(dict(filter(lambda x: x[1] == max(counts.values()), counts.items())).keys())
	return modes

def most_of_the_lot(pidtaxastr):
#after splitting on the name
	hits = pidtaxastr.split(',')
	taxa = []
	pids = []
	for item in hits:
		if 's__' in item:
			taxon = item.split('|')[1]
			pid = item.split('|')[0]
			taxa.append(taxon)
			pids.append(pid)
	mosttaxa = get_mode(taxa)
	linked = []
	for mosttaxon in mosttaxa:
		indices = [i for i, j in enumerate(taxa) if j == mosttaxon]
		mostpids = []
		for index in indices:
			mostpids.append(float(pids[index]))
		maxpid = max(mostpids)
		linked.append((mosttaxon, maxpid))
	most = ''       
	for item in linked:
		if most == '':
			most= str(item[1]) + '|' + item[0]
		else:
			most= most + ',' + str(item[1]) + '|' + item[0]
	return most


def best_org(inline):
	besttaxa = '.'
	maxscore = 0
	levs = 0
	if 'rnammer_' in inline:
		rnammer = inline.split('rnammer_')[1].split('\t')[0]
		clean = most_of_the_lot(rnammer)
		hits = clean.split(',')
		for hit in hits:
			score = float(hit.split('|')[0])
			org = hit.split('|')[1]
			if ((score > maxscore) and (viable_levels(org) > levs)):
				besttaxa = org
				maxscore = score
				levs = viable_levels(org)
	if 'amphora_' in inline:
		amphora = inline.split('amphora_')[1].split('\t')[0]
		clean = most_of_the_lot(amphora)
		hits = clean.split(',')
		for hit in hits:
			score = float(hit.split('|')[0])
			org = hit.split('|')[1]
			if ((score > maxscore) and (viable_levels(org) > levs)):
				besttaxa = org
				maxscore = score
				levs = viable_levels(org)
	if 'barrnap_' in inline:
		barrnap= inline.split('barrnap_')[1].split('\t')[0]
		clean = most_of_the_lot(barrnap)
		hits = clean.split(',')
		for hit in hits:
			score = float(hit.split('|')[0])
			org = hit.split('|')[1]
			if ((score > maxscore) and (viable_levels(org) > levs)):
				besttaxa = org
				maxscore = score
				levs = viable_levels(org)
	if 'campbell_' in inline:
		campbell = inline.split('campbell_')[1].split('\t')[0]
		clean = most_of_the_lot(campbell)
		hits = clean.split(',')
		for hit in hits:
			score = float(hit.split('|')[0])
			org = hit.split('|')[1]
			if ((score > maxscore) and (viable_levels(org) > levs)):
				besttaxa = org
				maxscore = score
				levs = viable_levels(org)
	if 'mtphln_' in inline:
		mtphln = inline.split('mtphln_')[1].split('\t')[0]
		clean = most_of_the_lot(mtphln)
		hits = clean.split(',')
		for hit in hits:
			score = float(hit.split('|')[0])
			org = hit.split('|')[1]
			if ((score > maxscore) and (viable_levels(org) > levs)):
				besttaxa = org
				maxscore = score
				levs = viable_levels(org)
	if 'gsmer_' in inline:
		gsmer = inline.split('gsmer_')[1].split('\t')[0]
		clean = most_of_the_lot(gsmer)
		hits = clean.split(',')
		for hit in hits:
			score = float(hit.split('|')[0])
			org = hit.split('|')[1]
			if ((score > maxscore) and (viable_levels(org) > levs)):
				besttaxa = org
				maxscore = score
				levs = viable_levels(org)
	if besttaxa == 'k__; p__; c__; o__; f__; g__; s__;':
		besttaxa = '.'
	return besttaxa

#this will get the node rank for the taxids
noderank = {}
inhandle = '/workdir/blastdb/newtaxdmp/nodes.dmp'
with open(inhandle) as infile:
	for line in infile:
		fields = line.split("\t|\t")
		taxid = fields[0]
		rank = fields[2]
		noderank[taxid] = rank


ranks = ['species','genus','family','order','class','phylum','kingdom']
delimnames = {'species':'s__','genus':'g__','family':'f__','order':'o__','class':'c__','phylum':'p__','kingdom':'k__'}

def replace_rank(taxonomy, origtaxa, delim):
	"""replace rank taxonomy with the scientific name if in ranks"""
	newtaxonomy = taxonomy.split(delim)[0] + delim + origtaxa + taxonomy.split(delim)[1]
	return newtaxonomy

#taxid
#here take the ranked lineages and then replace with the scientific name of the organism
#if it has uncultured in it...then change to ''
taxid_dict = {}
taxalevel_dict = {}
inhandle = '/workdir/blastdb/newtaxdmp/rankedlineage.dmp'
with open(inhandle) as infile:
	for line in infile:
		taxid = line.split('\t')[0]
		fields = line.split("\t|\t")
		taxonomy = 'k__{0}; p__{1}; c__{2}; o__{3}; f__{4}; g__{5}; s__{6};'.format(fields[9].split('\t')[0], fields[7], fields[6], fields[5], fields[4], fields[3],fields[2].replace(' ', '_'))
		origtaxa = fields[1]
		if 'uncultured' in origtaxa:
			origtaxa = ''
		origtaxarank = noderank[taxid]
		if origtaxarank == 'species':
			origtaxa = origtaxa.replace(' ', '_')
		if origtaxarank in ranks:
			delim = delimnames[origtaxarank]
			newtaxonomy = replace_rank(taxonomy, origtaxa, delim)
		else:
			newtaxonomy = taxonomy
		#remove [ and ] 
		newtaxonomy = newtaxonomy.replace(']','').replace('[','')
		taxid_dict[taxid] = newtaxonomy
		#stuff for mapping with rnammer
		primary = fields[1].replace(' ', '_').replace(']','').replace('[','')
		taxalevel_dict[primary] = newtaxonomy

def lowest_taxonomy(taxonomy):
	levels = ['s__','g__', 'f__', 'o__', 'c__', 'p__', 'k__','k__']
	for i in range(len(levels)):
		taxa = taxonomy.split(levels[i])[1].split(';')[0]
		if taxa != '':
			break
	level = i
	return taxa, level

#merged taxids
inhandle = '/workdir/blastdb/newtaxdmp/merged.dmp'
with open(inhandle) as infile:
	for line in infile:
		oldid = line.split("\t|\t")[0]
		newid = line.split("\t|\t")[1].split('\t')[0]
		taxonomy = taxid_dict[newid]
		taxid_dict[oldid] = taxonomy

####################################################################
#hardcoded
folder = sys.argv[1]
name = sys.argv[2]
patient = sys.argv[3]
#name = 'B309-1'
#patient = 'B309'

#get protein mappings
#with open('/workdir/users/agk85/press/prodigal_excise/metagenomes/combined_prots_length/' + patient + '_nr.fna.clstr','r') as infile:
#	clusterdict = {}
#	clusternum_map = {}
#	for line in infile:
#		if line[0] == '>':
#			cluster = line.strip().split(' ')[1]
#		else:
#			prot =  line.split('>')[1].split('...')[0]
#			clusterdict[prot] = cluster
#			if '*' in line:
#				clusternum_map[cluster] = prot

#get abundance information for genes
#with open('/workdir/users/agk85/press/mapping/metagenomes/bwa_alignments/' + name + '.rpkm.txt','r') as rpkm:
#	rpkmdict = {}
#	header = rpkm.readline()
#	for line in rpkm:
#		id = line.split(',')[0]
#		stat = str(round(float(line.split(',')[1]),2))
#		coverage = str(round(float(line.strip().split(',')[2]),2))
#		rpkmdict[id] = stat + "_" + coverage


protdict = {}
with open('/workdir/users/agk85/' + folder + '/prodigal_excise/metagenomes/' + name + '/' + name + '_proteins.faa','r') as prot:
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
			stat ='NA'
			protdict[id] = b+'_' + e + '_' + stat


ids = []
with open('/workdir/users/agk85/' + folder + '/prodigal_excise/metagenomes/' + name + '/' + name + '_scaffold.fasta','r') as infile:
	for line in infile:
		if line[0] == '>':
			id = line.strip().split(' ')[0].split('>')[1]
			ids.append(id)




length_dict={}
handle = '/workdir/users/agk85/' + folder + '/prodigal_excise/metagenomes/' + name + '/' + name + '_scaffold.fasta'
for rec in SeqIO.parse(handle, "fasta"):
	length_dict[rec.id] = str(len(rec.seq))

	
#phage finder 
with open('/workdir/users/agk85/' + folder + '/prodigal_excise/metagenomes/' + name + '/' + name + '_phagefinder.txt','r') as phagefinder:
	pf_dict = {}
	#header = phagefinder.readline()
	for line in phagefinder:
		id = line.split('\t')[0].split('>')[1]
		b = line.split('\t')[2]
		e = line.strip().split('\t')[3]
		try:
			pf_dict[id] = pf_dict[id]  + ',' + b + '_' + e
		except KeyError:
			pf_dict[id] = b + '_' + e


#plasmidFinder
with open('/workdir/users/agk85/' + folder + '/plasmids/metagenomes/' + name + '/' + name + '_plasmidgenes_filter.out','r') as plasmid_finder:
	plasmid_finder_dict = {}
	for line in plasmid_finder:
		id = line.split('\t')[0]
		pid = line.split('\t')[2]
		b = line.split('\t')[6]
		e = line.split('\t')[7]
		try:
			plasmid_finder_dict[id] = plasmid_finder_dict[id] +',' + pid + '_' + b + '_' + e
		except KeyError:
			plasmid_finder_dict[id] = pid + '_' + b + '_' + e

#Adam's full plasmids
with open('/workdir/users/agk85/' + folder + '/plasmids/metagenomes/' + name + '/' + name + '_fullplasmids_filter.out','r') as full_plasmids:
	full_plasmids_dict = {}
	for line in full_plasmids:
		id = line.split('\t')[0]
		pid = line.split('\t')[2]
		b = line.split('\t')[6]
		e = line.split('\t')[7]
		try:
			full_plasmids_dict[id] = full_plasmids_dict[id] +','+ pid + '_' + b + '_' + e
		except KeyError:
			full_plasmids_dict[id] = pid + '_' + b + '_' + e

#Relaxase
with open('/workdir/users/agk85/' + folder + '/plasmids/metagenomes/' + name + '/' + name + '_relaxase.txt','r') as relaxase:
	relaxase_dict = {}
	for line in relaxase:
		idinfo = line.split('\t')[0].split('_')
		id = idinfo[0] + '_' + idinfo[1] + '_' + idinfo[2]
		b_e = protdict[line.split('\t')[0]]
		eval = line.split('\t')[3]
		try:
			relaxase_dict[id] = relaxase_dict[id] +',' + eval +'|' + b_e 
		except KeyError:
			relaxase_dict[id] = eval +'|' + b_e


#Plasmid_pfams
with open('/workdir/users/agk85/' + folder + '/plasmids/metagenomes/' + name + '/' + name + '_plasmid_pfam.txt','r') as plasmid_pfams:
        plasmid_pfam_dict = {}
        for line in plasmid_pfams:
                idinfo = line.split('\t')[0].split('_')
                id = idinfo[0] + '_' + idinfo[1] + '_' + idinfo[2]
                b_e = protdict[line.split('\t')[0]]
                pfamname = line.split('\t')[3]
                try:
                        plasmid_pfam_dict[id] = plasmid_pfam_dict[id] +',' + pfamname +'|' + b_e
                except KeyError:
                        plasmid_pfam_dict[id] = pfamname +'|' + b_e

#other_pfams
with open('/workdir/users/agk85/' + folder + '/annotation/metagenomes/' + name + '_other_pfam.txt','r') as other_pfams:
	other_pfam_dict = {}
	for line in other_pfams:
		idinfo = line.split('\t')[0].split('_')
		id = idinfo[0] + '_' + idinfo[1] + '_' + idinfo[2]
		b_e = protdict[line.split('\t')[0]]
		pfamname = line.split('\t')[3]
		try:
			other_pfam_dict[id] = other_pfam_dict[id] +',' + pfamname +'|' + b_e
		except KeyError:
			other_pfam_dict[id] = pfamname +'|' + b_e

#resfams
#probably works on others---but B309-5 was empty
with open('/workdir/users/agk85/' + folder + '/resfams/metagenomes/' + name + '/' + name + '_resfams.txt','r') as resfam:
	resfam_dict = {}
	for line in resfam:
		idinfo = line.split('\t')[0].split('_')
		id = idinfo[0] + '_' + idinfo[1] + '_' + idinfo[2]
		arg = line.split('\t')[2]
		eval = line.split('\t')[3]
		b_e =  protdict[line.split('\t')[0]]
		try:
			resfam_dict[id] = resfam_dict[id] +',' + arg + '|' + eval +'|' + b_e 
		except KeyError:
			resfam_dict[id] = arg + '|' + eval +'|' + b_e 


#perfect 100% identity to sequence XXX coverage of reference sequence
with open('/workdir/users/agk85/' + folder + '/resfams/metagenomes/' + name + '/' + name + '_perfect_filter.out','r') as perfect:
	perfect_dict = {}
	for line in perfect:
		id = line.split('\t')[0]
		pid = line.split('\t')[2]
		b = line.split('\t')[6]
		e = line.split('\t')[7]
		try:
			perfect[id] = perfect_dict[id] +','+ pid + '_' + b + '_' + e
		except KeyError:
			perfect_dict[id] = pid + '_' + b + '_' + e

#isescan
with open('/workdir/users/agk85/' + folder + '/iselements/metagenomes/prediction/' + name + '_scaffold.fasta.gff','r') as isescan:
	header = isescan.readline()
	isescan_dict = {}
	for line in isescan:
		if 'insertion_sequence' in line:
			id = line.split('\t')[0]
			type = line.split('family=')[1].split(';')[0]
			b = line.split('\t')[3]
			e = line.split('\t')[4]
			try:
				isescan_dict[id] = isescan_dict[id] + ',' + type + '|' + b + '_' + e
			except KeyError:
				isescan_dict[id] = type + '|' + b + '_' + e


#amphora Using the protein supplied amphora analysis---don't think it's much different to amphora calling genes itself
with open('/workdir/users/agk85/' + folder + '/amphora/metagenomes/' + name + '/' + name + '_amphora.out.best.filter','r') as amphora:
	amphora_dict = {}
	for line in amphora:
		idinfo = line.split('\t')[0].split('_')
		id = idinfo[0] + '_' + idinfo[1] + '_' + idinfo[2]
		taxaid = line.strip().split('\t')[12]
		taxa =taxid_dict[taxaid]
		pid = line.split('\t')[2]
		try:
			amphora_dict[id] = amphora_dict[id] + ',' + pid + '|' + taxa
		except KeyError:
			amphora_dict[id] = pid + '|' + taxa

#card
with open('/workdir/users/agk85/' + folder + '/card/metagenomes/' + name + '/' + name + '.txt','r') as card:
	header = card.readline()
	card_dict = {}
	for line in card:
		idinfo = line.split('\t')[0].split('_')
		id = idinfo[0] + '_' + idinfo[1] + '_' + idinfo[2]
		b_e =  protdict[line.split('\t')[0].split(' ')[0]]
		arg = line.split('\t')[8]
		arg2 = '-'.join(arg.split(' '))
		try:
			card_dict[id] = card_dict[id] + ',' + arg2 + '|' + b_e
		except KeyError:
			card_dict[id] = arg2 + '|' + b_e


#vogs ----currently rerunning
with open('/workdir/users/agk85/' + folder + '/phage/metagenomes/' + name + '/' + name + '_vogs.txt.best.filter','r') as vogs:
	vogs_dict = {}
	for line in vogs:
		idinfo = line.split('\t')[0].split('_')
		id = idinfo[0] + '_' + idinfo[1] + '_' + idinfo[2]
		b_e =  protdict[line.split('\t')[0]]
		vog = line.split('\t')[2]
		bit = line.split('\t')[4]
		try:
			vogs_dict[id] =vogs_dict[id] + ',' + vog + '|' + bit + '|' + b_e
		except KeyError:
			vogs_dict[id] =vog + '|' + bit + '|' + b_e


#phaster
with open('/workdir/users/agk85/' + folder + '/phage/metagenomes/' + name + '/' + name + '_phaster_filter.out','r') as phaster:
	phaster_dict = {}
	for line in phaster:
		idinfo = line.split('\t')[0].split('_')
		id = idinfo[0] + '_' + idinfo[1] + '_' + idinfo[2]
		b_e =  protdict[line.split('\t')[0]]
		pid = line.split('\t')[2]
		try:
			phaster_dict[id] = phaster_dict[id] +',' + pid + '|' + b_e
		except KeyError:
			phaster_dict[id] = pid + '|' + b_e

#rnammer
lastditch_dict = {}
with open('/workdir/users/agk85/CDC/rnammer/gg_13_5_ofinterest_vs_blastdb.out.best') as reffile:
	for line in reffile:
		lastditch_dict[line.split('\t')[0]] = line.strip().split('\t')[12]


#rnammer
with open('/workdir/users/agk85/' + folder + '/rnammer/metagenomes/' + name + '_16S.out.best.withtaxa.txt','r') as rnammer:
	rnammer_dict = {}
	for line in rnammer:
		rnaid = line.split('\t')[0]
		id = rnaid.split('_')[1] + '_' + rnaid.split('_')[2] + '_' + rnaid.split('_')[3]
		pid = line.split('\t')[2]
		if float(pid)>=97:
			b = rnaid.split('_')[4].split('-')[0]
			e = rnaid.split('_')[4].split('-')[1]
			taxa = line.split('\t')[12].strip()
			if "s__;" not in taxa:
				species = taxa.split('s__')[1].split(';')[0]
				genus = taxa.split('g__')[1].split(';')[0]
				newtaxa = taxa.split('s__')[0] + 's__' + genus + '_' + species + ';'
			else:
				newtaxa = taxa
			#replace [] with nothing
			newtaxa = newtaxa.replace('[', '')
			newtaxa = newtaxa.replace(']','')
			try:
				
				lowest, lowest_level = lowest_taxonomy(newtaxa)
				newtaxa = taxalevel_dict[lowest]
			except KeyError:
				try:
					newtaxa = taxid_dict[lastditch_dict[line.split('\t')[1]]]
				except KeyError:
					newtaxa = newtaxa
					print('rnammer:\t', newtaxa)
			try:
				rnammer_dict[id] = rnammer_dict[id] +',' + pid + "|" + newtaxa
			except KeyError:
				rnammer_dict[id] = pid + "|" + newtaxa
	


#imme
imme_phage_dict = {}
imme_plasmid_dict = {}
imme_transposon_dict = {}
imme_intron_dict = {}
imme_gi_dict = {}
immedb = {}
immedb_file = '/workdir/refdbs/ImmeDB/MGE_sequences.fasta'
with open(immedb_file) as immedb_seqs:
	for line in immedb_seqs:
		if line[0] == '>':
			immeid = line.split(' ')[0].split('>')[1]
			element = line.strip().split(' ')[1]
			immedb[immeid] = element

with open('/workdir/users/agk85/' + folder + '/imme/metagenomes/' + name + '/' + name + '_imme_filter.out','r') as imme:
	for line in imme:
		id = line.split('\t')[0]
		pid = line.split('\t')[2]
		b = line.split('\t')[6]
		e = line.split('\t')[7]
		element_accession = line.split('\t')[1]
		element = immedb[element_accession]
		if 'Prophage' in element:
			imme_dict = imme_phage_dict
		if ('ICE' in element) or ('IME' in element):
			imme_dict = imme_plasmid_dict
		if 'Transposon' in element:
			imme_dict = imme_transposon_dict
		if 'GroupII' in element:
			imme_dict = imme_intron_dict
		if ('GI' in element) or ('Islet' in element):
			imme_dict = imme_gi_dict
		try:
			imme_dict[id] = imme_dict[id] +',' + element + '_' + pid + '_' + b + '_' + e
		except KeyError:
			imme_dict[id] = element + '_' + pid + '_' + b + '_' + e
										 
#trnascan
with open('/workdir/users/agk85/' + folder + '/trnascan/metagenomes/' + name + '_trnascan.txt','r') as trnascan:
	header = trnascan.readline() # three lines are header
	header = trnascan.readline()
	header = trnascan.readline()
	trnascan_dict = {}
	for line in trnascan:
		id = line.split()[0]
		cove = line.strip().split('\t')[8]
		b =  line.split()[2]
		e = line.split()[3]
		trna = line.split()[4]
		try:
			trnascan_dict[id] = trnascan_dict[id] +',' + trna+ '_' +cove + '_' + b + '_' + e
		except KeyError:
			trnascan_dict[id] = trna + '_' +cove + '_' + b + '_' + e



#aclame
with open('/workdir/users/agk85/' + folder + '/aclame/metagenomes/' + name + '/' + name + '_aclame_filter.out','r') as aclame:
	aclame_plasmid_dict = {}
	aclame_phage_dict = {}
	for line in aclame:
		idinfo = line.split('\t')[0].split('_')
		id = idinfo[0] + '_' + idinfo[1] + '_' + idinfo[2]
		b_e =  protdict[line.split('\t')[0]]
		mge= line.split('\t')[1].split(':')[1]
		if mge == 'plasmid':
			try:
				aclame_plasmid_dict[id] = aclame_plasmid_dict[id] + ',' + mge + '|' + b_e
			except KeyError:
				aclame_plasmid_dict[id] = mge+ '|' + b_e
		if ((mge == 'proph') | (mge == 'vir')):
			try:
				aclame_phage_dict[id] = aclame_phage_dict[id] + ',' + mge + '|' + b_e
			except KeyError:
				aclame_phage_dict[id] = mge+ '|' + b_e


#vf
with open('/workdir/users/agk85/' + folder + '/vf/metagenomes/' + name + '/' + name + '_vf_filter.out','r') as vf:
	vf_dict = {}
	vf_db = {}
	vf_file = open('/workdir/refdbs/VFs/VFDB_setA_pro.fas','r')
	for line in vf_file:
		if line[0] == '>':
			vf_db[line.split(' ')[0].split('>')[1]] = line.split(' ')[1]
	for line in vf:
		idinfo = line.split('\t')[0].split('_')
		id = idinfo[0] + '_' + idinfo[1] + '_' + idinfo[2]
		b_e =  protdict[line.split('\t')[0]]
		pid = line.split('\t')[2]
		subject = line.split('\t')[1]
		gene = vf_db[subject].split('(')[1].split(')')[0]
		try:
			vf_dict[id] = vf_dict[id] +',' + gene + '|' + pid + '|' + b_e
		except KeyError:
			vf_dict[id] = gene + '|' + pid + '|' + b_e


#maxbin
#bin_dict = {}
#with open('/workdir/users/agk85/press/maxbin/metagenomes/' + name + '/' + name + '.stats') as binstats:
#	header = binstats.readline()
#	for line in binstats:
#		binid = line.split('\t')[0]
#		bin_dict[binid] = line.strip()



#maxbin_dict = {}
#with open('/workdir/users/agk85/press/maxbin/metagenomes/' + name + '/' + name +'_binid_contig.txt') as maxbin:
#	for line in maxbin:
#		scfid = line.strip().split('>')[1]
#		binid = line.split('/')[1].split('.')[0] + '.' + line.split('.')[1]
#		binline = bin_dict[binid]
#		org = binline.split('\t')[1]
#		completeness= binline.split('\t')[2]
#		contamination= binline.split('\t')[3]
#		heterogeneity = binline.strip().split('\t')[4]
#		maxbin_dict[scfid] = '{0}|{1}|{2}|{3}'.format(binid, org, completeness, contamination)


#barrnap
with open('/workdir/users/agk85/' + folder + '/ribosomes/metagenomes/'+ name + '_ribosomes.out.best.filter','r') as barrnap:
	barrnap_dict = {}
	for line in barrnap:
		scfid = line.split('\t')[0].split(':')[2]
		pid = line.split('\t')[2]
		taxa = 'k__; p__; c__; o__; f__; g__; s__;'
		taxid = line.strip().split('\t')[12]
		try:
			taxa = taxid_dict[taxid]
		except KeyError:
			taxids = taxid.split(';')
			for subtaxid in taxids:
				possible_taxa = taxid_dict[subtaxid]
				if (viable_levels(possible_taxa) > viable_levels(taxa)):
					taxa = possible_taxa
		try:
			barrnap_dict[scfid] = barrnap_dict[scfid] + ',' + pid + '|' + taxa
		except KeyError:
			barrnap_dict[scfid] = pid + '|' + taxa



#campbell
with open('/workdir/users/agk85/' + folder + '/campbell/metagenomes/' +name+'/' + name + '_campbell.out.best.filter','r') as campbell:
	campbell_dict = {}
	for line in campbell:
		idinfo = line.split('\t')[0].split('_')
		id = idinfo[0] + '_' + idinfo[1] + '_' + idinfo[2]
		pid = line.split('\t')[2]
		taxa = 'k__; p__; c__; o__; f__; g__; s__;'
		taxid = line.strip().split('\t')[12]
		try:
			taxa = taxid_dict[taxid]
		except KeyError:
			taxids = taxid.split(';')
			for subtaxid in taxids:
				possible_taxa = taxid_dict[subtaxid]
				if (viable_levels(possible_taxa) > viable_levels(taxa)):
					taxa = possible_taxa
		try:
			campbell_dict[id] = campbell_dict[id] +',' + pid + '|' + taxa
		except KeyError:
			campbell_dict[id] = pid + '|' + taxa


#mtphln_dict
#load metaphlan marker information
marker_dict = {}
inhandle = '/workdir/refdbs/metaphlan/markers_info.txt'
with open(inhandle) as reffile:
	for line in reffile:
		markid = line.split('\t')[0]
		taxa = line.split("'taxon': '")[1].split("'}")[0].split('|t__')[0]
		elements = taxa.split('|')
		newformat = '; '.join(elements)
		filledin = newformat
		if 'k__' not in newformat:
			filledin = filledin + 'k__'
		if 'p__' not in newformat:
			filledin = filledin + '; p__'
		if 'c__' not in newformat:
			filledin = filledin + '; c__'
		if 'o__' not in newformat:
			filledin = filledin + '; o__'
		if 'f__' not in newformat:
			filledin = filledin + '; f__'
		if 'g__' not in newformat:
			filledin = filledin + '; g__'
		if 's__' not in newformat:
			filledin = filledin + '; s__;'
		else:
			filledin = filledin + ';'
		marker_dict[markid] = filledin


inhandle = '/workdir/refdbs/metaphlan/marker_info_taxid.txt'
with open(inhandle) as reffile:
	for line in reffile:
		markid = line.split('\t')[1]
		taxid = line.split('\t')[0]
		marker_dict[markid] = taxid


#metaphlan_taxonomy
with open('/workdir/users/agk85/' + folder + '/mtphln/metagenomes/' + name + '/'+name+'_metaphlan.out.best.filter', 'r') as mtphln:
	with open('/workdir/users/agk85/' + folder + '/mtphln/metagenomes/'+name + '/' + name + '_metaphlan.no_ncbi_taxid.txt','w') as bad_mtphln:
		mtphln_dict = {}
		for line in mtphln:
			idinfo = line.split('\t')[0].split('_')
			scfid = idinfo[0] + '_' + idinfo[1] + '_' + idinfo[2]
			pid = line.split('\t')[2]
			mtphlnid = line.split('\t')[1]
			info = marker_dict[mtphlnid]
			try:
				k = int(info)
				taxa = taxid_dict[info]
			except ValueError:
				taxa = info
				print('mtphln:\t', taxa)
				bad_mtphln.write('{0}\t{1}\t{2}\t{3}\t{4}\n'.format("mtphln", scfid, pid, mtphlnid, info ))
			try:
				mtphln_dict[scfid] = mtphln_dict[scfid] + ',' + pid + '|' + taxa
			except KeyError:
				mtphln_dict[scfid] = pid + '|' + taxa		


#gsmer_taxonomy
with open('/workdir/users/agk85/' + folder + '/gsmer/metagenomes/' + name + '/'+name+'_gsmer.out.filter.taxonomy', 'r') as gsmer:
	gsmer_dict = {}
	gsmer_many_dict = {}
	for line in gsmer:
		scfid = line.split('\t')[0]
		pid = line.split('\t')[2]
		taxa = line.split('\t')[12].strip()
		try:
			gsmer_many_dict[scfid] = gsmer_many_dict[scfid] + ',' + pid + '|' + taxa
		except KeyError:
			gsmer_many_dict[scfid] = pid + '|' + taxa

for key in gsmer_many_dict:
	alltaxonomies = gsmer_many_dict[key]
	bestbunch = most_of_the_lot(alltaxonomies)	
	gsmer_dict[key] = bestbunch


#single copies
def mode_taxonomy(olddict):
	newdict = {}
	for key in olddict:
        	alltaxonomies = olddict[key]
        	bestbunch = most_of_the_lot(alltaxonomies)
        	newdict[key] = bestbunch
	return newdict

gsmer_single_dict = mode_taxonomy(gsmer_many_dict)
mtphln_single_dict = mode_taxonomy(mtphln_dict)
amphora_single_dict= mode_taxonomy(amphora_dict)
campbell_single_dict = mode_taxonomy(campbell_dict)
rnammer_single_dict = mode_taxonomy(rnammer_dict)
barrnap_single_dict = mode_taxonomy(barrnap_dict)



#mobile pfam genes
plasmid_pfams = []
with open('/workdir/users/agk85/CDC/annotation/Plasmid_pfamids.txt','r') as pfam_file:
	for line in pfam_file:
		plasmid_pfams.append(line.strip())

phage_pfams = []
with open('/workdir/users/agk85/CDC/annotation/Phage_pfamids.txt','r') as pfam_file:
	for line in pfam_file:
		phage_pfams.append(line.strip())

transposon_pfams = []
with open('/workdir/users/agk85/CDC/annotation/Transposon_pfamids.txt','r') as pfam_file:
	for line in pfam_file:
		transposon_pfams.append(line.strip())

other_pfams = []
with open('/workdir/users/agk85/CDC/annotation/Other_pfamids.txt','r') as pfam_file:
	for line in pfam_file:
		other_pfams.append(line.strip())

with open('/workdir/users/agk85/' + folder + '/annotation/metagenomes/'+name+'_mobilegenes.txt', 'r') as mobile_pfam:
	mobile_pfam_dict = {}
	mobile_pfam_plasmid_dict = {}
	mobile_pfam_phage_dict = {}
	mobile_pfam_transposon_dict = {}
	mobile_pfam_other_dict = {}
	for line in mobile_pfam:
		idinfo = line.split('\t')[0].split('_')
		scfid = idinfo[0] + '_' + idinfo[1] + '_' + idinfo[2]
		pfamid = line.split('\t')[7]
		if pfamid in plasmid_pfams:
			mobile_pfam_plasmid_dict[scfid] = '1'
		if pfamid in phage_pfams:
			mobile_pfam_phage_dict[scfid] = '1'
		if pfamid in transposon_pfams:
			mobile_pfam_transposon_dict[scfid] = '1'
		if pfamid in other_pfams:
			mobile_pfam_other_dict[scfid] = '1'
		try:
			mobile_pfam_dict[scfid] = str(int(mobile_pfam_dict[scfid]) + 1)
		except KeyError:
			mobile_pfam_dict[scfid] = '1'


#plasflow
with open('/workdir/users/agk85/' + folder + '/plasmids/metagenomes/'+name+'/' + name + '_plasflow.txt_plasmids.fasta','r') as plasflow:
	plasflow_dict = {}
	for line in plasflow:
		if line[0] == '>':
			scfid=line.split('>')[1].split(' ')[0]
			origin=line.split(' ')[1]
			plasflow_dict[scfid] = origin

#kraken

with open('/workdir/users/agk85/' + folder + '/kraken/' + name + '/' + name + '.kraken.taxonomy.txt', 'r') as kraken:
	kraken_dict = {}
	markerlist = ['d','p','c','o','f','g','s']
	for line in kraken:
		base_marker = {'d':'','p':'','c':'','o':'','f':'','g':'','s':''}
		scfid = line.split('\t')[0]
		taxonomy = line.strip().split('\t')[1]
		taxonomy_fields = taxonomy.split('|')
		for field in taxonomy_fields:
			if field != 'root':
				marker = field.split('__')[0]
				taxa = field.split('__')[1]
				if marker in markerlist:
					base_marker[marker] = taxa
		parsedtaxonomy = ''
		for marker in markerlist:
			#standard marker is 'k' for kingdom instead of domain, so switching that
			if marker == 'd':
				parsedtaxonomy = parsedtaxonomy + 'k__' + base_marker[marker]
			else:
				parsedtaxonomy = parsedtaxonomy + marker + '__' + base_marker[marker]
			#my taxonomy format stupidly has semicolon then spaces except after the species
			if marker != 's':
				parsedtaxonomy = parsedtaxonomy + '; '
			else:
				parsedtaxonomy = parsedtaxonomy + ';'
		kraken_dict[scfid] = parsedtaxonomy


#gaemr
with open('/workdir/users/agk85/' + folder + '/gaemr/metagenomes/'+name+'/gaemr/table/'+name+'.scf.taxa.percent.txt','r') as gaemr:
	gaemr_dict = {}
	for line in gaemr:
		scfid = line.split('\t')[0]
		taxa = line.strip().split('\t')[1]
		percent = line.strip().split('\t')[2].strip()
		gaemr_dict[scfid] = taxa + '|' + percent

# final aggregation
linedict = {}
header = 'ScfID\tLength\tPlasmid_Finder(pid|start_stop)\tFull_Plasmids(pid|start_stop)\tRelaxase(eval|start_stop_rpkm_covg)\tPlasmid_pfams(name|start_stop_rpkm_covg)\tResfams(type|eval|start_stop_rpkm_covg)\tPerfect(pid|start_stop)\tCARD(arg|start_stop_rpkm_covg)\tISEScan(type|start_stop_rpkm_covg)\tPhage_Finder(start_stop)\tPhaster(pid|start_stop)\tVOGS(vog|bit|start_stop_rpkm_covg)\tVF(gene|pid|start_stop_rpkm_covg)\ttRNASCAN(trna_cove_start_stop)\tImme_plasmid(element_pid_start_stop)\tImme_phage(element_pid_start_stop)\tImme_transposon(element_pid_start_stop)\tImme_intron(element_pid_start_stop)\tImme_gi(element_pid_start_stop)\tAclame_plasmid(element_pid_start_stop)\tAclame_phage(element_pid_start_stop)\tOther_pfams(name|start_stop_rpkm_covg)\tAmphora(best_taxonomy(confidence))\tRnammer(taxa_pid_start_stop)\tBarrnap(pid|taxa)\tCampbell(pid|taxa)\tMetaphlan(pid|taxa)\tGSMer(pid|taxa)\tMobile_pfams(count)\tPfams_plasmid(pres)\tPfams_phage(pres)\tPfams_transposon(pres)\tPfams_other(pres)\tPlasflow(origin)\tKraken(taxa)\tGaemr(taxa|percent)\tVirus(taxonomy)\tMGE(ornot)\tBest_org(amphora_rnammer)\n'

#\tMaxbin(bin_taxa_completeness_contamination)

for id in ids:
	linedict[id] = id  #1
	add_program(linedict, length_dict, id, 'length_')#2
	add_program(linedict, plasmid_finder_dict,id, "1plasmid_") #3
	add_program(linedict, full_plasmids_dict,id, "2plasmid_") #4
	add_program(linedict, relaxase_dict, id, "3plasmid_") #5
	add_program(linedict, plasmid_pfam_dict, id, "4plasmid_")#6
	add_program(linedict, resfam_dict, id, "1ARG_") #7
	add_program(linedict, perfect_dict, id, "2ARG_") #8
	add_program(linedict, card_dict, id, "3ARG_") #9
	add_program(linedict, isescan_dict, id, "IS_") #10
	add_program(linedict, pf_dict, id, "1phage_") #11
	add_program(linedict, phaster_dict, id, "2phage_")#12
	add_program(linedict, vogs_dict, id, "phagevog_") #13
	add_program(linedict, vf_dict, id, "vf_") #14
	add_program(linedict, trnascan_dict, id, "trna_") #15
	add_program(linedict, imme_plasmid_dict, id, "5plasmid_") #16
	add_program(linedict, imme_phage_dict, id, "3phage_") #17
	add_program(linedict, imme_transposon_dict, id, "transposon_") #18
	add_program(linedict, imme_intron_dict, id, "intron_")#19
	add_program(linedict, imme_gi_dict, id, "gi_")#20
	add_program(linedict, aclame_plasmid_dict, id, "6plasmid_") #21
	add_program(linedict, aclame_phage_dict, id, "4phage_") #22
	add_program(linedict, other_pfam_dict, id, "other_") #23
	add_program(linedict, amphora_single_dict, id, "amphora_") #24
	add_program(linedict, rnammer_single_dict, id, "rnammer_") #25
	add_program(linedict, barrnap_single_dict, id, "barrnap_")#26
	add_program(linedict, campbell_single_dict, id, "campbell_") # 27
	add_program(linedict, mtphln_single_dict,id, "mtphln_") #28
	add_program(linedict, gsmer_single_dict,id, "gsmer_") #29
	add_program(linedict, mobile_pfam_dict,id, "mobilepfam_") #30
	add_program(linedict, mobile_pfam_plasmid_dict, id, "7plasmid_")#31
	add_program(linedict, mobile_pfam_phage_dict, id, "5phage_")#32
	add_program(linedict, mobile_pfam_transposon_dict, id, "2transposon_")#33
	add_program(linedict, mobile_pfam_other_dict, id, "1other_")#34
	add_program(linedict, plasflow_dict, id, "8plasmid_")#35
	add_program(linedict, kraken_dict, id, "kraken_")#36
	add_program(linedict, gaemr_dict, id, "gaemr_")#37
	#add_program(linedict, kraken_dict, id, "kraken_")#38

#	add_program(linedict, maxbin_dict, id, "maxbin_") 
#write linedict

for id in ids:
	newline = linedict[id]
	if 'kraken' in newline:
		bestorg =newline.split('kraken_')[1].split('\t')[0]  #best_org(newline) 
	else:
		bestorg = '.'
	#bestorg = newline.split('gaemr_')[1].split('\t')[0]
	fields = newline.split('\t')
	#incorporates all the mobile things
	if ((fields[2] + fields[3] + fields[4] + fields[5] + fields[9] + fields[10] + fields[11] + fields[15] + fields[16] + fields[17] + fields[20] + fields[21]+fields[29] + fields[30] + fields[31] + fields[32] + fields[34]) == '.................') and ('Viruses' not in bestorg):
		linedict[id] = linedict[id] + '\t.\t.'
	elif ('k__Viruses' in bestorg):
		linedict[id] = linedict[id] + '\tVirus_taxonomy\tmge' #37
	else: 
		linedict[id] = linedict[id] + '\t.\tmge' #38
	linedict[id] = linedict[id] + '\t' + bestorg #39


outfile = open('/workdir/users/agk85/' + folder + '/combo_tables/metagenomes/' + name + '_master_scf_table.txt','w')
eukfile = open('/workdir/users/agk85/' + folder + '/combo_tables/metagenomes/' + name + '_euk.txt','w')
outfile.write(header)
for id in ids:
	if 'k__Eukaryo' in linedict[id].split('\t')[-1]:
		eukfile.write(linedict[id]+ '\n')
	else:
		outfile.write(linedict[id] + '\n')


outfile.close()
eukfile.close()
