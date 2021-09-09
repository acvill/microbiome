import numpy as np
import glob
import collections
from Bio import SeqIO
import argparse
from argparse import RawDescriptionHelpFormatter

def getOptions():
 	"""Get arguments"""
 	description="""This script can be used to get arg versus organism capturing orgs on the 
 	contig and contigs up to N links away via Hi-C reads"""
 	parser = argparse.ArgumentParser(description=description, formatter_class=RawDescriptionHelpFormatter)
	parser.add_argument('-gc','--genecluster',dest='genecluster',action='store',required=True,type=str, help='Genes clstr file [Required]', metavar='ARGPID')
	parser.add_argument('-g','--genetype',dest='genetype',action='store',required=True,type=str, help='Gene [Required]', metavar='GENE')
	parser.add_argument('-m', '--minreads', dest='minreads', action='store', required=True, type=int, help='Min reads [Required]')
	parser.add_argument('-c','--connections', dest="connections", action='store', required=True, help='Contig vs bin file [REQUIRED]', metavar="CONNECTIONS")
	parser.add_argument('-i','--in', dest="cvb", action='store', required=True, help='Contig vs bin file [REQUIRED]', metavar="OUTFILE")
	parser.add_argument('-b','--bins', dest="binhandle", action='store', required=True,  help='bin-contig file [REQUIRED]', metavar="INFILE")
	args = parser.parse_args()
 	return(args)

args = getOptions()
####################################
#ok simpler you just want to know for each patient, out of all times when there is a connection, how consistent is it across the timepoints

####BIN STUFF######


samplelist = []
orgdict = {}
taxons = []
with open(args.binhandle) as binfile:
	for line in binfile:
		binid,patient,sample,quality,taxonomy = line.strip().split('\t')
		samplelist.append(sample)
		try:
			a = orgdict[sample]
		except KeyError:
			orgdict[sample] = {}
		if taxonomy != '.':
			orgdict[sample][taxonomy] = 1
			taxons.append(taxonomy)


samples = list(set(samplelist))
samples.sort()


print('Initialize the genefulldict')
genedict = {}
for sample in samples:
 	genedict[sample] = {}

with open(args.genecluster) as genefile:
	for line in genefile:
		cluster = line.split('\t')[0]
		genelist = line.split('\t')[2].split(',')
		for gene in genelist:
			sample = gene.split('_')[0]
			try:
				genedict[sample][cluster] = 1
			except KeyError:
				genedict[sample] = {}
				genedict[sample][cluster] = 1	



print('Initialize connectiondict')
connection_dict = {}
for sample in samples:
	connection_dict[sample] = []

#B314    B314-1  arg     2       5329    k__Bacteria; p__Proteobacteria; c__Gammaproteobacteria; o__Enterobacterales; f__Enterobacteriaceae; g__Escherichia; s__Escherichia_coli;
with open(args.connections) as infile:
	header = infile.readline()
	for line in infile:
		patient,sample,genetype,minreads,geneid,taxonomy = line.strip().split('\t')
		#only if it has a species
		if taxonomy.split('s__')[1].split(';')[0] != '':
			connection_dict[sample].append((geneid,taxonomy))



timepoint_dict = {"B314-1":"1","B314-2":"2","B314-3":"3","B314-4":"4","B316-1":"1","B316-2":"2","B316-3":"3","B316-4":"4","B316-5":"5","B316-6":"6","B316-7":"7","B320-1":"1","B320-2":"2","B320-3":"3","B320-5":"4","B331-1":"1","B331-2":"2","B331-3":"3","B331-4":"4","B335-1":"1","B335-2":"2","B335-3":"3","B357-1":"1","B357-2":"2","B357-3":"3","B357-4":"4","B357-5":"5","B357-6":"6","B370-1":"1","B370-2":"2","B370-3":"3","B370-4":"4","B370-5":"5","US3-8":"1","US3-10":"2","US3-12":"3","US3-14":"4","US3-16":"5","US8-1":"1","US8-2":"2","US8-3":"3","US8-4":"4","US8-5":"5"}

def share_gene(t1,t2,connection):
	geneid = connection[0]
	if (geneid in genedict[t1] and geneid in genedict[t2]):
		sharedgene=1
	else:
		sharedgene=0
	return sharedgene

def share_taxa(t1,t2,connection):
        taxa = connection[1]
        if (taxa in orgdict[t1] and taxa in orgdict[t2]):
                sharedtaxa=1
        else:
                sharedtaxa=0
        return sharedtaxa


def get_connection_stats(t1,t2,connect1, connect2):
	shared = len(connect1 & connect2)
	uniq1 = connect1 - connect2 #those unique to t1
	uniq2 = connect2 - connect1 #those unique to t2
	unconnected1 = 0
	unconnected2 = 0
	uniqelement1 = 0
	uniqelement2 = 0
	gainlist = []
	lostlist = []
	gainsources = []
	#go thru elements unique to t1 (why unique?)
	for connection in uniq1:
		if share_gene(t1,t2,connection) and share_taxa(t1,t2,connection):
			unconnected1 += 1
			lostlist.append(connection)
		else:
			uniqelement1 += 1
	#same for t2
	for connection in uniq2:
		if share_gene(t1,t2,connection) and share_taxa(t1,t2,connection):
			unconnected2 += 1
			gainlist.append(connection)
			#check to see if the gene had any connection in the orig timepoint
			for con in connection_dict[t1]:
				if con[0] == connection[0]:
					gainsources.append((con+(connection[1],'dummy')))
		else:
			uniqelement2 += 1		
	tup =(shared,uniqelement1,uniqelement2,unconnected1,unconnected2,gainlist,lostlist,gainsources)
	return tup

level = 'species'
print('Running through all the combinations')
outhandle = '/workdir/users/agk85/CDC2/bins/timelapse/timelapse_{0}_org_{1}_{2}.txt'.format(args.genetype, level, str(args.minreads))
outhandle2 = '/workdir/users/agk85/CDC2/bins/timelapse/timelapse_{0}_org_{1}_{2}_taxa_species_gained.txt'.format(args.genetype, level, str(args.minreads))
outhandle3 = '/workdir/users/agk85/CDC2/bins/timelapse/timelapse_{0}_org_{1}_{2}_taxa_species_lost.txt'.format(args.genetype, level, str(args.minreads))
outhandle4 = '/workdir/users/agk85/CDC2/bins/timelapse/timelapse_{0}_org_{1}_{2}_taxa_species_gained_source.txt'.format(args.genetype, level, str(args.minreads))
with open(outhandle, 'w') as outfile, \
open(outhandle2,'w') as outfile2, \
open(outhandle3,'w') as outfile3, \
open(outhandle4,'w') as outfile4:
	header = 'T1\tT2\tLevel\tTimepoint_of_comparison\tTotal_T1\tTotal_T2\tShared\tUniqelement1\tUniqelement2\tUnconnected1\tUnconnected2\n'
	header2 = 'T1\tT2\tLevel\tGene\tTaxa\n'
	header3 = 'T1\tT2\tLevel\tGene\tSourceTaxa\tNewTaxa\n'
	outfile.write(header)
	outfile2.write(header2)
	outfile3.write(header2)
	outfile4.write(header3)
	for t1 in samples:
		patient1 = t1.split('-')[0]
		for t2 in samples:
			patient2 = t2.split('-')[0]
			if patient1 == patient2:
				connect1 = set(connection_dict[t1])
				connect2 = set(connection_dict[t2])
				tott1 = len(connect1)
				tott2 = len(connect2)
				shared,uniqelement1, uniqelement2,unconnected1,unconnected2,gainlist,lostlist,gainsources=get_connection_stats(t1,t2,connect1, connect2)
				outfile.write('{0}\t{1}\t{2}\t{3}\t{4}\t{5}\t{6}\t{7}\t{8}\t{9}\t{10}\n'.format(patient1,t2,'all',timepoint_dict[t1],tott1,tott2,shared,uniqelement1, uniqelement2,unconnected1,unconnected2))
				if timepoint_dict[t1] == '1':
					for connection in gainlist:
						gene = connection[0]
						taxa = connection[1]
						outfile2.write('{0}\t{1}\t{2}\t{3}\t{4}\n'.format(t1,t2,level,gene,taxa))
					for connection in lostlist:
						gene = connection[0]
						taxa = connection[1]
						outfile3.write('{0}\t{1}\t{2}\t{3}\t{4}\n'.format(t1,t2,level,gene,taxa))
					for connection_source in gainsources:
						try:
							gene = connection_source[0]
							sourcetaxa = connection_source[1]
							newtaxa = connection_source[2]
							outfile4.write('{0}\t{1}\t{2}\t{3}\t{4}\t{5}\n'.format(t1,t2,level,gene,sourcetaxa,newtaxa))
						except IndexError:
							a = 1
