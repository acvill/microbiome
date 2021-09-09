
#create a file that goes from taxid to taxonomy representation used by me
taxid_dict = {}
inhandle = '/workdir/blastdb/newtaxdmp/rankedlineage.dmp'
outhandle = '/workdir/blastdb/newtaxdmp/taxid_to_taxonomy.txt'
with open(outhandle,'w') as outfile:
	with open(inhandle) as infile:
		for line in infile:
			taxid = line.split('\t')[0]
			fields = line.split("\t|\t")
			taxonomy = 'k__{0}; p__{1}; c__{2}; o__{3}; f__{4}; g__{5}; s__{6};'.format(fields[9].split('\t')[0], fields[7], fields[6], fields[5], fields[4], fields[3],fields[2].replace(' ', '_'))
			outfile.write(taxid + '\t' +  taxonomy + '\n')
