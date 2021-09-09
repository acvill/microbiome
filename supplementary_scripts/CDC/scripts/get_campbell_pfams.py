import sys
#USAGE: python get_plasmid_pfams.py /workdir/users/agk85/CDC/annotation/metagenomes2/B309-1_pfam.txt /workdir/users/agk85/CDC/plasmids/metagenomes2/B309-1_plasmid_pfams.txt

#reference
refhandle = '/workdir/users/agk85/CDC/scripts/campbell_pfams.txt'
refdict = {}
with open(refhandle) as reffile:
	header = reffile.readline()
	for line in reffile:
		fields = line.strip().split('\t')
		pfam = fields[0].split('.')[0]
		refdict[pfam] = fields[1]

pfamhandle = sys.argv[1]
outhandle1 = sys.argv[2]

with open(pfamhandle) as pfamfile:
	with open(outhandle1,'w') as outfile1:
		for line in pfamfile:
			pfamid = line.split('\t')[3].split('.')[0]
			geneid = line.split('\t')[0]
			try:
				info = refdict[pfamid]
				outfile1.write('{0}\n'.format(geneid))
			except KeyError:
				continue
