#get counts of scfs that have args

import glob
paths = glob.glob('/workdir/users/agk85/CDC/resfams/metagenomes/*/*_modified.tbl.txt')

outfile = open('arg_scf_counts.txt','w')
header = 'name\tscfs\tscfs2+\tscfids\tscfids2+\n'
outfile.write(header)


for path in paths:
	name = path.split('/')[7]
	infile = open(path,'r')
	scfdict = {}
	added_args=[]
	for line in infile:
		if line[0] !='#':
			fields = line.strip().split(',')
			scfid = fields[2]
			scf = scfid.split('_')[1]
			protnum = scfid.split('_')[2]
			if scfid not in added_args=[]:
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
	scfids = '|'.join(scfdict.keys())
	outfile.write('{0}\t{1}\t{2}\t{3}\n'.format(name,scfnum,scf2plus,scfids,scfids2plus))
	

outfile.close()
