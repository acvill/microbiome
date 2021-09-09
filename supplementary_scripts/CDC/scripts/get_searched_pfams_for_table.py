#ok this takes in pfamids and outputs type as a comma list
#pfamid\tdescription\ttype,type,type


bad_pfams = ['PF00179','PF16732','PF16509','PF09952','PF11459','PF11657','PF16873','PF10899','PF06541','PF00391','PF08843','PF01566','PF03205','PF06463','PF12804','PF15495','PF01187','PF06543','PF15969','PF06761','PF00505','PF09814','PF01109','PF06755','PF06154','PF14253','PF16754','PF13304']


pfamidfiles = ['/workdir/users/agk85/CDC/annotation/Other_pfamids.txt',
'/workdir/users/agk85/CDC/annotation/Plasmid_pfamids.txt',
'/workdir/users/agk85/CDC/annotation/Phage_pfamids.txt',
'/workdir/users/agk85/CDC/annotation/Transposon_pfamids.txt',
'/workdir/users/agk85/CDC/annotation/Defined_plasmid_pfamids.txt']

pfamidtype = {}
for pfamidfile in pfamidfiles:
	pfamids = [line.strip() for line in open(pfamidfile)]
	type = pfamidfile.split('/')[6].split('_')[0]
	if type == 'Defined':
		type = "Plasmid"
	for pfamid in pfamids:
		if pfamid not in bad_pfams:
			try:
				pfamidtype[pfamid].append(type)
			except KeyError:
				pfamidtype[pfamid] = [type]


pfamdesc = {}
with open('/workdir/refdbs/Pfams/PfamA.txt') as infile:
        for line in infile:
                pfamid = line.split('   ')[1].split('.')[0]
                desc = line.strip().split('\t')[2].split('  ')[1]
                pfamdesc[pfamid] = desc


outhandle = '/workdir/users/agk85/CDC/annotation/Pfams_searched.txt'
with open(outhandle, 'w') as outfile:
	outfile.write('Pfam_ID\tDescription\tTypes\n')
	for pfamid in pfamidtype.keys():
		types = ','.join(list(set(pfamidtype[pfamid])))
		description = pfamdesc[pfamid]
		outfile.write(pfamid + '\t' + description + '\t' + types + '\n')

