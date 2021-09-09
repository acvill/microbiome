#!/usr/bin/env python
#add info to the blastoutput
#USAGE: python blast_extra_info.py patient threshold
#python blast_extra_info.py B316 2000 
from Bio import SeqIO
import sys

patient = sys.argv[1]
thresh = int(sys.argv[2])
reference = '/workdir/users/agk85/CDC/blast_comparisons/mgm_db/' + patient + '_scaffolds.fasta'
scf_dict = SeqIO.to_dict(SeqIO.parse(reference, "fasta"))

infile = open('/workdir/users/agk85/CDC/blast_comparisons/metagenomes/' + patient + '_scfs.out','r')
outfile = open('/workdir/users/agk85/CDC/blast_comparisons/metagenomes/' + patient + '_scfs_info.out','w')

for line in infile:
	front_both = 0
	end_both = 0
	fields = line.split('\t')
	q = fields[0]
	s = fields[1]
	pid = fields[2]
	qstart = int(fields[6])
	qstop = int(fields[7])
	sstart = int(fields[8])
	sstop = int(fields[9])
	qlen = len(scf_dict[q])
	slen = len(scf_dict[s])
	#query is always oriented a to b
	qb_extra = qstart
	qe_extra = qlen - qstop
	#subject sometimes flips
	if sstart < sstop:
		sb_extra = sstart
		se_extra = slen - sstop
	if sstart > sstop:
		sb_extra = slen - sstart
		se_extra = sstop
	if (sb_extra >thresh) and (qb_extra > thresh):
		front_both = 1
	if (se_extra >thresh) and (qe_extra > thresh):
		end_both = 1
	outfile.write('{0}\t{1}\t{2}\t{3}\t{4}\t{5}\t{6}\t{7}\t{8}\n'.format(line.strip(), qlen, slen, qb_extra, qe_extra, sb_extra, se_extra,front_both, end_both))



outfile.close()

