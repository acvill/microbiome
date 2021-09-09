#This file assesses the taxonomic conflict at each taxonomic level 
#Tasks
#bring in your tables
#get the best org
import sys
import glob
base = "/workdir/users/agk85/CDC"
outhandle = base + '/maxbin/metagenomes3/no_mges/maxbin_conflict.txt'
samples = glob.glob("/workdir/users/agk85/CDC/maxbin/metagenomes3/no_mges/B*-*")
samps = [sample.split('/')[8] for sample in samples]
#name = 'B314-1'
with open(outhandle,'w') as outfile:
	outfile.write('{0}\t{1}\t{2}\t{3}\t{4}\n'.format("taxa_level", "with_taxa", "without_taxa", "with_conflict", "without_conflict"))
	for samp in samps:
		name = samp
		base = '/workdir/users/agk85/CDC'
		bestorgdict = {}
		tblfile = base+ '/combo_tables/metagenomes3/' + name+ '_master_scf_table.txt'
		with open(tblfile) as t:
			header = t.readline()
			for line in t:
				bestorgdict[line.split('\t')[0]] = line.strip().split('\t')[-1]
	
		#merge this with maxbin ids
		binlist = []
		maxbindict = {}
		maxbinhandle = base + '/maxbin/metagenomes3/no_mges/' + name + '/' + name + '_networkcluster.txt'
		with open(maxbinhandle) as maxbinfile:
			for line in maxbinfile:
				scfid = line.split('\t')[0]
				bin = line.strip().split('\t')[1]
				binlist.append(bin)
				besttaxa = bestorgdict[scfid]
				if besttaxa == '.':
					continue
				else:
					try:
						maxbindict[bin].append(besttaxa)
					except KeyError:
						maxbindict[bin] = [besttaxa]
		bins = list(set(binlist))
		bins.sort()
		#then the goal is to figure out how much conflict there is at each taxonomic level
		#categories
		#bin has nothing
		#bin has one thing
		#bin has many things
			#many things agree
			#many things don't agree
		delims = ['s__','g__','f__','o__','c__','p__','k__']
		delim_names=['species','genus','family','order','class','phylum','kingdom']
		for i in range(len(delims)):
			delim = delims[i]
			bintaxa = {}
			for bin in bins:
				bintaxa[bin] = []
			#add in taxa-level info for each bin and don't add if nothing or not a real level
			for bin in bins:
				try:
					for taxonomy in maxbindict[bin]:
						lev = taxonomy.split(delim)[1].split(';')[0]
						if lev != '':
							bintaxa[bin].append(lev)
				except KeyError:
					print(bin, "no taxonomies")
			with_taxa = 0
			without_taxa = 0
			with_conflict = 0
			without_conflict = 0
			for bin in bins:
				taxa_added_count = len(bintaxa[bin])
				taxa_unique_count = len(set(bintaxa[bin]))
				if taxa_added_count == 0:
					without_taxa += 1
				if taxa_added_count == 1:
					with_taxa += 1
					print 'singleton'
				if taxa_added_count > 1 and taxa_unique_count == 1:
					with_taxa +=1
					without_conflict +=1
				if taxa_added_count >1 and taxa_unique_count >1:
					with_taxa +=1
					with_conflict +=1
			#so now you want to tell me for each level, what is the # bins 
			outfile.write('{0}\t{1}\t{2}\t{3}\t{4}\t{5}\n'.format(name, delim_names[i], with_taxa, without_taxa, with_conflict, without_conflict))

