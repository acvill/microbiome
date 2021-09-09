#contig_vs_cluster.py
#USAGE:
#python contig_vs_cluster.py -c ~/agk/press2/das/ProxiMeta-1/ProxiMeta-1_DASTool_scaffolds2bin.txt -o ~/agk/press2/clusters/ProxiMeta-1_MluCI-1_das_5_contigs_v_clusters.txt -l ~/agk/press2/hicpro/single/MluCI-1_output/hic_results/data/MluCI-1/MluCI-1_allValidPairs -t ~/agk/press2/combo_tables/metagenomes/ProxiMeta-1_master_scf_table.txt -m 5
import argparse
from argparse import RawDescriptionHelpFormatter

#def getOptions():
description="""#this program should recompute % based on assigned kmers (uniqKmer * dup) of the total classified reads---not unclassified because that keeps them all!"""

parser = argparse.ArgumentParser(description=description, formatter_class=RawDescriptionHelpFormatter)
parser.add_argument('-c','--clusters', dest="clusterhandle", action='store', required=True,  help='Cluster-contig file [REQUIRED]', metavar="INFILE")
parser.add_argument('-o','--out', dest="outhandle", action='store', required=True, help='Outfile [REQUIRED', metavar="OUTFILE")
parser.add_argument('-l','--hic', dest="hichandle", action='store', required=True, help='HI-C file [REQUIRED', metavar="HIC_FILE")
parser.add_argument('-t','--table', dest="combotable", action='store', required=True, help='ComboTable file [REQUIRED', metavar="COMBO_FILE")
parser.add_argument('-m','--min', dest="minhic", action='store', type=int, required=True, help='ComboTable file [REQUIRED', metavar="COMBO_FILE")

args = parser.parse_args()

#contig and cluster lists
contigs = []
clusters = []

#get all the contigs
with open(args.combotable) as infile:
	header = infile.readline()
	for line in infile:
		contig = line.split('\t')[0]
		contigs.append(contig)

contiglist = list(set(contigs))

#create a dictionary of the contigs and clusters
clusterdict = {} #put in cluster and get contigs
contigdict = {} #put in contig and get cluster (meaning that some will not have a cluster)
with open(args.clusterhandle) as clusterfile:
	for line in clusterfile:
		cluster = line.strip().split('\t')[1]
		clusters.append(cluster) #this should get all of them
		contig = line.split('\t')[0]
		try:
			clusterdict[cluster].append(contig)		
		except KeyError:
			clusterdict[cluster] = [contig]
		contigdict[contig] = cluster


clusterlist = list(set(clusters))

#get hic trans contig information
#use the allValidReads file
#SRR6131122.10558730     ProxiMeta-1_1|phage|210862|217963_98338 110     -       ProxiMeta-1_scaffold_1  210442  +       382     HIC_ProxiMeta-1_1|phage|210862|217963_98338_5   HIC_ProxiMeta-1_scaffold_1_1823 42      42
hicdict = {}
with open(args.hichandle) as hicfile:
	for line in hicfile:
		#Get the contigs linking
		contig1 = line.split('\t')[1]
		contig2 = line.split('\t')[4]
		#make sure that it is a trans read!
		if contig1 != contig2:
			try:
				hicdict[contig1+contig2] += 1
				hicdict[contig2+contig1] += 1
			except KeyError:
				hicdict[contig1+contig2] = 1
				hicdict[contig2+contig1] = 1


header = 'Contig'
for cluster in clusterlist:
	header = header + '\t' + cluster

#create contig vs. cluster table with hic data
with open(args.outhandle, 'w') as outfile:
	outfile.write(header+'\n')
	for contig1 in contiglist:
		newline = contig1
		contigcount = 0
		for cluster in clusterlist:
			count = 0
			for contig2 in clusterdict[cluster]:
				if contig1 != contig2:
					try:
						count += hicdict[contig1+contig2]
					except KeyError:
						a = 1
			contigcount += count
			newline = newline + '\t' + str(count)
			if contig1 =="ProxiMeta-1_scaffold_49536":
				print(cluster)
				print(count)
		#this is so you can threshold the number of contacts to the cluster instead of between two contigs
		if contigcount >= args.minhic:
			outfile.write(newline + '\n')






