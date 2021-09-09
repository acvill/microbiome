
#make scaffold files with IDs in them
#cd to directory with folders from each metagenome/genome/phage group
#usage python concatenate_scaffolds.py phage_scaffolds.fna 
#attached directory name to beginning of each fasta_id i.e. >B320-1_scaffold_1

import os
import sys
outfile = open(sys.argv[1],'w')
for dir in os.listdir('.'):
	if os.path.isdir(dir):
		infile = open(dir + '/scaffold.pep','r')
		for line in infile:
			if line[0] == '>':
				outfile.write('>' + dir + '_' + line.split('>')[1])
			else:
				outfile.write(line)
	
		infile.close()
	

outfile.close()
	
