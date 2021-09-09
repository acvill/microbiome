
# 0.ScfID
# 1Plasmid_Finder(pid|start_stop)
# 2Full_Plasmids(pid|start_stop)
# 3Relaxase(eval|start_stop_rpkm_covg)
# 4Plasmid_pfams(name|start_stop_rpkm_covg)
# 	5Resfams
# 	6Perfect
# 	7CARD
# 8ISEScan
# 9Phage_Finder(start_stop)
# 10Phaster(pid|start_stop)
# 	11VOGS(vog|bit|start_stop_rpkm_covg)
# 12VF(gene|pid|start_stop_rpkm_covg)
# 13tRNASCAN(trna_cove_start_stop)
# 14Imme_plasmid(element_pid_start_stop)
# 15Imme_phage(element_pid_start_stop)
# 16Imme_transposon(element_pid_start_stop)
# 17Imme_intron(element_pid_start_stop)
# 18Imme_gi(element_pid_start_stop)
# 19Aclame_plasmid(element_pid_start_stop)
# 20Aclame_phage(element_pid_start_stop)
# 	21 Other_pfams(name|start_stop_rpkm_covg)
# 	22Amphora(best_taxonomy(confidence))
# 	23Rnammer(taxa_pid_start_stop)
# 	24Barrnap(pid|taxa)
# 	25Campbell(pid|taxa)
# 	26Metaphlan
# 	27GSMer
# 	28Best_org(amphora_rnammer)

outhandle = 'mge_counts.txt'
a=0
b=0
c=0
d=0
e=0
f=0
g=0
h=0
i=0
j=0
k=0
l=0
m=0
n=0
o=0
p = 0
q = 0
r = 0
bestorg=0
mobile=0
with open(outhandle,'w') as outfile:
	infile = open('all_master_table_binary.txt','r')
	for inline in infile: 
		if inline[0] != 'S':
			fields = inline.strip().split('\t')
			#which fields are mobile right now: 1,2,3,4,8,9,10,14,15,16,19,20
			if fields[1] + fields[2] + fields[3] + fields[4] + fields[8] + fields[9] + fields[10] + fields[14] + fields[15] + fields[16] + fields[19] + fields[20]!= '000000000000':
				mobile +=1
				#besttaxonomy
				if fields[27] != '0':
					bestorg +=1
			if fields[1] != '0':
				a +=1
			if fields[2] != '0':
				b +=1
			if fields[3] != '0':
				c +=1
			if fields[4] != '0':
				d +=1	
			if fields[8] != '0':
				e += 1
			if fields[9] != '0':
				f +=1
			if fields[10] != '0':
				g +=1
			if fields[14] != '0':
				h +=1
			if fields[15] != '0':
				i +=1
			if fields[16] != '0':
				j +=1
			if fields[19] != '0':
				k +=1
			if fields[20] != '0':
				l +=1
			plasmidsum = float(fields[1]) + float(fields[2]) + float(fields[3]) + float(fields[4]) + 	\
			float(fields[14]) + float(fields[19])
			if plasmidsum> 0:
				m +=1
			if plasmidsum>1:
				p+=1
			phagesum = float(fields[9]) + float(fields[10]) + float(fields[15]) + float(fields[20])
			if phagesum > 0:
				n +=1
			if phagesum > 1:
				q +=1
			transposonsum = float(fields[8]) + float(fields[16])
			if transposonsum>0:
				o +=1
			if transposonsum>1:
				r +=1
	outfile.write('Mobile_elements\t{0}\nMobile_with_bestorg\t{1}\nPlasmid_Finder\t{2}\n\
Full_Plasmids\t{3}\nRelaxase\t{4}\nPlasmid_pfams\t{5}\nISEScan\t{6}\nPhage_Finder\t{7}\n\
Phaster\t{8}\nImme_plasmid\t{9}\nImme_phage\t{10}\nImme_transposon\t{11}\nAclame_plasmid\t{12}\n\
Aclame_phage\t{13}\nPlasmids1+\t{14}\nPhage1+\t{15}\nTransposon1+\t{16}\nPlasmids2+\t{17}\n\
Phage2+\t{18}\nTransposon2+\t{19}'.format(mobile,bestorg, a,b,c,d,e,f,g,h,i,j,k,l,m,n,o, p, q, r))




