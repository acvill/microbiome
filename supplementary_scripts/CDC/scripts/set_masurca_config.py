#python script to create configuration text file for masurca given r1, r2 and root name
#usage set_masurca_config.py r1path r2path name
from Bio import SeqIO
import sys
import numpy

jfdict = {}
jfsizes = open('/workdir/users/agk85/CDC/masurca/jfsizes.txt','r')
for line in jfsizes:
	jfdict[line.split(',')[0]] = line.strip().split(',')[1]
	
r1 = sys.argv[1]
r2 = sys.argv[2]
name = sys.argv[3]
outfile = open(name+'_configuration.txt','w')
lens = []
for rec in SeqIO.parse(r1,'fastq'):
	lens.append(len(rec))

for rec in SeqIO.parse(r2,'fastq'):
	lens.append(len(rec))


mean = str(int(round(numpy.mean(lens),0)))
sd = str(int(round(numpy.std(lens),0)))
outfile.write('DATA\n')
outfile.write("PE= pe {0} {1} {2} {3}\n".format(str(mean), str(sd), r1, r2))
outfile.write('END\n\nPARAMETERS\nGRAPH_KMER_SIZE = auto\nUSE_LINKING_MATES = 1\nLIMIT_JUMP_COVERAGE = 300\nCA_PARAMETERS =  cgwErrorRate=0.25\nKMER_COUNT_THRESHOLD = 1\nNUM_THREADS = 16\n')
outfile.write('JF_SIZE = {0}\n'.format(jfdict[name]))
outfile.write('SOAP_ASSEMBLY=0\nEND')
outfile.close()
