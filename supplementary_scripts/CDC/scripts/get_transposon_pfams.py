import sys
#USAGE: python get_plasmid_pfams.py /workdir/users/agk85/CDC/annotation/metagenomes2/B309-1_pfam.txt /workdir/users/agk85/CDC/plasmids/metagenomes2/B309-1_plasmid_pfams.txt

from igraph import *
import glob

#reference
refhandle = '/workdir/refdbs/Pfams/Smillie_pfams.txt'
pfams = []
with open(refhandle) as reffile:
	for line in reffile:
		pfams.append(line.split('.')[0])

tpn = {}
mge = {}
tblpaths = glob.glob('/workdir/users/agk85/CDC' + '/combo_tables/metagenomes4/*_master_scf_table.txt')
for tblfile in tblpaths:
	with open(tblfile) as t:
		header = t.readline()
		for line in t:
			if ('IS_' in line or 'transposon_' in line):
				tpn[line.split('\t')[0]] = 1
			else:
				tpn[line.split('\t')[0]] = 0
			if line.split('\t')[29] == 'mge':
				mge[line.split('\t')[0]] = 1
			else:
				mge[line.split('\t')[0]] = 0

good = 0
bad = 0
goodmge = 0
badmge = 0
contig_tpns = {}
for tblfile in tblpaths:
	name = tblfile.split('/')[7].split('_')[0]
	with open('/workdir/users/agk85/CDC/annotation/metagenomes3/'+name+'_pfam.txt') as pfamfile:
		with open('/workdir/users/agk85/CDC/annotation/'+name+'_transposons.txt','w') as outfile:
			for line in pfamfile:
				pfamid = line.split('\t')[3].split('.')[0]
				geneid = line.split('\t')[0]
				scfid = line.split('_')[0] +'_'+ line.split('_')[1] +'_'+line.split('_')[2]
				if pfamid in pfams:
					try:
						calledastpn = tpn[scfid]
						calledasmge = mge[scfid]
					except KeyError:
						calledastpn = 'euk'
						calledasmge = 'euk'
					if calledastpn == 1:
						good +=1
					elif calledastpn == 0:
						bad +=1
					if calledasmge == 1:
						goodmge +=1
					elif calledasmge == 0:
						badmge +=1
					contig_tpns[scfid] = (calledastpn, calledasmge)
					outfile.write(line.strip() + '\t' +pfamid + '\t' +str(calledastpn) + '\t' + str(calledasmge)+'\n')

g = Graph.Read_Ncol('/workdir/users/agk85/CDC/newhic/mapping/trans_primary_ncol_' + '98' + '_withexcise_noeuks.txt',weights=True, directed=True)
g.to_undirected(mode="collapse",combine_edges="sum")
#only keep the links greater than 2
g.es.select(weight_lt=2).delete()	

inhic = g.vs['name']
for contig in inhic:
	hiccontig[contig] = '1'

goodmgecontig = 0
badmgecontig = 0
goodcontig = 0
badcontig = 0
itsinhic = 0
notinhic = 0
with open('/workdir/users/agk85/CDC/annotation/all_tpn_contigs.txt','w') as outfile:
	for contig in contig_tpns.keys():
		calledastpn,calledasmge = contig_tpns[contig]
		try:
			if hiccontig[contig] == '1':
				itsinhic += 1
				if calledastpn == 1:
					goodcontig +=1
				elif calledastpn == 0:
					badcontig += 1
				if calledasmge == 1:
					goodmgecontig += 1
				elif calledasmge == 0:
					badmgecontig += 1
				outfile.write(contig + '\t' +str(calledastpn) + '\t' + str(calledasmge)+'\n')
		except KeyError:
			notinhic += 1

