
#goal is to grab all of the nucleotide sequences associated with ARGs
import glob
from Bio import SeqIO

argpaths = glob.glob('/workdir/users/agk85/CDC/resfams/metagenomes/*/*_resfams.txt')
seq_record = []
for path in argpaths:
	name = path.split('/')[7]
	infile = open(path,'r')
	try:
		handle = '/workdir/users/agk85/CDC/prodigal/metagenomes/' + name + '/scaffold.seq'
		fasta_dict = SeqIO.to_dict(SeqIO.parse(handle, "fasta"))
	except IOError:
		continue
	for line in infile:
		if line[0] !='#':
			fields = line.strip().split(',')
			scfid = fields[2]
			target = fields[0]
			seqrec= fasta_dict[scfid]
			seqrec.id = name+'_'+seqrec.id
			seq_record.append(seqrec)
		
	

SeqIO.write(seq_record,'arg.fna','fasta')


