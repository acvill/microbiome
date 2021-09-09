#compare arg with phagefinder output, which scfs have both
#print out line for each arg that had a phage on the same scf, print out the phage protids on that scf
#might modify to also print out list of only arg that are IN phage/prophage

import glob
phagepaths = glob.glob('/workdir/users/agk85/CDC/prodigal/metagenomes/*/PFPR_tab.txt')

outfile = open('','w')
header = 'name\tscfs\tscfs2+\tscfids\n'
outfile.write(header)


phagedict = {}
for path in phagepaths:
	name = path.split('/')[7]
	phagedict[name]={}
	infile = open(path,'r')
	for line in infile:
		if line[0]!='#':
			fields = line.strip().split('\t')
			scf = fields[0].split('_')[1]
			protbegin = fields[13].split('_')[2]
			if fields[14] =='':
				protend = protbegin
			else:
				protend = fields[14].split('_')[2]
			try:
				phagedict[name][scf].append((protbegin,protend))
			except KeyError:
				phagedict[name][scf]=[(protbegin,protend)]	
		

argpaths = glob.glob('/workdir/users/agk85/CDC/resfams/metagenomes/*/*_resfams.txt')
outfile = open('arg_phage_comparison.txt','w')
for path in argpaths:
	name = path.split('/')[7]
	infile = open(path,'r')
	for line in infile:
		if line[0] !='#':
			fields = line.strip().split(',')
			scfid = fields[2]
			scf = scfid.split('_')[1]
			protnum = scfid.split('_')[2]
			target = fields[0]
			try:
				phageprots = phagedict[name][scf]
				outfile.write('{0}\t{1}\t{2}\t{3}\n'.format(name, scfid, target, phageprots))
			except KeyError: 
				continue

	
	
	
	scfnum = len(scfdict.keys())
	scf2plus = 0
	scfids2plus = []
	for scf in scfdict.keys():
		if scfdict[scf]>1:
			scf2plus = scf2plus + 1
			scfids2plus.append((scf, scfdict[scf]))
	#'|'.join(scfids2plus)
	outfile.write('{0}\t{1}\t{2}\t{3}\n'.format(name,scfnum,scf2plus,scfids2plus))
	

outfile.close()
