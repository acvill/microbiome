#trans contigs linking separate 
#using DAS clusters
#make a table that is clusters by clusters with 

import argparse
from argparse import RawDescriptionHelpFormatter

def getOptions():
	"""Get arguments"""
	description="""This script outputs a DAS cluster by cluster table for the Hi-C reads"""
	parser = argparse.ArgumentParser(description=description, formatter_class=RawDescriptionHelpFormatter)
	parser.add_argument('-i','--input',dest='inhandle',action='store',required=True,type=str, help='Cluster_combo_table', metavar='INFILE')
	parser.add_argument('-o','--output',dest='outhandle',action='store',required=True,type=str, help='Cluster_linkage_table_name', metavar='OUTFILE')
	parser.add_argument('-t','--transoutput',dest='transouthandle',action='store',required=True,type=str, help='Cluster_linkage_trans_table_name', metavar='TRANSOUTFILE')
	parser.add_argument('-l','--hic',dest='hic',action='store',required=True,type=str, help='Hi-C read mapping file', metavar='HICFILE')
	args = parser.parse_args()
	return(args)
	
args = getOptions()
inhandle = args.inhandle
outhandle = args.outhandle
transouthandle = args.transouthandle
hicfile = args.hic


#dictionary linking das genome clusters with contigs 
das_dict = {}
clusters = []
with open(inhandle) as infile:
	header = infile.readline()
	for line in infile:
		contig = line.split('\t')[0]
		das_cluster = line.split('\t')[40]
		das_dict[contig] = das_cluster
		#some will have '.'
		clusters.append(das_cluster)


#initialize cluster_counting dictionary
cluster_count_dict = {}	
trans_cluster_count_dict = {}
#initialize summing things
different_clusters = 0
same_clusters = 0
total = 0
trans_different_clusters = 0
trans_same_clusters = 0
trans_total = 0

cluster_keys = list(set(clusters))
cluster_keys.sort()

#set every combo to 0 
for key1 in cluster_keys:
	cluster_count_dict[key1] = {}
	trans_cluster_count_dict[key1] = {}
	for key2 in cluster_keys:
		cluster_count_dict[key1][key2]=0
		trans_cluster_count_dict[key1][key2]=0



#open up the hic file
with open(hicfile) as infile:
	for line in infile:
		total += 1
		#1 and 4
		contig1 = line.split('\t')[1]
		contig2 = line.split('\t')[4]
		#you have to put these in as exceptions because you've removed the eukaryotic reads
		try:
			cluster1 = das_dict[contig1]
			cluster2 = das_dict[contig2]
			if contig1 != contig2:
				trans_total +=1
				if (cluster1 != cluster2 and cluster1 !='.' and cluster2 != '.'):
					trans_different_clusters += 1
				if (cluster1 == cluster2 and cluster1 !='.'):
					trans_same_clusters +=1
				#add to the trans dictionary
				trans_cluster_count_dict[cluster1][cluster2] +=1
				trans_cluster_count_dict[cluster2][cluster1] +=1
			if (cluster1 != cluster2 and cluster1 !='.' and cluster2 != '.'):
				different_clusters += 1
			if (cluster1 == cluster2 and cluster1 !='.'):
				same_clusters +=1
			cluster_count_dict[cluster1][cluster2] +=1
			cluster_count_dict[cluster2][cluster1] +=1
		except KeyError:
			#one of the contigs is a eukaryotic one and not in the combo_table
			continue


#output the file
header = 'Cluster'
for key1 in cluster_keys:
	header = header + '\t' + key1
header = header + '\n'

with open(outhandle,'w') as outfile:
	outfile.write(header)
	for key1 in cluster_keys:
		outfile.write(key1)
		for key2 in cluster_keys:
			outfile.write('\t' + str(cluster_count_dict[key1][key2]))
		outfile.write('\n')

with open(transouthandle,'w') as outfile:
	outfile.write(header)
	for key1 in cluster_keys:
		outfile.write(key1)
		for key2 in cluster_keys:
			outfile.write('\t' + str(trans_cluster_count_dict[key1][key2]))
		outfile.write('\n')


print("same_clusters:", str(same_clusters))
print("different_clusters:", str(different_clusters))
print("total:", str(total))
print("trans_same_clusters:", str(trans_same_clusters))
print("trans_different_clusters:", str(trans_different_clusters))
print("trans_total:", str(trans_total))

print("prop_same:", str(float(same_clusters)/float(total)))
print("prop_diff:", str(float(different_clusters)/float(total)))
print("prop_nohit:", str((float(total)-float(same_clusters)-float(different_clusters))/float(total)))

print("prop_trans_same:", str(float(trans_same_clusters)/float(trans_total)))
print("prop_trans_diff:", str(float(trans_different_clusters)/float(trans_total)))
print("prop_trans_nohit:", str((float(trans_total)-float(trans_same_clusters)-float(trans_different_clusters))/float(trans_total)))

