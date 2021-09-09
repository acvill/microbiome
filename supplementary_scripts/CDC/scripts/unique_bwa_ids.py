#remove reads that map multiply
import argparse
from argparse import RawDescriptionHelpFormatter

def getOptions():
	"""Get arguments"""
	description="""This script removes multiply mapped alignments from a bwa output sam file"""
	parser = argparse.ArgumentParser(description=description, formatter_class=RawDescriptionHelpFormatter)
	parser.add_argument('-c', '--idcount', dest='idcount', action='store', required=True, type=str, help='ID count file [Required] comes from counting readids:  grep -v "^@" file.sam | cut -f1 | sort | uniq -c > idcount.txt', metavar='IDCOUNT') 
	parser.add_argument('-o', '--outfile', dest='outfile', action='store', required=True, type=str, help='outfile [Required]', metavar='OUT') 
	parser.add_argument('-s', '--samfile', dest='samfile', action='store', required=True, type=str, help='SAM file [Required]', metavar='SAM') 
	args = parser.parse_args()
	return(args)

args = getOptions()

idfile = args.idcount
outhandle = args.outfile
samhandle = args.samfile

iddict = {}
with open(idfile) as reffile:
	for line in reffile:
		count = line.split()[0]
		readid = line.split()[1]
		iddict[readid] = count

with open(samhandle) as infile, open(outhandle, 'w') as outfile:
	for line in infile:
		if line[0] == '@':
			outfile.write(line)
		else:
			readid = line.split('\t')[0]
			count = iddict[readid]
			if count == '1':
				outfile.write(line)
