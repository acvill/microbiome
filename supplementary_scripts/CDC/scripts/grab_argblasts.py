#filters all blast for scaffolds that map to scaffolds with args
#This will allow identification of scaffolds that don't have the arg too
#USAGE: python arg_context.py name
import sys
import glob

scflist = []
name = sys.argv[1]
patient = name.split('-')[0]

blast_reffile = open('/home/agk85/agk/CDC/blast_comparisons/metagenomes/' + patient+ '_scfs.out','r')
blast_ref = [line.strip() for line in blast_reffile]

resfam_ref = []
resfile = open('/workdir/users/agk85/CDC/resfams/metagenomes/patients/' + patient + '_args.fna','r')
for line in resfile:
	if line[0] == '>':
		resfam_ref.append(line.split('>')[1].split('|')[0])


clusters = []
outfile = open('/workdir/users/agk85/CDC/card/metagenomes/'+name+'/'+name+'_scfs_ofinterest.txt','w')
handle = '/workdir/users/agk85/CDC/card/metagenomes/'+name+'/'+name+'_drug_specific_card_hits.txt'
infile = open(handle,'r')
header = infile.readline()
added_scfsets = []
for line in infile:
	count = 0
	fields = line.split('\t')
	scfid = name + '_scaffold_' + fields[0].split('_')[1]
	argid = name +'_'+ fields[0]
	argstart = int(fields[2])
	argstop = int(fields[3])
	drug = fields[25].strip()
	aros = fields[10]
	#pass_bit = float(fields[17])
	#best_bit = float(fields[18])
	#if best_bit>=pass_bit:
	if argid in resfam_ref:
		scfs = []
		scfs.append(scfid + '.' + str(argstart) + '.' + str(argstop))
		for blastline in blast_ref:
			query = blastline.split('\t')[0]
			if scfid == query:
				qstart = int(blastline.split('\t')[6])
				qstop = int(blastline.split('\t')[7])
				if (argstart < qstop and argstop > qstart):
					eval = float(blastline.split('\t')[10])
					pid = float(blastline.split('\t')[2])
					if eval < 1e-10 and pid > 90:
						print count
						count = count + 1
						subject = blastline.split('\t')[1]
						if subject != query:
							sstart= blastline.split('\t')[8]
							sstop = blastline.split('\t')[9]
							scfs.append(subject+'.' + sstart + '.' + sstop)
		
		scfset = set(scfs)
		if scfset not in added_scfsets:
			outfile.write(argid+'|' + str(argstart) + '|' + str(argstop) + '\t' + aros +'\t' + drug + '\t' + scfid + '\t' )
			added_scfsets.append(scfset)
			outfile.write('|'.join(scfset) + '\n')



outfile.close()
