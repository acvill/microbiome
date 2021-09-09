#trim file to cutoff of e-value: 1e-50
#USAGE: python filter_card_output.py /workdir/users/agk85/CDC/card/metagenomes/B316-1/B316-1_card.txt /workdir/users/agk85/CDC/card/metagenomes/B316-1/B316-1_drug_specific_card_hits.txt 1e-50 Strict
import sys
inhandle = sys.argv[1]
outhandle = sys.argv[2]
cutoff = float(sys.argv[3])
type = sys.argv[4]

if type == 'Perfect':
	types = ['Perfect']

if type == 'Strict':
	types = ['Perfect','Strict']

if type == 'Loose':
	types = ['Perfect','Strict','Loose']


patient_aro = {}
patient_drug_file = open('/workdir/users/agk85/CDC/card/patient_drugs.txt','r')
for line in patient_drug_file:
	patient = line.split('\t')[0]
	aros = line.strip().split('\t')[3]
	drug = line.strip().split('\t')[2]
	try:
		patient_aro[patient].append((drug, aros))
	except KeyError:
		patient_aro[patient] = [(drug, aros)]

id_drug_dict = {}
patient = inhandle.split('/')[7].split('-')[0]
drug_aros = patient_aro[patient]
for drug_aro in drug_aros:
	drug = drug_aro[0]
	aros = drug_aro[1].split(';')
	for aro in aros:
		id_drug_dict[aro] = drug

infile = open(inhandle,'r')
header = infile.readline().strip()
outfile = open(outhandle,'w')
newheader = header + '\tdrug\n'
outfile.write(newheader) 

for line in infile:
	evalue = float(line.split('\t')[7])
	hittype = line.split('\t')[5]
	if hittype in types:
		if evalue < cutoff:
			aro_ids = line.split('\t')[10].split(', ')
			for aro_id in aro_ids:
				try:
					drug = id_drug_dict[aro_id]
					outfile.write('{0}\t{1}\n'.format(line.strip(),drug))
					break
				except KeyError:
					continue

outfile.close()
