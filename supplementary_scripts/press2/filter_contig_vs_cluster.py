#filter_contig_vs_cluster.py
#This will filter the file based on presence of a contig in more than one cluster at a certain percent threshold
#you could do min reads and min percentage to deal with links that are low i.e. it has 5 reads and 2 reads go to cluster 1 and 3 go to cluster 2

#USAGE
#python filter_contig_vs_cluster.py -i ~/agk/press2/clusters/temp.txt -o ~/agk/press2/clusters/temp_filter.txt -c 5 -p 10
#contig_vs_cluster.py
import argparse
from argparse import RawDescriptionHelpFormatter

#def getOptions():
description="""This will filter the file based on presence of a contig in more than one cluster at a certain percent threshold"""

parser = argparse.ArgumentParser(description=description, formatter_class=RawDescriptionHelpFormatter)
parser.add_argument('-i','--in', dest="inhandle", action='store', required=True,  help='Infile [REQUIRED]', metavar="INFILE")
parser.add_argument('-o','--out', dest="outhandle", action='store', required=True, help='Outfile [REQUIRED', metavar="OUTFILE")
parser.add_argument('-c','--minc', dest="mincontacts", type=int, action='store', required=True,  help='Infile [REQUIRED]', metavar="INFILE")
parser.add_argument('-p','--minp', dest="minpercent", type=float, action='store', required=True, help='Outfile [REQUIRED', metavar="OUTFILE")

args = parser.parse_args()

with open(args.inhandle) as infile, open(args.outhandle,'w') as outfile:
	header = infile.readline()
	for line in infile:
		fields = line.strip().split('\t')
		contig = fields.pop(0)
		contigcount = 0
		for clustercount in fields:
			contigcount += int(clustercount)
		clusterflag = 0
		#so now that you have the count do it again and see if you pass the threshold
		for clustercount in fields:
			perc = 100*float(int(clustercount))/contigcount
			if (int(clustercount) > args.mincontacts and perc > args.minpercent):
				clusterflag += 1
		if clusterflag >1:
			outfile.write(line)