#USAGE: python get_plasmid_pfams.py /workdir/users/agk85/CDC/annotation/metagenomes2/B309-1_pfam.txt /workdir/users/agk85/CDC/plasmids/metagenomes2/B309-1_plasmid_pfams.txt

import glob
import sys
folder = sys.argv[1]
name=sys.argv[2]

#reference
refhandle = '/workdir/users/agk85/CDC/annotation/Alyssa_pfams.txt'
pfams = []
with open(refhandle) as reffile:
	for line in reffile:
		pfams.append(line.strip().split('.')[0])

description = {}
with open('/workdir/refdbs/Pfams/PfamA.txt') as infile:
	for line in infile:
		pfamid = line.split('   ')[1].split('.')[0]
		desc = line.strip().split('\t')[2].split('  ')[1]
		description[pfamid] = desc

bad_pfams = ['PF00179','PF16732','PF16509','PF09952','PF11459','PF11657','PF16873','PF10899','PF06541','PF00391','PF08843','PF01566','PF03205','PF06463','PF12804','PF15495','PF01187','PF06543','PF15969','PF06761','PF00505','PF09814','PF01109','PF06755','PF06154','PF14253','PF16754','PF13304']

with open('/workdir/users/agk85/' + folder + '/annotation/metagenomes/'+name+'_pfam.txt') as pfamfile:
	with open('/workdir/users/agk85/'+ folder + '/annotation/metagenomes/'+name+'_mobilegenes.txt','w') as outfile:
		for line in pfamfile:
			pfamid = line.split('\t')[3].split('.')[0]
			geneid = line.split('\t')[0]
			scfid = line.split('_')[0] +'_'+ line.split('_')[1] +'_'+line.split('_')[2]
			if ((pfamid in pfams) and (pfamid not in bad_pfams)):
				pfamdesc = description[pfamid]
				outfile.write(line.strip() + '\t' +pfamid+'\t' + pfamdesc + '\n')

