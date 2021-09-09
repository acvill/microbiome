import argparse
from argparse import RawDescriptionHelpFormatter
import glob
import os

description="""#script to relabel bin3c cluster fasta files"""
parser = argparse.ArgumentParser(description=description, formatter_class=RawDescriptionHelpFormatter)
parser.add_argument('-f','--folder', dest="folder", action='store', required=True,  help='folder with fasta files [REQUIRED]', metavar="INFILE")
parser.add_argument('-o','--outfolder', dest="outfolder", action='store', required=True,  help='outfolder for better files [REQUIRED]', metavar="OUTFILE")
parser.add_argument('-n','--name', dest="name", action='store', required=True,  help='sample name to append ot the beginning [REQUIRED]', metavar="NAME")
args = parser.parse_args()

if not os.path.exists(args.outfolder):
    os.makedirs(args.outfolder)

for fastafile in glob.glob(args.folder + '/*.fna'):
	fastaoutfile = args.outfolder + '/' + args.name + '_' + fastafile.split('/')[-1]
	with open(fastafile) as infile, open(fastaoutfile, 'w') as outfile:
		for line in infile:
			if line[0] == '>':
				#>CL001_0001 contig:sim-1_1036|phage|1|32619_24559 ori:UNKNOWN length:32619
				scfid = line.split()[1].split(':')[1]
				outfile.write('>' + scfid + '\n')
			else:
				outfile.write(line)
