#converts fasta spades header to idba header

import sys
inhandle = sys.argv[1]
outhandle = sys.argv[2]

with open(inhandle) as infile:
	with open(outhandle, 'w') as outfile:
		for line in infile:
			if line[0] == '>':
				outfile.write('>scaffold_' +line.split('_')[1] + '\n')
			else:
				outfile.write(line)

