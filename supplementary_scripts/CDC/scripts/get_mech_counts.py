#get counts of resfam types following table

import glob
paths = glob.glob('/workdir/users/agk85/CDC/resfams/metagenomes/*/*_resfams.txt')

outfile = open('mechanism_counts.txt','w')
resdict = {}
reffile = open('170325_resfams_metadata_updated_v1.2.1.txt','r')
header = reffile.readline()
for line in reffile:
	fields = line.split('\t')
	resfamid = fields[0]
	mechanism = fields[6]
	resdict[resfamid] = mechanism


mechdict = {}
mechclasses = list(set(resdict.values()))
for mechclass in mechclasses:
	mechdict[mechclass] = 0

mechclasses.sort()
header = ''
for mech in mechclasses:
	header = header + '\t' + mech

header = header + '\n'
outfile.write(header)
for path in paths:
	name = path.split('/')[7]
	infile = open(path,'r')
	for line in infile:
		if line[0] !='#':
			fields = line.strip().split(',')
			resid = fields[1]
			try:
				mech = resdict[resid]
			except KeyError:
				mech = 'Unknown' + resid
		
			try:
				mechdict[mech] = mechdict[mech] + 1
			except:
				mechdict[mech] = 1
	outfile.write(name)
	for mech in mechclasses:
		outfile.write('\t' + str(mechdict[mech]))
	outfile.write('\n')


outfile.close()
