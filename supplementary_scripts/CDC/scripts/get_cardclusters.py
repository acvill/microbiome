from Bio import SeqIO
import glob
import sys

cluster_reps = []
filepaths = glob.glob('/workdir/users/agk85/CDC/card/metagenomes/patients/*_args_nr.fna')
for filepath in filepaths:
	if 'strict' not in filepath:
		infile = open(filepath,'r')
		for line in infile:
			if line[0] == '>':
				cluster_reps.append(line.split('>')[1].split(' ')[0])

patient = sys.argv[1]
reference = '/workdir/users/agk85/CDC/blast_comparisons/metagenome_db/' + patient + '_combined_scfs_500.fna'
scf_dict = SeqIO.to_dict(SeqIO.parse(reference, "fasta"))

filepaths = glob.glob('/workdir/users/agk85/CDC/card/metagenomes/'+patient+'*/*_scfs_ofinterest.txt')
count = 0
for handle in filepaths:
	infile = open(handle,'r')
	for line in infile:
		rep = line.split('\t')[0].split(' |')[0]
		if rep in cluster_reps:
			drug = line.split('\t')[2]
			count = count + 1
			try:
				scfids = line.strip().split('\t')[4].split('|')
				scfids.sort()
				recs = []
				for scfinfo in scfids:
					scfid = scfinfo.split('.')[0]
					rec = scf_dict[scfid]
					rec.id = scfinfo
					if len(rec)>2000:
						recs.append(rec)
				
				writehandle = '/workdir/users/agk85/CDC/card/metagenomes/patients/clusters/' + patient + '_cluster_'  + str(count) + '_' + drug + '.fna'
				if len(recs)>1:
					SeqIO.write(recs,writehandle,'fasta')
					print recs
			except IndexError:
				continue
