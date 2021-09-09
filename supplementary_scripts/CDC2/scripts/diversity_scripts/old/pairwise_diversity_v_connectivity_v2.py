#

# goal: get some data for the number of links
# sample level number_of_connections number_of_taxa number_of_genes
# ok but now, you want to do so in a pairwise manner, so instead you gotta compare them 
import glob
import argparse
from argparse import RawDescriptionHelpFormatter
def getOptions():
	"""Get arguments"""
	description="""This script can be used to get arg versus organisms list given a genetype and minreads"""
	parser = argparse.ArgumentParser(description=description, formatter_class=RawDescriptionHelpFormatter)
	parser.add_argument('-gc','--genecluster',dest='genecluster',action='store',required=True,type=str, help='Genes clstr file [Required]', metavar='ARGPID')
	parser.add_argument('-c','--connections', dest="connections", action='store', required=True,  help='connection file [REQUIRED]', metavar="INFILE")
	parser.add_argument('-o',dest='outhandle',action='store',required=True,type=str, help='Outfile [Required]', metavar='OUTFILE')
	args = parser.parse_args()
	return(args)

args = getOptions()

samples = []
samplist = glob.glob('/workdir/users/agk85/CDC2/todo/*')
for samplong in samplist:
	samp = samplong.split('/')[-1]
	samples.append(samp)

levels = ['k__','p__','c__','o__','f__','g__','s__']

#initialize everything
connectdict = {}
taxadict = {}
genedict = {}
goodbins = {}
for sample in samples:
	connectdict[sample] = {}
	taxadict[sample] = {}
	genedict[sample] = []
	goodbins[sample] = []
	for level in levels:
		connectdict[sample][level] = []
		taxadict[sample][level] = []

#connectdict
# inhandle = '/workdir/users/agk85/CDC2/bins_hicsupport/connections_arg_org_all_2.txt'
inhandle = args.connections
with open(inhandle) as infile:
        header = infile.readline()
        for line in infile:
                patient,sample,genetype,minreads,geneid,taxonomy = line.strip().split('\t')
		for level in levels:
			taxalevel = taxonomy.split(level)[1].split(';')[0]
			taxafull = taxonomy.split(level)[0] + taxonomy.split(level)[1].split(';')[0]
			if taxalevel !='':
				connectdict[sample][level].append((geneid,taxafull))


#taxadict
#checkm quality
checkmfiles = glob.glob('/workdir/users/agk85/CDC2/das/*/checkm_lineage/*.stats')
for checkmfile in checkmfiles:
	sample = checkmfile.split('/')[-1].split('.stats')[0]
	with open(checkmfile) as checkm:
		for line in checkm:
			binid = line.split('\t')[0].split('.contigs')[0]
			completion = float(line.split('\t')[2])
			contamination = float(line.split('\t')[3])
			quality = 'BAD'
			if (completion > 90 and contamination < 5):
				quality = 'HQ'
			elif (completion >= 50 and contamination < 10):
				quality = 'MQ'
			elif (completion < 50 and contamination < 10):
				quality = 'LQ'
			if quality != 'BAD':
				goodbins[sample].append(binid)


krakenfiles = glob.glob('/workdir/users/agk85/CDC2/das/*/kraken/*_all_kraken_weighted.txt')
for krakenfile in krakenfiles:
	sample = krakenfile.split('/')[-1].split('_all_kraken_weighted.txt')[0]
	with open(krakenfile) as kfile:
		for line in kfile:
			binid = line.split('.contigs.fa.report.txt.besttaxid')[0]
			if binid in goodbins[sample]:
				print('yes')
				taxonomy = line.strip().split('\t')[7]
				for level in levels:
					taxalevel = taxonomy.split(level)[1].split(';')[0]
					taxafull = taxonomy.split(level)[0] + taxonomy.split(level)[1].split(';')[0]
					if taxalevel != '':
						taxadict[sample][level].append(taxafull)

#genedict
with open(args.genecluster) as genefile:
	for line in genefile:
		cluster = line.split('\t')[0]
		genelist = line.split('\t')[2].split(',')
		for gene in genelist:
			sample = gene.split('_')[0]
			try:
				genedict[sample].append(cluster)
			except KeyError:
				genedict[sample] = [cluster]


finished = []
outhandle = args.outhandle
with open(outhandle,'w') as outfile:
	header = 'Sample1\tSample2\tLevel\tConnections\tTaxa\tGenes\n'
	outfile.write(header)
	for sample1 in samples:
		for sample2 in samples:
			for level in levels:
				if (sample2,sample1,level) not in finished:
					finished.append((sample1,sample2,level))
					connect1 = set(connectdict[sample1][level])
					connect2 = set(connectdict[sample2][level])
					taxa1 = set(taxadict[sample1][level])
					taxa2 = set(taxadict[sample2][level])
					genes1 = set(genedict[sample1])
					genes2 = set(genedict[sample2])
					number_of_shared_connections = len(connect1.intersection(connect2))
					number_of_shared_taxa = len(taxa1.intersection(taxa2))
					number_of_shared_genes = len(genes1.intersection(genes2))
					outfile.write('{0}\t{1}\t{2}\t{3}\t{4}\t{5}\n'.format(sample1, sample2, level,str(number_of_shared_connections),str(number_of_shared_taxa),str(number_of_shared_genes)))


