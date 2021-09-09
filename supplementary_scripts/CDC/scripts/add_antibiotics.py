#script to add on the antibiotics to every call from CARD's software RGI
#USAGE: python 
import sys

id_dict = {}
drugtable = open('/workdir/users/agk85/CDC/card/aro_id_drugs.txt','r')
for line in drugtable:
	aroid = line.split('\t')[0]
	drugs = line.strip().split('\t')[1]
	id_dict[aroid] = drugs

infile = open(sys.argv[1],'r')
header = infile.readline()
#add a column to the header
newheader = header.strip() + 'drugs\n'
outfile = open(sys.argv[2],'w')
outfile.write(newheader)
for line in infile:
	#might need to test that this is the 8th column
	aroid = line.split('\t')[10]
	outfile.write('{0}\t{1}\n'.format(line.strip(),id_dict[aroid]))


outfile.close()
