#best org function
import glob
def best_org_folder(tbldict, depth, folder, hicpid, minreads,hic,mgm):
	"""takes the combo table information, adds network memberships and then relinks excised phage with their parent all while excluding Virus taxa"""
	best_org_dict_base = {}
	for node in tbldict:
		m = node.split('_')[0]
		if m == mgm:
			inline = tbldict[node]
			#get the last column which should always be the bestorg
			best_org = inline.split('\t')[-1]
			if 'k__Virus' in best_org:
				best_org = '.'
			best_org_dict_base[node] = best_org
		#now replace things that have community memberships 
		#change this if you move down to genus level!!!!
	print("higher_depths")
	if str(depth) != '0':
		networkpaths = glob.glob('/workdir/users/agk85/' + folder + '/networks/memberships/' + hic + '_min' + str(minreads) + '_' + hicpid + '_addon_species_membership.txt')
		for networkpath in networkpaths:
			print networkpath
			with open(networkpath) as network:
				for line in network:
					node = line.split('"')[1]
					species = line.split('"')[3]
					cluster = line.split('"')[4].split('\n')[0]
					#make sure you don't overwrite the names of the good things but this assumes the community names are going to be better, if you change how you create the communities, you might need to reassess this
					if species != '.' and species != 'NA':
						if ('k__Virus' not in species):
							best_org_dict_base[node] = species
	
	print('phaged')
	best_org_dict_phaged = {}
	count = 0
	for node in tbldict:
		count +=1
		m = node.split('_')[0]
		if m == mgm:
			best_org_dict_phaged[node] = [best_org_dict_base[node]]
			if 'phage' in node:
				origscf = node.split('_')[0] + '_scaffold_' + node.split('_')[1].split('|')[0]
				try:
					line = tbldict[origscf]
					phageorg = best_org_dict_base[node]
					origorg = best_org_dict_base[origscf]
					if origorg != '.' and ('k__Virus' not in origorg):
						try:
							best_org_dict_phaged[node].append(origorg)
						except KeyError:
							best_org_dict_phaged[node] = [origorg]
					if phageorg != '.' and ('k__Virus' not in phageorg):
						try:
							best_org_dict_phaged[origscf].append(phageorg)
						except KeyError:
							best_org_dict_phaged[origscf] = [phageorg]
				except KeyError:
					continue
	best_org_dict = {}
	for key in best_org_dict_phaged.keys():
		best_org_dict[key] = list(set(best_org_dict_phaged[key]))
	
	return best_org_dict
