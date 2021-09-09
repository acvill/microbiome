#USAGE: python get_better_headers_anvio.py B309-5_scaffold-MAP.txt B309-5_sequences.fna B309-5_bscg.fna
import sys
#contigmaphandle = 'B309-5_scaffold-MAP.txt'
#inhandle = 'B309-5_sequences.fna'
#outhandle = 'B309-5_bscg.fna'

contigmaphandle = sys.argv[1]
inhandle = sys.argv[2]
outhandle = sys.argv[3]


contigmap = {}
with open(contigmaphandle) as reffile:
	for line in reffile:
		contigmap[line.split('\t')[0]] = line.strip().split('\t')[1]


#add on the real contigs
with open(inhandle) as infile:
	with open(outhandle,'w') as outfile:
		for line in infile:
			if line[0] == '>':
				genename=line.split('>')[1].split('___')[0]
				source=line.split('source:')[1].split('|')[0]
				anviocontig=line.split('contig:')[1].split('|')[0]
				contig = contigmap[anviocontig]
				start = line.split('start:')[1].split('|')[0]
				stop = line.split('stop:')[1].split('|')[0]
				outfile.write('>{0}|{1}|{2}|{3}_{4}\n'.format(contig, genename,source,start, stop))
			else:
				outfile.write(line)
			
