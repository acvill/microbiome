#master table for scaffolds
#awk '$6 ~ /plasmid_/' B309-1_master_scf_table.txt
#
#USAGE: python master_scf_table.py B309-1 B309
#this update will include anvio...
#this update will include metaphlan taxonomy

import sys

def add_program(ldict, p_dict, scfid,ident):
	try:
		ldict[scfid] = ldict[scfid] + '\t' + ident + p_dict[id]
	except KeyError:
		ldict[scfid] = ldict[scfid] + '\t' + '.' 


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
	if 'rnammer_' in inline:
		rnammer = inline.split('rnammer_')[1].split('\t')[0]
		clean = most_of_the_lot(rnammer)
		hits = clean.split(',')
		for hit in hits:
			score = float(hit.split('|')[0])
			org = hit.split('|')[1]
			if ((score > maxscore) and ('s__;' not in org)):
				besttaxa = org
				maxscore = score
	if 'amphora_' in inline:
		amphora = inline.split('amphora_')[1].split('\t')[0]
		clean = most_of_the_lot(amphora)
		hits = clean.split(',')
		for hit in hits:
			score = float(hit.split('|')[0])*100
			org = hit.split('|')[1]
			if ((score > maxscore) and ('s__;' not in org)):
				besttaxa = org
				maxscore = score
	if 'anvio_' in inline:
		anvio = inline.split('anvio_')[1].split('\t')[0]
		clean = most_of_the_lot(anvio)
		hits = clean.split(',')
		for hit in hits:
			score = float(hit.split('|')[0])
			org = hit.split('|')[1]
			if ((score > maxscore) and ('s__;' not in org)):
				besttaxa = org
				maxscore = score
	if 'mtphln_' in inline:
		mtphln = inline.split('mtphln_')[1].split('\t')[0]
		clean = most_of_the_lot(mtphln)
		hits = clean.split(',')
		for hit in hits:
			score = float(hit.split('|')[0])
			org = hit.split('|')[1]
			if ((score > maxscore) and ('s__;' not in org)):
				besttaxa = org
				maxscore = score
	if 'gsmer_' in inline:
		gsmer = inline.split('gsmer_')[1].split('\t')[0]
		clean = most_of_the_lot(gsmer)
		hits = clean.split(',')
		for hit in hits:
			score = float(hit.split('|')[0])
			org = hit.split('|')[1]
			if ((score > maxscore) and ('s__;' not in org)):
				besttaxa = org
				maxscore = score
	return besttaxa


#taxid
taxid_dict = {}
inhandle = '/workdir/blastdb/newtaxdmp/rankedlineage.dmp'
with open(inhandle) as infile:
	for line in infile:
		taxid = line.split('\t')[0]
		fields = line.split("\t|\t")
		taxonomy = 'k__{0}; p__{1}; c__{2}; o__{3}; f__{4}; g__{5}; s__{6};'.format(fields[9].split('\t')[0], fields[7], fields[6], fields[5], fields[4], fields[3],fields[2])
		taxid_dict[taxid] = taxonomy

#hardcoded
name = sys.argv[1]
patient = sys.argv[2]
#name = 'B309-1'
#patient = 'B309'

with open('/workdir/users/agk85/CDC/prodigal_excise/metagenomes2/combined_prots_length/' + patient + '_nr.fna.clstr','r') as infile:
	clusterdict = {}
	clusternum_map = {}
	for line in infile:
		if line[0] == '>':
			cluster = line.strip().split(' ')[1]
		else:
			prot =  line.split('>')[1].split('...')[0]
			clusterdict[prot] = cluster
			if '*' in line:
				clusternum_map[cluster] = prot


with open('/workdir/users/agk85/CDC/mapping/metagenomes2/bwa_alignments/' + name + '.rpkm.txt','r') as rpkm:
	rpkmdict = {}
	header = rpkm.readline()
	for line in rpkm:
		id = line.split(',')[0]
		stat = str(round(float(line.split(',')[1]),2))
		coverage = str(round(float(line.strip().split(',')[2]),2))
		rpkmdict[id] = stat + "_" + coverage


protdict = {}
with open('/workdir/users/agk85/CDC/prodigal_excise/metagenomes2/' + name + '/' + name + '_proteins.faa','r') as prot:
	for line in prot:
		if line[0] == '>':
			id = line.split('>')[1].split(' ')[0]
			b = line.split(' # ')[1]
			e = line.split(' # ')[2]
			clusternum = clusterdict[id]
			prot = clusternum_map[clusternum]
			try:
				stat = rpkmdict[prot]
			except KeyError:
				stat = 'NA'
			protdict[id] = b+'_' + e + '_' + stat


ids = []
with open('/workdir/users/agk85/CDC/prodigal_excise/metagenomes2/' + name + '/' + name + '_scaffold.fasta','r') as infile:
	for line in infile:
		if line[0] == '>':
			id = line.strip().split(' ')[0].split('>')[1]
			ids.append(id)


#phage finder 
with open('/workdir/users/agk85/CDC/prodigal_excise/metagenomes2/' + name + '/' + name + '_phagefinder.txt','r') as phagefinder:
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

#virFinder	  
# with open('/workdir/users/agk85/CDC/phage/metagenomes2/' + name + '/' + name + '_virfinder.txt','r') as virfinder:
#	header = virfinder.readline()
#	vf_dict = {}
#	for line in virfinder:
#		id = line.split('\t')[1].split('"')[1].split(' ')[0]
#		pval = str(round(float(line.strip().split('\t')[4]),4))
#		vf_dict[id] = pval

#cbar
# with open('/workdir/users/agk85/CDC/plasmids/metagenomes2/' + name + '/' + name + '_cbar.txt','r') as cbar:
#	 header = cbar.readline()
#	 cbar_dict = {}
#	 for line in cbar:
#		 id = line.split('\t')[0]
#		 type = line.strip().split('\t')[2]
#		 cbar_dict[id] = type

#plasmidFinder
with open('/workdir/users/agk85/CDC/plasmids/metagenomes2/' + name + '/' + name + '_plasmidgenes_filter.out','r') as plasmid_finder:
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
with open('/workdir/users/agk85/CDC/plasmids/metagenomes2/' + name + '/' + name + '_fullplasmids_filter.out','r') as full_plasmids:
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
#probably works on others---but B309-5 was empty
with open('/workdir/users/agk85/CDC/plasmids/metagenomes2/' + name + '/' + name + '_relaxase.txt','r') as relaxase:
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


#resfams
#probably works on others---but B309-5 was empty
with open('/workdir/users/agk85/CDC/resfams/metagenomes2/' + name + '/' + name + '_resfams.txt','r') as resfam:
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
with open('/workdir/users/agk85/CDC/resfams/metagenomes2/' + name + '/' + name + '_perfect_filter.out','r') as perfect:
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
with open('/workdir/users/agk85/CDC/iselements/metagenomes/prediction/' + name + '_isescan.txt','r') as isescan:
	isescan_dict = {}
	for line in isescan:
		id = line.split('\t')[0].split('>')[1]
		b = line.split('\t')[2]
		e = line.strip().split('\t')[3]
		try:
			isescan_dict[id] = isescan_dict[id] + ',' + b + '_' + e
		except KeyError:
			isescan_dict[id] = b + '_' + e



#amphora Using the protein supplied amphora analysis---don't think it's much different to amphora calling genes itself
with open('/workdir/users/agk85/CDC/amphora/metagenomes2/' + name + '/' + name + '_amphora.out.best.filter','r') as amphora:
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
with open('/workdir/users/agk85/CDC/card/metagenomes2/' + name + '/' + name + '.txt','r') as card:
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
with open('/workdir/users/agk85/CDC/phage/metagenomes2/' + name + '/' + name + '_vogs.txt.best.filter','r') as vogs:
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
with open('/workdir/users/agk85/CDC/phage/metagenomes2/' + name + '/' + name + '_phaster_filter.out','r') as phaster:
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
with open('/workdir/users/agk85/CDC/rnammer/metagenomes2/' + name + '_16S.out.best.withtaxa.txt','r') as rnammer:
	rnammer_dict = {}
	for line in rnammer:
		rnaid = line.split('\t')[0]
		id = rnaid.split('_')[1] + '_' + rnaid.split('_')[2] + '_' + rnaid.split('_')[3]
		pid = line.split('\t')[2]
		b = rnaid.split('_')[4].split('-')[0]
		e = rnaid.split('_')[4].split('-')[1]
		taxa = line.split('\t')[12].strip()
		if "s__;" not in taxa:
			species = taxa.split('s__')[1].split(';')[0]
			genus = taxa.split('g__')[1].split(';')[0]
			newtaxa = taxa.split('s__')[0] + 's__' + genus + ' ' + species + ';'
		else:
			newtaxa = taxa 
		try:
			rnammer_dict[id] = rnammer_dict[id] +',' + pid + "|" + newtaxa
		except KeyError:
			rnammer_dict[id] = pid + "|" + newtaxa

#imme
with open('/workdir/users/agk85/CDC/imme/metagenomes2/' + name + '/' + name + '_imme_filter.out','r') as imme:
	imme_dict = {}
	immedb = {}
	immedb_file = '/workdir/refdbs/ImmeDB/MGE_sequences.fasta'
	with open(immedb_file) as immedb_seqs:
		for line in immedb_seqs:
			if line[0] == '>':
				immeid = line.split(' ')[0].split('>')[1]
				element = line.strip().split(' ')[1]
				immedb[immeid] = element
	
	for line in imme:
		id = line.split('\t')[0]
		pid = line.split('\t')[2]
		b = line.split('\t')[6]
		e = line.split('\t')[7]
		element_accession = line.split('\t')[1]
		element = immedb[element_accession]
		try:
			imme_dict[id] = imme_dict[id] +',' + element + '_' + pid + '_' + b + '_' + e
		except KeyError:
			imme_dict[id] = element + '_' + pid + '_' + b + '_' + e

#trnascan
with open('/workdir/users/agk85/CDC/trnascan/metagenomes2/' + name + '_trnascan.txt','r') as trnascan:
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
with open('/workdir/users/agk85/CDC/aclame/metagenomes2/' + name + '/' + name + '_aclame_filter.out','r') as aclame:
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
with open('/workdir/users/agk85/CDC/vf/metagenomes2/' + name + '/' + name + '_vf_filter.out','r') as vf:
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
bin_dict = {}
with open('/workdir/users/agk85/CDC/maxbin/' + name + '/' + name + '.stats') as binstats:
	header = binstats.readline()
	for line in binstats:
		binid = line.split('\t')[0]
		bin_dict[binid] = line.strip()



maxbin_dict = {}
with open('/workdir/users/agk85/CDC/maxbin/' + name + '/' + name +'_binid_contig.txt') as maxbin:
	for line in maxbin:
		scfid = line.strip().split('>')[1]
		binid = line.split('/')[1].split('.')[0] + '.' + line.split('.')[1]
		binline = bin_dict[binid]
		org = binline.split('\t')[1]
		completeness= binline.split('\t')[2]
		contamination= binline.split('\t')[3]
		heterogeneity = binline.strip().split('\t')[4]
		maxbin_dict[scfid] = '{0}|{1}|{2}|{3}'.format(binid, org, completeness, contamination)

#anvio
with open('/workdir/users/agk85/CDC/anvio/' + name + '_bscg_filter.out','r') as anvio:
	anvio_dict = {}
	for line in anvio:
		#only take if in campbell or ribosomal
		if 'Campbell_et_al' or 'Ribosomal_RNAs' in line:
			id = line.split('|')[0]
			pid = line.split('\t')[2]
			taxa = ''
			taxid = line.strip().split('\t')[12]
			try:
				taxa = taxid_dict[taxid]
			except KeyError:
				taxids = taxid.split(';')
				for subtaxid in taxids:
					possible_taxa = taxid_dict[subtaxid]
					if len(possible_taxa) > len(taxa):
						taxa = possible_taxa
			try:
				anvio_dict[id] = anvio_dict[id] +',' + pid + '|' + taxa
			except KeyError:
				anvio_dict[id] = pid + '|' + taxa


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



#metaphlan_taxonomy
with open('/workdir/users/agk85/CDC/mtphln/metagenomes2/' + name + '/'+name+'_metaphlan.out.best.filter', 'r') as mtphln:
	mtphln_dict = {}
	for line in mtphln:
		idinfo = line.split('\t')[0].split('_')
		scfid = idinfo[0] + '_' + idinfo[1] + '_' + idinfo[2]
		pid = line.split('\t')[2]
		taxid = line.split('\t')[1]
		taxa = marker_dict[taxid]
		try:
			mtphln_dict[scfid] = mtphln_dict[scfid] + ',' + pid + '|' + taxa
		except KeyError:
			mtphln_dict[scfid] = pid + '|' + taxa		


#gsmer_taxonomy
with open('/workdir/users/agk85/CDC/gsmer/metagenomes2/' + name + '/'+name+'_gsmer.out.filter.taxonomy', 'r') as gsmer:
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
anvio_single_dict = mode_taxonomy(anvio_dict)
rnammer_single_dict = mode_taxonomy(rnammer_dict)

# final aggregation
linedict = {}
header = 'ScfID\tPlasmid_Finder(pid|start_stop)\tFull_Plasmids(pid|start_stop)\tRelaxase(eval|start_stop_rpkm_covg)\tResfams(type|eval|start_stop_rpkm_covg)\tPerfect(pid|start_stop)\tCARD(arg|start_stop_rpkm_covg)\tISEScan(type|start_stop_rpkm_covg)\tPhage_Finder(start_stop)\tPhaster(pid|start_stop)\tVOGS(vog|bit|start_stop_rpkm_covg)\tVF(gene|pid|start_stop_rpkm_covg)\ttRNASCAN(trna_cove_start_stop)\tImme(element_pid_start_stop)\tAclame_plasmid(element_pid_start_stop)\tAclame_phage(element_pid_start_stop)\tAmphora(best_taxonomy(confidence))\tRnammer(taxa_pid_start_stop)\tAnvio(pid|taxa)\tMaxbin(bin_taxa_completeness_contamination)\tBest_org(amphora_rnammer)\n'

#header = '1.ScfID\t2.Plasmid_Finder(pid|start_stop)\t3.Full_Plasmids(pid|start_stop)\t4.Relaxase(eval|start_stop_rpkm_covg)\t5.Resfams(type|eval|start_stop_rpkm_covg)\t6.Perfect(pid|start_stop)\t7.CARD(arg|start_stop_rpkm_covg)\t8.ISEScan(type|start_stop_rpkm_covg)\t9.Phage_Finder(start_stop)\t10.Phaster(pid|start_stop)\t11.VOGS(vog|bit|start_stop_rpkm_covg)\t13.VF(gene|pid|start_stop_rpkm_covg)\t13.tRNASCAN(trna_cove_start_stop)\t14.Imme(element_pid_start_stop)\t15.Aclame_plasmid(element_pid_start_stop)\t16.Aclame_phage(element_pid_start_stop)\t17.Amphora(best_taxonomy(confidence))\t18.Rnammer(taxa_pid_start_stop)\t19.Anvio\t20.Maxbin(bin_taxa_completeness_contamination)\n'
for id in ids:
	linedict[id] = id  #1
	add_program(linedict, plasmid_finder_dict,id, "plasmid_") #2
	add_program(linedict, full_plasmids_dict,id, "plasmid_") #3
	add_program(linedict, relaxase_dict, id, "plasmid_") #4
	add_program(linedict, resfam_dict, id, "ARG_") #5
	add_program(linedict, perfect_dict, id, "ARG_") #6
	add_program(linedict, card_dict, id, "ARG_") #7
	add_program(linedict, isescan_dict, id, "IS_") #8
	add_program(linedict, pf_dict, id, "phage_") #9
	add_program(linedict, phaster_dict, id, "phage_")#10
	add_program(linedict, vogs_dict, id, "phagevog_") #11
	add_program(linedict, vf_dict, id, "vf_") #12
	add_program(linedict, trnascan_dict, id, "trna_") #13
	add_program(linedict, imme_dict, id, "imme_") #14
	add_program(linedict, aclame_plasmid_dict, id, "plasmid_") #15
	add_program(linedict, aclame_phage_dict, id, "phage_") #16
	add_program(linedict, amphora_dict, id, "amphora_") #17
	add_program(linedict, rnammer_dict, id, "rnammer_") #18
	add_program(linedict, anvio_dict, id, "anvio_") # 19
	add_program(linedict, mtphln_dict,id, "mtphln_") #20
	add_program(linedict, gsmer_many_dict,id, "gsmer_") #22
	add_program(linedict, maxbin_dict, id, "maxbin_") #23
#write linedict

for id in ids:
	newline = linedict[id]
	bestorg = best_org(newline)
	linedict[id] = linedict[id] + '\t' + bestorg


outfile = open('/workdir/users/agk85/CDC/combo_tables/metagenomes2/' + name + '_master_scf_table.txt','w')
outfile.write(header)
for id in ids:
	outfile.write(linedict[id] + '\n')


outfile.close()