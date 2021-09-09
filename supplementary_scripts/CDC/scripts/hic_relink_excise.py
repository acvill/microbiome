import glob
import sys

tbldict = {}
tblpaths = glob.glob('/workdir/users/agk85/CDC/combo_tables/metagenomes4/*_master_scf_table.txt')
for tblfile in tblpaths:
	with open(tblfile) as t:
		header = t.readline()
		for line in t:
			tbldict[line.split('\t')[0]] = line.strip()

inhandle = sys.argv[1]
outhandle = sys.argv[2]
			
with open(inhandle) as infile:
	with open(outhandle, 'w') as outfile:
		for line in infile:
			outfile.write(line)
		for key in tbldict:
			if 'phage' in key:
				#get the original scaffold
				origscf = key.split('_')[0] + '_scaffold_' + key.split('_')[1].split('|')[0]
				#add two links to it (not totally sure if this supersedes things?)
				outfile.write('{0}\t{1}\t2\n'.format(key, origscf))
		
