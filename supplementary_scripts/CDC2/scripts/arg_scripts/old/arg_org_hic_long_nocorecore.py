#refined ARG vs. Organism traversal
# #use the best organism function from CDC one
#python arg_org_hic_refined.py -b /workdir/users/agk/gates -a 95 -p 0 -d 2
#goal of latest update
#instead of using just the best organism given by the combo_tables, instead use the best organism given by the clusters from a given cluster file
import numpy as np
import glob
import collections
from Bio import SeqIO
from igraph import *
import argparse
from argparse import RawDescriptionHelpFormatter
from best_org_folder import *

def getOptions():
 	"""Get arguments"""
 	description="""This script can be used to get arg versus organism capturing orgs on the 
 	contig and contigs up to N links away via Hi-C reads"""
 	parser = argparse.ArgumentParser(description=description, formatter_class=RawDescriptionHelpFormatter)
	parser.add_argument('-a','--argpid',dest='argpid',action='store',required=True,type=str, help='ARG clusterd at PID [Required]', metavar='ARGPID')
	parser.add_argument('-p','--hicpid',dest='hicpid',action='store',required=True,type=str, help='HIC mapped at PID [Required]', metavar='HICPID')
	parser.add_argument('-f', '--folder', dest='folder', action='store', required=True, type=str, help='Folder [Required]', metavar='FOLDER')
 	parser.add_argument('-d', '--depth', dest='depth', action='store', required=True, type=int, help='HiC depth [Required]', metavar='DEPTH') 
 	parser.add_argument('-c', '--combinations', dest='combofile', action='store', required=True, type=str, help='Combination file [Required]', metavar='COMBINATIONS')
	args = parser.parse_args()
 	return(args)

#for testing
depth = 1
folder = 'press'
argpid = '99'
hicpid = '0'
minreads=2
#cb1 = 'MluCI-1ProxiMeta-1'
#cb2 = 'Sau3aI-1ProxiMeta-1'


args = getOptions()
depth = args.depth
folder = args.folder
argpid = args.argpid
hicpid = args.hicpid
combohandle = args.combofile
minreads = 2

#tbldict
tbldict = {}
mgedict = {}
tblpaths = glob.glob('/workdir/users/agk85/' + folder + '/combo_tables/metagenomes/*_master_scf_table.txt')
for tblfile in tblpaths:
	with open(tblfile) as t:
		header = t.readline()
		for line in t:
			tbldict[line.split('\t')[0]] = line.strip()
			mgedict[line.split('\t')[0]] = line.strip().split('\t')[-2]


#import the hic to metagenome connections as tuples
#contig vs. organisms associated
best_org_dict = {}
#count   sample  contig  bin     bin_length      quality association_type        total_count     trans_count     norm_l  norm_rf contig_taxonomy kraken_taxonomy gtdb_taxonomy   arg_presence    arg_clusters    arg_genes       mge_presence    mge_clusters    mge_genes
good_quals = ['HQ','MQ','LQ']
with open(args.cvb) as hic:
	for line in hic:
		fields = line.strip().split('\t')
		trans_count = fields[8]
		quality = fields[5]
		arg_pres = fields[14]
		if quality in good_quals:
		if trans_count > args.min:
			sample = fields[1]
			contig = fields[2]
			binname = fields[3]
			kraken = fields[12]
#legacy keep this to maintain the proper spacing
top_args = []

#make a dictionary of graphs based on the hic library it uses
#get the library from the name somehow
#g = Graph.Read_Ncol('/workdir/users/agk85/' + folder + '/hic/mapping/trans_primary_ncol_' + hicpid + '_withexcise_noeuks.txt',weights=True, directed=True)
#g.to_undirected(mode="collapse",combine_edges="sum")
#g.es.select(weight_lt=minreads).delete()
	
#graphs
graphs = {}
for combo in combos:
	hic = combo[0]
	mgm = combo[1]
	g = Graph.Read_Ncol('/workdir/users/agk85/' + folder + '/hic/mapping/' + hic + '/' + hic + '_' + mgm+ '_trans_primary_' + hicpid + '_ncol_withexcise_noeuks.txt',weights=True, directed=True)
	g.to_undirected(mode="collapse",combine_edges="sum")
	g.es.select(weight_lt=minreads).delete()
	graphs[hic+mgm] = g 

samples = []
						if (nodemge == '.' and scfmge == '.'):
							a = 1
						else:
							for besttaxon in besttaxa:
								if besttaxon != '.':
									argdict[key][gene_samp].append(besttaxon)
									organisms.append(besttaxon)
									samporgs[gene_samp].append(besttaxon)
					except KeyError:
						besttaxa = ''
			except:
				a = 1

sampleorgs = {}
for samp in samporgs:
	sampleorgs[samp] = list(set(samporgs[samp]))


#do i still need this?
#get all of the organisms...make a set
orglist = list(set(organisms))
orglist.sort()



#keycode 
# argpres | orgpres | connection
# 000 = 0
# 001 = Not possible
# 010 = 1
# 011 = Not possible
# 100 = 2
# 101 = Not possible
# 110 = 3
# 111 = 4

#######################separate org and arg and connection
def get_code(argdict, key, org, samp):
	argpres = '0'
	connection = '0'
	orgpres = '0'
	color = '6'
	if org in argdict[key][samp]:
		connection = '1'
	if samp in argsampdict[key]:
		argpres = '1'
	if org in sampleorgs[samp]:
		orgpres = '1'
	if (argpres == '0') & (orgpres == '0') & (connection == '0'):
		color = '0'
	if (argpres == '0') & (orgpres == '1') & (connection == '0'):
		color = '1'
	if (argpres == '1') & (orgpres == '0') & (connection == '0'):
		color = '2'
	if (argpres == '1') & (orgpres == '1') & (connection == '0'):
		color = '3'
	if (argpres == '1') & (orgpres == '1') & (connection == '1'):
               color = '4'
	code = argpres + '\t' + orgpres + '\t' + connection + '\t' + color
	return code

header = 'Count\tCluster\tARG_name\tTop_ARG\tOrganism'
for samp in samples:
	header = header + '\t' + samp+'_arg\t' + samp + '_org\t' + samp + '_connect\t' + samp + 'color'

header = header +'\n'

count = 0
toparg = 'NA'
#figure out if you want to keep the lines that only have the organism...about 1 million lines
outhandle = '{0}/arg_v_org/metagenomes3/histograms/nocorecore/arg_org_hic_separated_{1}_{2}_{3}_{4}.tbl'.format('/workdir/users/agk85/CDC' , '95' , '98' ,str(args.depth), str(2))
with open(outhandle,'w') as outfile:
	outfile.write(header)
	for key in clusterprotdict.keys():
		argname = 'NA'	#arg_name_dict[clusternum_map[key]]
		for organism in orglist:
			count += 1
			tentativeline = '{0}\t{1}\t{2}\t{3}\t{4}'.format(str(count), key, argname,toparg, organism)
			for samp in samples:
				code = get_code(argdict, key, organism, samp)
				tentativeline = tentativeline +'\t' + code
			tentativeline = tentativeline + '\n'
			outfile.write(tentativeline)

