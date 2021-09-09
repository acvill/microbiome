#remove_eukaryote_trans.py
import glob
euklist = []
WRK='/workdir/users/agk85/CDC'
eukpaths = glob.glob(WRK + '/combo_tables/metagenomes4/*_euk.txt')
for eukhandle in eukpaths:
	with open(eukhandle) as eukfile:
		for line in eukfile:
			euklist.append(line.split('\t')[0])


WRK='/workdir/users/agk85/CDC'
transpaths = glob.glob(WRK + '/newhic/mapping/*/*_trans_primary_99.txt')
for transpath in transpaths:
	transout  = transpath.split('.txt')[0] + '_noeuks' + '.txt'
	with open(transpath) as transfile:
		with open(transout,'w') as outfile:
			for line in transfile:
				r1 = line.split('\t')[2]
				r2 = line.split('\t')[8]
				if (r1 in euklist or r2 in euklist):
					continue
				else:
					outfile.write(line)
	


inhandle = WRK + '/newhic/mapping/trans_primary_ncol_99_withexcise.txt'
outhandle = WRK+'/newhic/mapping/trans_primary_ncol_99_withexcise_noeuks.txt'
deleted_trans = WRK+'/newhic/mapping/trans_primary_ncol_99_withexcise_euks.txt'



#inhandle = WRK + '/newhic/mapping/trans_primary_ncol_98.txt'
#outhandle = WRK+'/newhic/mapping/trans_primary_ncol_98_noeuks.txt'
#deleted_trans = WRK+'/newhic/mapping/trans_primary_ncol_98_euks.txt'
with open(inhandle) as infile:
	with open(outhandle,'w') as outfile:
		with open(deleted_trans,'w') as deleted:
			for line in infile:
				r1 = line.split('\t')[0]
				r2 = line.split('\t')[1]
				if (r1 in euklist or r2 in euklist):
					deleted.write(line)
				else:
					outfile.write(line)
				
