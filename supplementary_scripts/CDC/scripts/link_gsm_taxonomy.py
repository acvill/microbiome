import sys


refhandle = '/workdir/refdbs/GSMer/gsm_species_taxonomy.txt'
gsm_dict = {}
with open(refhandle) as reffile:
	for line in reffile:
		subject = line.split('|')[0]
		taxonomy = line.strip().split('|')[1]
		gsm_dict[subject] = taxonomy


inhandle = sys.argv[1]
outhandle = sys.argv[2]
with open(inhandle) as infile:
	with open(outhandle, 'w') as outfile:
		for line in infile:
			subject = line.split('\t')[1].split('|')[0]
			taxonomy = gsm_dict[subject]
			outfile.write(line.strip() + '\t' + taxonomy.replace('[','').replace(']','') + '\n')
