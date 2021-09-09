
#USAGE: python get_expanded_geneseqs.py /workdir/users/agk85/CDC/prodigal/metagenomes/${NAME}/scaffold.fna /workdir/users/agk85/CDC/prodigal/metagenomes/${NAME}/scaffold.seq /workdir/users/agk85/CDC/prodigal/metagenomes/${NAME}/scaffold_expand.seq
#USAGE: python get_expanded_geneseqs.py $REF $SEQ $OUTFILE
from Bio import SeqIO
import sys
# reffile = 'scaffold.fna' 
# infile = 'scaffold.seq'
# outfile = 'scaffold_expand.seq'

reffile = sys.argv[1]
infile = sys.argv[2]
outfile = sys.argv[3]
ref_dict = SeqIO.to_dict(SeqIO.parse(reffile, "fasta"))

mod = ''
expanded_recs = []
start_count = 0
stop_count = 0
start_500count = 0
stop_500count = 0
count500 = 0
for rec in SeqIO.parse(infile,'fasta'):
	id = rec.id
	description = rec.description
	refid = 'scaffold_' + id.split('_')[1]
	refseq = ref_dict[refid].seq
	start =  int(description.split(' # ')[1])-75
	stop = int(description.split(' # ')[2])+75
	if len(refseq) > 500:
		count500 = count500 + 1
	if start<0:
		mod = mod +';start_short_' + str(0-start)
		start = 0
		start_count = start_count + 1
		if len(refseq) <500:
			start_500count = start_500count + 1
	if stop > len(refseq):
		mod = mod + ';stop_long_' + str(stop - len(refseq))
		stop = len(refseq)
		stop_count = stop_count + 1
		if len(refseq) <500:
			stop_500count = stop_500count + 1
	expanded_seq = refseq[start:stop]
	expanded_id = id + '_expand'
	rec.id = expanded_id
	rec.seq = expanded_seq
	rec.description = rec.description + mod
	mod = ''
	if len(rec.seq)>0:
		expanded_recs.append(rec)



print('starts: {0}, starts<500: {1}, >500: {2}'.format(start_count, start_500count, count500))
print('stops: {0}, stops<500: {1}, >500: {2}'.format(stop_count, stop_500count, count500))
SeqIO.write(expanded_recs,outfile,'fasta')
