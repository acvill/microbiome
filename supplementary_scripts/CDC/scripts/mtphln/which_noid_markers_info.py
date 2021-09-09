
refdict = {}
with open('marker_info_taxid.txt') as reffile:
	for line in reffile:
		taxid = line.split('\t')[0]
		rest = '\t'.join(line.split('\t')[1:])
		refdict[rest] = '1'

with open('markers_info.txt') as infile:
	with open('markers_info_noid.txt','w') as outfile:
		for line in infile:
			try:
				refdict[line]
			except KeyError:
				outfile.write(line)
