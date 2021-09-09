#filters all blast for scaffolds that map to scaffolds with args
#This will allow identification of scaffolds that have portions of the ARG
#TODO add a printout of % blast overlap
#USAGE: python grab_blasts_card_strict.py patient clusterfile
import sys
import glob
from Bio import SeqIO
seteval = 1e-10
setpid = 90
patient = sys.argv[1]
clusterfile = sys.argv[2]
#patient = 'B316'
#clusterfile = '/workdir/users/agk85/CDC/card/metagenomes/patients/B316_card_strict_args_nr.fna.clstr'
clusters = {}
filepath= open(clusterfile,'r')
for line in filepath:
	if line[0] == '>':
		clusternum = int(line.strip().split(' ')[1])
		clusters[clusternum] = []
	else:
		clusters[clusternum].append(line.split('>')[1].split('...')[0])


#better to make it a blastdict?
blast_dict = {}
blast_reffile = open('/home/agk85/agk/CDC/blast_comparisons/metagenomes/' + patient+ '_scfs_info.out','r')
for line in blast_reffile:
	query = line.split('\t')[0]
	try:
		blast_dict[query].append(line)
	except KeyError:
		blast_dict[query]= [line]

prot_reffile = '/workdir/users/agk85/CDC/prodigal/metagenomes/combined_prots/'+patient + '_combined_prots.fna' 
prot_dict = SeqIO.to_dict(SeqIO.parse(prot_reffile, "fasta"))

card_info = {}
card_file = open('/workdir/users/agk85/CDC/card/metagenomes/' + patient + '_card_strict.txt','r')
for line in card_file:
	#why is there a space, I have no idea--formatting bullshit
	protid = line.split(' \t')[0]
	hit = line.split('\t')[8]
	card_info[protid] = hit


blast_handle = '/home/agk85/agk/CDC/blast_comparisons/metagenome_db/' + patient+ '_combined_scfs_500.fna'
blast_seq_dict = SeqIO.to_dict(SeqIO.parse(blast_handle, "fasta"))


protinfo_dict={}
cluster_blasts = {}
for cluster, prots in clusters.iteritems():
	cluster_blasts[cluster] = []
	overlap = 0
	doubleoverlap = 0
	for protid in prots:
		rec = prot_dict[protid]
		protstart = int(rec.description.split(' # ')[1])
		protstop = int(rec.description.split(' # ')[2])
		protnum = protid.split('_')[3]
		prothit = card_info[protid]
		fields = protid.split('_')
		scfid = fields[0] + '_scaffold_' + fields[2]
		protinfo_dict[scfid] = (protnum, protstart, protstop, prothit)
		scfs = []
		scfs.append(scfid + '.' + str(protstart) + '.' + str(protstop))
		try:
			blastlines = blast_dict[scfid]
			print 'made it'
			for blastline in blastlines:
				query = blastline.split('\t')[0]
				qstart = int(blastline.split('\t')[6])
				qstop = int(blastline.split('\t')[7])
				if (protstart < qstop and protstop > qstart):
					eval = float(blastline.split('\t')[10])
					pid = float(blastline.split('\t')[2])
					front = int(blastline.strip().split('\t')[18])
					back = int(blastline.strip().split('\t')[19])
					if (front > 0 or back > 0):
						overlap = overlap + 1
					if (front > 0 and back > 0):
						doubleoverlap = doubleoverlap + 1
					if eval < seteval and pid > setpid:
						subject = blastline.split('\t')[1]
						#if subject != query: #don't need this because you don't put it in earlier
						sstart= blastline.split('\t')[8]
						sstop = blastline.split('\t')[9]
						cluster_blasts[cluster].append(subject)
		except KeyError:
			continue							
	
	if len(cluster_blasts[cluster]) != 0 and overlap>0:
		scfs = list(set(cluster_blasts[cluster]))
		scfs.sort()
		recs = []
		handle = '/workdir/users/agk85/CDC/card/metagenomes/patients/clusters/' + patient + '_cluster_' + str(cluster) + '.fna'
		for scf in scfs:
			try:
				prottuple = protinfo_dict[scf]
				rec = blast_seq_dict[scf]
				rec.id = rec.id + "|" + prottuple[0] + "|" + str(prottuple[1]) + '|' + str(prottuple[2]) + '|' + str(prottuple[3])
			except KeyError:
				rec = blast_seq_dict[scf]
			
			if len(rec)>2000:
				recs.append(rec)
		
		SeqIO.write(recs,handle,'fasta')
		print handle
