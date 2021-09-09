#convert markers_info.txt to get taxid for each sequence

#gi|483970126|ref|NZ_KB891629.1|:c6456-5752      {'ext': set(['GCF_000226995', 'GCF_000355695', 'GCF_000373585']), 'score': 3.0, 'clade': 's__Streptomyces_sp_KhCrAH_244', 'len': 705, 'taxon': 'k__Bacteria|p__Actinobacteria|c__Actinobacteria|o__Actinomycetales|f__Streptomycetaceae|g__Streptomyces|s__Streptomyces_sp_KhCrAH_244'}



inhandle = 'markers_info.txt'
mtphln_accession_dict = {}
with open(inhandle) as infile:
	for line in infile:
		longid = line.split('\t')[0]
		if 'GeneID' not in longid:
			ncbiid = line.split('|')[3].split('.')[0]
			mtphln_accession_dict[ncbiid] = 1

accession2taxid = {}
ref1 = '/workdir/blastdb/newtaxdmp/nucl_est.gb.gss.wgs.dead.accession2taxid'
with open(ref1) as reffile1:
	for line in reffile1:
		accession = line.split('\t')[0]
		try:
			t = mtphln_accession_dict[accession]
			accession2taxid[accession] = line.split('\t')[2]
		except KeyError:
			continue


geneid_mapdict = {}
geneid_map = 'geneids_taxid_map.txt'
with open(geneid_map) as gm:
	for line in gm:
		geneid = line.split('\t')[0]
		taxid = line.split('\t')[1].strip()
		geneid_mapdict[geneid] = taxid

outhandle = 'marker_info_taxid1.txt'
with open(inhandle) as infile:
	with open(outhandle,'w') as outfile:
		for line in infile:
			longid = line.split('\t')[0]
			try:
				if 'GeneID' not in longid:
					ncbiid = line.split('|')[3].split('.')[0]
					taxid = accession2taxid[ncbiid]
					outfile.write(taxid + '\t' + line)
				else:
					taxid = geneid_mapdict[longid.split('GeneID:')[1]]
					outfile.write(taxid + '\t' + line)
			except KeyError:
				if 'GeneID' not in longid:
					print longid
