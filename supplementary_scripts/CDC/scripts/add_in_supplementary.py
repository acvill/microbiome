#goal is to grab all supplementary alignments if they have GATC in it

#B320-5_R1_B320-5_scaffold.supp.sam
#NS500503:541:HWF7YBGX3:1:11101:19191:1315       2064    B320-5_scaffold_38659   1       60      117H34M *       0       0       GGCTAATGGTTTATCAGTTAAATATCCAGAAAGG      EEEEEEEEEEEEEEEEEEEEEEAEEEE/EAAAAA      NM:i:0  MD:Z:34 AS:i:34 XS:i:0  SA:Z:B320-5_scaffold_58537,1,+,19S132M,60,0;


#grep 'GATC\|CTAG' B320-5_R1_B320-5_scaffold.supp.sam > B320-5_R1_supp_GATCorCTAG.txt
#grep 'GATC\|CTAG' B320-5_R2_B320-5_scaffold.supp.sam > B320-5_R2_supp_GATCorCTAG.txt
import sys
name = sys.argv[1]
#name= 'B314-1'
refhandle = '/workdir/users/agk85/CDC/newhic/mapping/'+ name +'/' + name + '_R2.nss.sam'
altreads = {}
with open(refhandle) as reffile:
	for line in reffile:
		altreads[line.split('\t')[0]]= line.split('\t')[2]


inhandle ='/workdir/users/agk85/CDC/newhic/mapping/'+ name +'/' + name + '_R1.supp.sam'
#inhandle = 'B320-5_R1_supp_GATCorCTAG.txt'
outhandle ='/workdir/users/agk85/CDC/newhic/mapping/'+ name +'/' + name + '_R1_supp.txt'
with open(inhandle) as infile:
	with open(outhandle,'w') as outfile:
		for line in infile:
			readid = line.split('\t')[0]
			supp1 = line.split('\t')[2]
			supp2 = line.split('SA:Z:')[1].split(',')[0]
			alt1 = altreads[readid]
			if alt1 == '*':
				continue
			l = [supp1, supp2, alt1]
			if len(set(l)) == 1:
				continue
			if len(set(l)) == 2:
				if (supp1 != supp2) & (supp1 != alt1):
					outfile.write(readid + '\t-\t'  + supp1 + '\t-\t-\t-\t-\t-\t' + alt1 + '\t-\t-\t-\n')				
			if len(set(l)) == 3:
				outfile.write(readid + '\t-\t'  + supp1 + '\t-\t-\t-\t-\t-\t' + supp2 + '\t-\t-\t-\n')
				outfile.write(readid + '\t-\t'  + supp1 + '\t-\t-\t-\t-\t-\t' + alt1+ '\t-\t-\t-\n')
				

refhandle = '/workdir/users/agk85/CDC/newhic/mapping/'+ name +'/' +name + '_R1.nss.sam'

altreads = {}
with open(refhandle) as reffile:
	for line in reffile:
		altreads[line.split('\t')[0]]= line.split('\t')[2]


inhandle = '/workdir/users/agk85/CDC/newhic/mapping/'+ name +'/' + name + '_R2.supp.sam'
#inhandle = 'B320-5_R2_supp_GATCorCTAG.txt'
outhandle ='/workdir/users/agk85/CDC/newhic/mapping/'+ name +'/' + name + '_R2_supp.txt'
with open(inhandle) as infile:
	with open(outhandle,'w') as outfile:
		for line in infile:
			readid = line.split('\t')[0]
			supp1 = line.split('\t')[2]
			supp2 = line.split('SA:Z:')[1].split(',')[0]
			alt1 = altreads[readid]
			l = [supp1, supp2, alt1]
			if alt1 == '*':
				continue
			if len(set(l)) == 1:
				continue
			if len(set(l)) == 2:
				if (supp1 != supp2) & (supp1 != alt1):
					outfile.write(readid + '\t-\t'  + alt1 + '\t-\t-\t-\t-\t-\t' + supp1 + '\t-\t-\t-\n')				
			if len(set(l)) == 3:
				outfile.write(readid + '\t-\t'  + supp1 + '\t-\t-\t-\t-\t-\t' + supp2 + '\t-\t-\t-\n')
				outfile.write(readid + '\t-\t'  + alt1 + '\t-\t-\t-\t-\t-\t' + supp1+ '\t-\t-\t-\n')
