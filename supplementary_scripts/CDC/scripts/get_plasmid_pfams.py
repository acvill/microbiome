import sys
#USAGE: python get_plasmid_pfams.py /workdir/users/agk85/CDC/annotation/metagenomes2/B309-1_pfam.txt /workdir/users/agk85/CDC/plasmids/metagenomes2/B309-1_plasmid_pfams.txt

#reference
refhandle = '/workdir/users/agk85/CDC/scripts/plasmid_pfams.txt'
refdict = {}
with open(refhandle) as reffile:
	for line in reffile:
		fields = line.strip().split('\t')
		pfam = fields[1]
		refdict[pfam] = (fields[0], fields[2], fields[3],fields[4])

pfamhandle = sys.argv[1]
outhandle1 = sys.argv[2]
outhandle2 = sys.argv[3]

with open(pfamhandle) as pfamfile:
	with open(outhandle1,'w') as outfile1:
		with open(outhandle2, 'w') as outfile2:
			for line in pfamfile:
				pfamid = line.split('\t')[3].split('.')[0]
				geneid = line.split('\t')[0]
				try:
					info = refdict[pfamid]
					if info[1] == '1':
						outfile1.write('{0}\t{1}\t{2}\t{3}\t{4}\n'.format(geneid, info[0], info[1],info[2], info[3]))
					if info[1] == '0':
						outfile2.write('{0}\t{1}\t{2}\t{3}\t{4}\n'.format(geneid, info[0], info[1],info[2], info[3]))				
				except KeyError:
					continue
