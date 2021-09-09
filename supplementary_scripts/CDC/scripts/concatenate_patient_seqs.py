#!/usr/bin/env python
#Python script to add all proteins from a single patient over time into one file for cd-hit to cluster
#usage python patient_concatenate_seqs.py
#make sure you clear all sequence files already there because we append
#add name to all sequences
import os
from Bio import SeqIO
import glob



paths = glob.glob('/home/agk85/agk/CDC/prodigal/metagenomes/*/scaffold.seq')
for path in paths:
	infile = open(path,'r')
	name = path.split('/')[7]
	patient = name.split('-')[0]
	outfile = open('/home/agk85/agk/CDC/prodigal/metagenomes/' + patient + '_combined_prots.fna','a+')
	for line in infile:
		if line[0] == '>':
			id = line.split('>')[1]
			outfile.write('>' + name + '_' + id)
		else: 
			outfile.write(line)
	
	outfile.close()
