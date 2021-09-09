#excise_phage_is.py
#USAGE = python excise_phage_is.py inhandle outhandle phagehandle ishandle name phageout iseout
import sys
from Bio import SeqIO
inhandle = sys.argv[1]
outhandle = sys.argv[2]
phagehandle = sys.argv[3]
ishandle = sys.argv[4]
name=sys.argv[5]
outphagefinder=sys.argv[6]
outisescan = sys.argv[7]
################################################

#for testing purposes
#from Bio import SeqIO
# name='B316-3'
# inhandle ='/workdir/users/agk85/CDC/prodigal/metagenomes2/' + name + '/' + name + '_scaffold.fasta'
# outhandle = '/workdir/users/agk85/CDC/prodigal_excise/metagenomes2/' + name + '/' + name + '_excise.fasta' 
# phagehandle = '/workdir/users/agk85/CDC/prodigal/metagenomes2/' + name + '/PFPR_tab.txt'
# ishandle='/workdir/users/agk85/CDC/iselements/metagenomes/prediction/' + name + '_scaffold.fasta.is.fna'
# #>B316-1_scaffold_0_121704_123088_- IS256_47
# outphagefinder='/workdir/users/agk85/CDC/prodigal_excise/metagenomes2/' + name + '/' + name + '_phagefinder.txt'
# outisescan = '/workdir/users/agk85/CDC/iselements/metagenomes/prediction/' + name + '_isescan.txt'
#################################################


excisedict= {}
with open(phagehandle) as phagefile:
		header = phagefile.readline()
		for line in phagefile:
				contig = line.split('\t')[0]
				start= int(line.split('\t')[3])
				stop= int(line.split('\t')[4])
				total = int(line.split('\t')[1])
				if ((total - stop) <= 1000):
						stop = total
						if start <=1000:
								start = 1
						try:
								excisedict[contig].append(str(start) + '_' + str(stop) + '_phage')
						except:
								excisedict[contig]= [str(start) + '_' + str(stop) + '_phage']
				elif (start <= 1000):
						start = 1
						if ((total - stop) <= 1000):
								stop = total
						try:
								excisedict[contig].append(str(start) + '_' + str(stop) + '_phage')
						except:
								excisedict[contig]= [str(start) + '_' + str(stop) + '_phage']
				elif ((total - stop > 1000) and (start > 1000)):
						try:
								excisedict[contig].append(str(start) + '_' + str(stop) + '_phage')
						except:
								excisedict[contig]= [str(start) + '_' + str(stop) + '_phage']


lastscfid = 0
lengths = {}
for rec in SeqIO.parse(inhandle,'fasta'):
		lengths[rec.id] = len(str(rec.seq))
		num = int(rec.id.split('_')[2])
		if num > lastscfid:
				lastscfid = num


with open(ishandle) as isfile:
		for line in isfile:
				if line[0] == '>':
						contig = line.split('_')[0].split('>')[1] +'_scaffold_' + line.split('_')[2]
						start = int(line.split('_')[3])
						stop = int(line.split('_')[4])
						total = lengths[contig]
						if (total-stop <=1000):
								stop = total
								if start <=1000:
										start = 1
								try:
										excisedict[contig].append(str(start) + '_' + str(stop) + '_is')
								except:
										excisedict[contig]= [str(start) + '_' + str(stop) + '_is']
						elif (start <=1000):
								start = 1
								if total-stop <=1000:
										stop = total
								try:
										excisedict[contig].append(str(start) + '_' + str(stop) + '_is')
								except:
										excisedict[contig]= [str(start) + '_' + str(stop) + '_is']
						elif ((total - stop > 1000) and (start > 1000)):
								try:
										excisedict[contig].append(str(start) + '_' + str(stop) + '_is')
								except:
										excisedict[contig]= [str(start) + '_' + str(stop) + '_is']


refs = SeqIO.to_dict(SeqIO.parse(inhandle, "fasta"))


#merge intervals
def merge_intervals(intervals):
		sorted_by_lower_bound = sorted(intervals, key=lambda tup: tup[0])
		merged = []
		
		for higher in sorted_by_lower_bound:
				if not merged:
						merged.append(higher)
				else:
						lower = merged[-1]
						# test for intersection between lower and higher:
						# we know via sorting that lower[0] <= higher[0]
						if higher[0] <= lower[1]:
								upper_bound = max(lower[1], higher[1])
								combotype= lower[2] + '.' + higher[2]
								merged[-1] = (lower[0], upper_bound, combotype)  # replace by merged interval
						else:
								merged.append(higher)
		return merged


excisedict2 = {}
#see if things overlap, if they do merge them
for key in excisedict:
		elements = excisedict[key]
		intervalList = []
		for element in elements:
				start = int(element.split('_')[0])
				stop = int(element.split('_')[1])
				type = element.split('_')[2]
				element_region = (start, stop, type)
				intervalList.append(element_region)
		
		merged = merge_intervals(intervalList)
		for region in merged:
				try:
						excisedict2[key].append('{}_{}_{}'.format(region[0], region[1], region[2]))
				except KeyError:
						excisedict2[key] = ['{}_{}_{}'.format(region[0], region[1], region[2])]


#handle one element and many elements
with open(outhandle,'w') as outfile:
		for rec in SeqIO.parse(inhandle,'fasta'):
				rec_contig = rec.id
				rec_contig_num = rec_contig.split('_')[2]
				try:
						excisions = excisedict2[rec_contig]
						last_pos = 0
						for element in excisions:
								start = int(element.split('_')[0])
								stop = int(element.split('_')[1])
								type = element.split('_')[2]
								newseq = str(rec.seq)[start-1:stop]
								fill = 'N' * len(newseq)
								oldseq = str(rec.seq)[:start-1] + fill + str(rec.seq)[stop:]
								rec.seq = oldseq
								lastscfid = lastscfid+ 1
								newid = name + '_' + rec_contig_num + '|' + type+ '|' + str(start) + '|' + str(stop) + '_' + str(lastscfid)
								outfile.write('>{0}\n{1}\n'.format(newid, newseq))
						
						if (('A' or 'T' or 'C' or 'G') in rec.seq):
								outfile.write('>{0}\n{1}\n'.format(rec_contig, rec.seq))
				except KeyError:
						outfile.write('>{0}\n{1}\n'.format(rec_contig, rec.seq))


#make the isescan and phage finder output files simply: new contig name \t start position \t stop position \t what is it??
# >B316-2_0|phage|90245|107315_120498
completed = []
with open(outphagefinder, 'w') as outphage:
	with open(outisescan, 'w') as outis:
		for rec in SeqIO.parse(outhandle,'fasta'):
			header = rec.id
			if ('phage' in header or 'is' in header):
				cleanheader = header.split('_')[0] + '_scaffold_' + header.split('_')[1].split('|')[0]
				excisestart = int(header.split('_')[1].split('|')[2])
				excisestop = int(header.split('_')[1].split('|')[3])
				items = excisedict[cleanheader]
				for item in items:
					#is it inside the excised contig?
					start = int(item.split('_')[0]) # modify to make relative to current 
					stop = int(item.split('_')[1])
					if (start <= excisestop & stop >=excisestart):
						newstart = str(start - excisestart + 1)
						newstop = str(stop - excisestart + 1)
						type = item.split('_')[2]
						completed.append((cleanheader, start, stop, type))
						if type == 'phage':
							outphage.write('>' + header + '\t' + type+ '\t' + newstart + '\t' + newstop + '\n')
						if type == 'is':
							outis.write('>' + header + '\t' + type + '\t' + newstart + '\t' + newstop + '\n')
			else:
				try:
					items = excisedict[header]
					for item in items:
						start = item.split('_')[0]
						stop = item.split('_')[1]
						type = item.split('_')[2]
						if (header, int(start), int(stop), type) in completed:
							continue
						else:
							if type == 'phage':
								outphage.write('>' + header + '\t' + type + '\t' + start + '\t' + stop + '\n')
							if type == 'is':
								outis.write('>' + header + '\t' + type + '\t' + start + '\t' + stop + '\n')
				except KeyError:
					continue

