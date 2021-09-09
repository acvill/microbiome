#cat *scf_table.txt| sort| uniq > all_master_table.txt
#infile = open('B314-1_master_scf_table.txt','r')
#header = infile.readline()
outhandle = 'table_levelonly.txt'
with open(outhandle,'w') as outfile:
	switches = ['111111', '111110','111100','111000','110000','100000']
	switch_names=['r+a+b+c+m+g','r+a+b+c+m','r+a+b+c','r+a+b','r+a','r']
	for j in range(len(switches)):
		switch = switches[j]
		print switch_names[j]
		delims = ['s__','g__','f__','o__','c__','p__','k__']
		delim_names=['species','genus','family','order','class','phylum','kingdom']	
		#delims = [';.' ]
		#r|am|an|m|g
		for i in range(len(delims)):
			delim = delims[i]
			print delim_names[i]
			noannot = 0
			oneannot = 0
			mannot = 0
			gannot = 0
			oannot = 0
			notdot = 0
			oneplusannot = 0
			maddedannot = 0
			multiple_taxonomies = 0
			conflicting_taxonomies = 0
			any_taxonomies = 0
			infile = open('all_master_table.txt','r')
			for inline in infile:
				if inline[0] !='S':
					besttaxa = '.'
					maxscore = 0
					r = 0
					a = 0
					b = 0
					c = 0
					m = 0
					g = 0
					nd = 0
					contig_taxonomies = []
					#delim = '; c__'
					if inline.split('\t')[28].strip() != '.':
						notdot +=1
					if 'rnammer_' in inline:
						r = 1
						rnammer = inline.split('rnammer_')[1].split('\t')[0]
						pid = float(rnammer.split('|')[0])
						org = rnammer.split('|')[1]
						if (switch[0] == '1' and 's__;' not in org):
							contig_taxonomies.append(org.split(delim)[1].split(';')[0])
					if 'amphora_' in inline:
						a = 1
						amphora_hits = inline.split('amphora_')[1].split('\t')[0].split(',')
						for taxon in amphora_hits:
							score = float(taxon.split('|')[0])
							org = taxon.split('|')[1]
							if (switch[1] == '1' and 's__;' not in org):
								contig_taxonomies.append(org.split(delim)[1].split(';')[0])
					if 'barrnap_' in inline:
						b = 1
						barrnap_hits = inline.split('barrnap_')[1].split('\t')[0].split(',')
						for taxon in barrnap_hits:
							pid = float(taxon.split('|')[0])
							org = taxon.split('|')[1]
							if (switch[2] == '1' and 's__;' not in org):
								contig_taxonomies.append(org.split(delim)[1].split(';')[0])
					if 'campbell_' in inline:
						c = 1
						campbell_hits = inline.split('campbell_')[1].split('\t')[0].split(',')
						for taxon in campbell_hits:
							pid = float(taxon.split('|')[0])
							org = taxon.split('|')[1]
							if (switch[3] == '1' and 's__;' not in org):
								contig_taxonomies.append(org.split(delim)[1].split(';')[0])
					if 'mtphln_' in inline:
						m = 1
						mtphln_hits = inline.split('mtphln_')[1].split('\t')[0].split(',')
						for taxon in mtphln_hits:
							pid = float(taxon.split('|')[0])
							org = taxon.split('|')[1]
							if (switch[4] == '1' and 's__;' not in org):
								contig_taxonomies.append(org.split(delim)[1].split(';')[0])
					if 'gsmer_' in inline:
						g = 1
						gsmer_hits = inline.split('gsmer_')[1].split('\t')[0].split(',')
						for taxon in gsmer_hits:
							pid = float(taxon.split('|')[0])
							org = taxon.split('|')[1]
							if (switch[5] == '1' and 's__;' not in org):
								contig_taxonomies.append(org.split(delim)[1].split(';')[0])
	
					s = r + a + b + c + m + g
					l = len(set(contig_taxonomies))
					tl = len(contig_taxonomies)
					if s == 0:
						noannot +=1
					if s > 0:
						oneplusannot +=1
					if s == 1:
						oneannot +=1
					if m == 1:
						mannot +=1
					if (r + a)>0:
						oannot +=1
					if tl>0:
						any_taxonomies +=1
					if tl>1:
						multiple_taxonomies +=1
					if l>1:
						conflicting_taxonomies +=1
						if delim == 'k__':
							print(contig_taxonomies)
					if m ==1 and (r+a) == 0:
						maddedannot +=1
					if g == 1:
						gannot +=1
			#print any_taxonomies
			try:
				outfile.write('{0}\t{1}\t{2}\t{3}\t{4}\t{5}\t{6}\t{7}\t{8}\t{9}\t{10}\t{11}\t{12}\t{13}\n'.format(switch_names[j], delim_names[i], noannot, oneplusannot, mannot, oannot, gannot, maddedannot, any_taxonomies, multiple_taxonomies, conflicting_taxonomies, str(round(100*float(conflicting_taxonomies)/any_taxonomies,2)),str(round(100*float(conflicting_taxonomies)/multiple_taxonomies,2)), notdot))
			except ZeroDivisionError:
				outfile.write('{0}\t{1}\t{2}\t{3}\t{4}\t{5}\t{6}\t{7}\t{8}\t{9}\t{10}\t{11}\t{12}\t{13}\n'.format(switch_names[j], delim_names[i], noannot, oneplusannot, mannot, oannot, gannot, maddedannot, any_taxonomies, multiple_taxonomies, conflicting_taxonomies,'divisionerror?' ,'divisionerror?', notdot))
