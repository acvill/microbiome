
import sys
infile = open(sys.argv[1],'r')

indict = {}
for line in infile:
	indict[line.split('\t')[0]] = line

infile.close()
count = 0
infile2 = open(sys.argv[2],'r')
outfile = open(sys.argv[3],'w')
for line in infile2:
	id = line.split('\t')[0]
	try:
		R1 = indict[id].split('\t')
		R2 = line.split('\t')
		R1ofinterest = '\t'.join([R1[0], R1[1], R1[2],R1[3],R1[4],R1[5]])
		R2ofinterest = '\t'.join([R2[0], R2[1], R2[2],R2[3],R2[4],R2[5]])
		
		outfile.write(R1ofinterest + '\t' + R2ofinterest + '\n')
	except KeyError:
		count = count + 1
	

print "unmatched", count
infile2.close()
outfile.close()
