import sys
inhandle = sys.argv[1]
outhandle = sys.argv[2]
with open(inhandle) as infile, open(outhandle,'w') as outfile:
	for line in infile:
		if line[0] == '>':
			scfnum=line.split('_')[1]
			header = '>scaffold_' + scfnum + '\n'
			outfile.write(header)
		else:
			outfile.write(line)
