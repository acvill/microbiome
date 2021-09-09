#get counts of phages on scaffolds

import glob
paths = glob.glob('/workdir/users/agk85/CDC/prodigal/metagenomes/*/PFPR_tab.txt')

outfile = open('phagefinder_scf_counts.txt','w')
header = 'name\tscfs\tscfs2+\tscfids\n'
outfile.write(header)

for path in paths:
	name = path.split('/')[7]
	infile = open(path,'r')
	scfdict = {}
	for line in infile:
		if line[0] !='#':
			fields = line.strip().split('\t')
			scfid = fields[0]
			scf = scfid.split('_')[1]
			try:
				scfdict[scf] = scfdict[scf] + 1
			except KeyError:
				scfdict[scf] = 0
	
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
