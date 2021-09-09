#this will get the node rank for the taxids
def taxid_dict():
	noderank = {}
	inhandle = '/workdir/blastdb/newtaxdmp/nodes.dmp'
	with open(inhandle) as infile:
		for line in infile:
			fields = line.split("\t|\t")
			taxid = fields[0]
			rank = fields[2]
			noderank[taxid] = rank
	
	
	ranks = ['species','genus','family','order','class','phylum','kingdom']
	delimnames = {'species':'s__','genus':'g__','family':'f__','order':'o__','class':'c__','phylum':'p__','kingdom':'k__'}
	
	def replace_rank(taxonomy, origtaxa, delim):
		"""replace rank taxonomy with the scientific name if in ranks"""
		newtaxonomy = taxonomy.split(delim)[0] + delim + origtaxa + taxonomy.split(delim)[1]
		return newtaxonomy

	#taxid	
	#here take the ranked lineages and then replace with the scientific name of the organism
	#if it has uncultured in it...then change to ''
	taxid_dict = {}
	inhandle = '/workdir/blastdb/newtaxdmp/rankedlineage.dmp'
	with open(inhandle) as infile:
		for line in infile:
			taxid = line.split('\t')[0]
			fields = line.split("\t|\t")
			taxonomy = 'k__{0}; p__{1}; c__{2}; o__{3}; f__{4}; g__{5}; s__{6};'.format(fields[9].split('\t')[0], fields[7], fields[6], fields[5], fields[4], fields[3],fields[2].replace(' ', '_'))
			origtaxa = fields[1]
			if 'uncultured' in origtaxa:
				origtaxa = ''
			origtaxarank = noderank[taxid]
			if origtaxarank == 'species':
				origtaxa = origtaxa.replace(' ', '_')
			if origtaxarank in ranks:
				delim = delimnames[origtaxarank]
				newtaxonomy = replace_rank(taxonomy, origtaxa, delim)
			else:
				newtaxonomy = taxonomy
			#remove [ and ] 
			newtaxonomy = newtaxonomy.replace(']','').replace('[','')
			taxid_dict[taxid] = newtaxonomy
	#now add in all the ones that I've picked up along the way
	taxid_dict['2024339']='k__Viruses; p__; c__; o__Caudovirales; f__Siphoviridae; g__C2virus; s__Lactococcus_phage_62403;'
	taxid_dict['2024338']='k__Viruses; p__; c__; o__Caudovirales; f__Siphoviridae; g__C2virus; s__Lactococcus_phage_62402;'
	taxid_dict['2024335']='k__Viruses; p__; c__; o__Caudovirales; f__Siphoviridae; g__C2virus; s__Lactococcus_phage_37203;'
	taxid_dict['2024334']='k__Viruses; p__; c__; o__Caudovirales; f__Siphoviridae; g__C2virus; s__Lactococcus_phage_05802;'
	taxid_dict['2024337']='k__Viruses; p__; c__; o__Caudovirales; f__Siphoviridae; g__C2virus; s__Lactococcus_phage_50504;'
	taxid_dict['2024336']='k__Viruses; p__; c__; o__Caudovirales; f__Siphoviridae; g__C2virus; s__Lactococcus_phage_50102;'
	taxid_dict['2282309']='k__Bacteria; p__Proteobacteria; c__Gammaproteobacteria; o__Enterobacterales; f__Enterobacteriaceae; g__; s__Enterobacteriaceae_bacterium_w17;'
	taxid_dict['2282310']='k__Bacteria; p__Proteobacteria; c__Gammaproteobacteria; o__Enterobacterales; f__Enterobacteriaceae; g__; s__Enterobacteriaceae_bacterium_w6;'
	taxid_dict['2268104']='k__other sequences; p__artificial sequences; c__vectors; o__; f__; g__; s__Phagemid_vector_pScaf-8064.3;'
	taxid_dict['2268096']='k__other sequences; p__artificial sequences; c__vectors; o__; f__; g__; s__Phagemid_vector_pScaf-5544.1;'
	taxid_dict['2268106']='k__other sequences; p__artificial sequences; c__vectors; o__; f__; g__; s__Phagemid_vector_pScaf-8064.5;'
	taxid_dict['2268101']='k__other sequences; p__artificial sequences; c__vectors; o__; f__; g__; s__Phagemid_vector_pScaf-7560.2;'
	taxid_dict['2268097']='k__Bacteria; p__Firmicutes; c__Bacilli; o__Bacillales; f__Bacillales Family XI. Incertae Sedis; g__Gemella; s__Phagemid_vector_pScaf-5544.2;'
	taxid_dict['2040624']='k__Viruses; p__; c__; o__Caudovirales; f__Myoviridae; g__Tevenvirinae; s__T4virusGemella_sp._ND_6198;'
	taxid_dict['2234085']='k__Viruses; p__; c__; o__Caudovirales; f__Myoviridae; g__Tevenvirinae; s__T4virusEscherichia_phage_vB_EcoM_JB75;'
	taxid_dict['2202142']='k__Bacteria; p__Proteobacteria; c__Betaproteobacteria; o__Neisseriales; f__Chromobacteriaceae; g__Chromobacterium group; s__ChromobacteriumChromobacterium_sp._IIBBL_274-1;'
	taxid_dict['2234047']='k__Viruses; p__; c__; o__Caudovirales; f__Myoviridae; g__Tevenvirinae; s__Jd18virusKlebsiella_phage_Mineola;'
	taxid_dict['2268610']='k__Viruses; p__; c__; o__Caudovirales; f__Siphoviridae; g__Tunavirinae; s__Kp36virusKlebsiella_phage_NJS1;'
	taxid_dict['2268098']='k__other sequences; p__artificial sequences; c__vectors; o__; f__; g__; s__Phagemid_vector_pScaf-5544.3;'
	taxid_dict['2268099']='k__other sequences; p__artificial sequences; c__vectors; o__; f__; g__; s__Phagemid_vector_pScaf-5544.4;'
	taxid_dict['2267236']='k__Viruses; p__; c__; o__Caudovirales; f__Myoviridae; g__Tevenvirinae; s__MoonvirusCitrobacter_phage_CF1_ERZ-2017;'
	taxid_dict['2024340']='k__Viruses; p__; c__; o__Caudovirales; f__Siphoviridae; g__C2virus; s__Lactococcus_phage_62606;'
	taxid_dict['2024341']='k__Viruses; p__; c__; o__Caudovirales; f__Siphoviridae; g__C2virus; s__Lactococcus_phage_74001;'
	taxid_dict['2202141']='k__Bacteria; p__Proteobacteria; c__Betaproteobacteria;o__Neisseriales; f__Chromobacteriaceae; g__Chromobacterium; s__Chromobacterium_sp._IIBBL_112-1;'
	taxid_dict['2202644']='k__Viruses; p__; c__; o__; f__Microviridae; g__; s__Microviridae_sp.;'
	taxid_dict['2259647']='k__Bacteria; p__Proteobacteria; c__Gammaproteobacteria; o__Enterobacterales; f__Enterobacteriaceae; g__Raoultella; s__Raoultella_sp._X13;'
	taxid_dict['2201420']='k__Viruses; p__; c__; o__; f__; g__; s__Ralstonia_phage_phiRSP;'
	taxid_dict['2302864']='k__other sequences; p__artificial sequences; c__vectors; o__; f__; g__; s__;'
	taxid_dict['2302865']='k__other sequences; p__artificial sequences; c__vectors; o__; f__; g__; s__;'
	taxid_dict['2302866']='k__other sequences; p__artificial sequences; c__vectors; o__; f__; g__; s__;'
	taxid_dict['2302863']='k__other sequences; p__artificial sequences; c__vectors; o__; f__; g__; s__;'
	taxid_dict['2268092']='k__other sequences; p__artificial sequences; c__vectors; o__; f__; g__; s__;'
	taxid_dict['2268102']='k__other sequences; p__artificial sequences; c__vectors; o__; f__; g__; s__;'
	taxid_dict['2268103']='k__other sequences; p__artificial sequences; c__vectors; o__; f__; g__; s__;'
	taxid_dict['2315580']='k__Viruses; p__; c__; o__Caudovirales; f__Myoviridae; g__Tevenvirinae; s__T4virus;'
	taxid_dict['2231359']='k__Viruses; p__; c__; o__Caudovirales; f__Siphoviridae; g__unclassified Siphoviridae; s__;'
	taxid_dict['2234080']='k__Viruses; p__; c__; o__Caudovirales; f__Myoviridae; g__Tevenvirinae; s__Rb69virus;'
	taxid_dict['2231340']='k__Viruses; p__; c__; o__Caudovirales; f__Siphoviridae; g__; s__unclassified Siphoviridae;'
	taxid_dict['2267250']='k__Viruses; p__; c__; o__Caudovirales; f__Podoviridae; g__P22virus; s__unclassified_P22likevirus;'
	taxid_dict['2340712']='k__Viruses; p__; c__; o__Caudovirales; f__Myoviridae; g__Peduovirinae; s__P2virus;'
	taxid_dict['2340715']='k__Viruses; p__; c__; o__Caudovirales; f__Myoviridae; g__Tevenvirinae; s__Rb69virus;'
	taxid_dict['2231358']='k__Viruses; p__; c__; o__Caudovirales; f__Siphoviridae; g__unclassified Siphoviridae; s__;'
	taxid_dict['2315700']='k__Viruses; p__; c__; o__Caudovirales; f__Myoviridae; g__unclassified Myoviridae; s__;'
	taxid_dict['2182324']='k__Viruses; p__; c__; o__Caudovirales; f__Siphoviridae; g__Hk97virus; s__unclassified_Hk97virus;'
	taxid_dict['2282412']='k__Viruses; p__; c__; o__Caudovirales; f__Siphoviridae; g__Lambdavirus; s__unclassified_Lambdavirus;'
	taxid_dict['2282475']='k__Bacteria; p__Proteobacteria; c__Burkholderiales; o__Alcaligenaceae; f__Achromobacter; g__; s__;'
	taxid_dict['2082193']='k__Bacteria; p__Firmicutes; c__Clostridia; o__Clostridiales; f__Clostridiaceae; g__; s__unclassified_Clostridiaceae;'
	taxid_dict['2036206']='k__Bacteria; p__Firmicutes; c__Bacilli; o__Lactobacillales; f__Aerococcaceae; g__; s__unclassified_Aerococcaceae;'
	taxid_dict['2107999']='k__Bacteria; p__Firmicutes; c__Bacilli; o__Lactobacillales; f__Lactobacillaceae; g__Lactobacillus; s__;'
	taxid_dict['2382163']='k__Bacteria; p__Firmicutes; c__Bacilli; o__Lactobacillales; f__Streptococcaceae; g__Streptococcus; s__;'
	taxid_dict['2447890']='k__Bacteria; p__Proteobacteria; c__Gammaproteobacteria; o__Enterobacterales; f__Yersiniaceae; g__Serratia; s__;'
	taxid_dict['2126346']='k__Bacteria; p__Actinobacteria; c__Actinobacteria; o__Streptomycetales; f__Streptomycetaceae; g__Streptacidiphilus; s__Streptacidiphilus_sp._DSM_106435;'
	taxid_dict['1885026']='k__Bacteria; p__Actinobacteria; c__Actinobacteria; o__Corynebacteriales; f__Mycobacteriaceae; g__Mycobacterium; s__Mycobacterium_grossiae;'
	taxid_dict['1756148']='k__Bacteria; p__Bacteroidetes; c__Flavobacteriia; o__Flavobacteriales; f__Flavobacteriaceae; g__Elizabethkingia; s__Elizabethkingia_miricola;'
	taxid_dict['1606016']='k__Bacteria; p__Bacteroidetes; c__Flavobacteriia; o__Flavobacteriales; f__Flavobacteriaceae; g__Elizabethkingia; s__Elizabethkingia_anophelis;'
	taxid_dict['1873418']='k__Bacteria; p__Bacteroidetes; c__Flavobacteriia; o__Flavobacteriales; f__Flavobacteriaceae; g__Elizabethkingia; s__Elizabethkingia_occulta;'
	taxid_dict['1873419']='k__Bacteria; p__Bacteroidetes; c__Flavobacteriia; o__Flavobacteriales; f__Flavobacteriaceae; g__Elizabethkingia; s__Elizabethkingia_ursingii;'
	taxid_dict['665948']='k__Bacteria; p__Proteobacteria; c__Gammaproteobacteria; o__Pseudomonadales; f__Pseudomonadaceae; g__Pseudomonas; s__Pseudomonas_aeruginosa;'
	taxid_dict['1118055']='k__Bacteria; p__Firmicutes; c__Tissierellia; o__Tissierellales; f__Peptoniphilaceae; g__Anaerococcus; s__Anaerococcus_vaginalis;'
	taxid_dict['1662457']='k__Bacteria; p__Proteobacteria; c__Betaproteobacteria; o__Burkholderiales; f__Comamonadaceae; g__Acidovorax; s__Acidovorax_carolinensis;'
	taxid_dict['1662456']='k__Bacteria; p__Proteobacteria; c__Betaproteobacteria; o__Burkholderiales; f__Comamonadaceae; g__Acidovorax; s__Acidovorax_carolinensis;'
	taxid_dict['1649555']='k__Bacteria; p__Proteobacteria; c__Alphaproteobacteria; o__Rhizobiales; f__Bradyrhizobiaceae; g__Variibacter; s__Variibacter_gotjawalensis;'
	taxid_dict['1662458']='k__Bacteria; p__Proteobacteria; c__Betaproteobacteria; o__Burkholderiales; f__Comamonadaceae; g__Acidovorax; s__Acidovorax_carolinensis;'
	taxid_dict['665938']='k__Bacteria; p__Bacteroidetes; c__Bacteroidia; o__Bacteroidales; f__Bacteroidaceae; g__Bacteroides; s__Bacteroides_fragilis;'
	taxid_dict['702969']='k__Bacteria; p__Actinobacteria; c__Actinobacteria; o__Corynebacteriales; f__Corynebacteriaceae; g__Corynebacterium; s__Corynebacterium_hadale;'
	taxid_dict['702953']='k__Bacteria; p__Actinobacteria; c__Actinobacteria; o__Corynebacteriales; f__Corynebacteriaceae; g__Corynebacterium; s__Corynebacterium_hadale;'
	taxid_dict['563191']='k__Bacteria; p__Firmicutes; c__Negativicutes;  o__Acidaminococcales; f__Acidaminococcaceae; g__Acidaminococcus; s__Acidaminococcus_intestini;'
	taxid_dict['665937']='k__Bacteria; p__Firmicutes; c__Clostridia;  o__Clostridiales; f__Lachnospiraceae; g__Anaerostipes; s__Anaerostipes_caccae;'
	taxid_dict['657310']='k__Bacteria; p__Firmicutes; c__Bacilli;  o__Lactobacillales; f__Enterococcaceae; g__Enterococcus; s__Enterococcus_faecalis;'
	taxid_dict['2250596']='k__Bacteria; p__Firmicutes; c__Bacilli;  o__Lactobacillales; f__Streptococcaceae; g__Streptococcus; s__Streptococcus_sp._596553;'
	taxid_dict['469586']='k__Bacteria; p__Bacteroidetes; c__Bacteroidia;  o__Bacteroidales; f__Bacteroidaceae; g__Bacteroides; s__Bacteroides_thetaiotaomicron;'
	taxid_dict['702959']='k__Bacteria; p__Actinobacteria; c__Actinobacteria; o__Corynebacteriales; f__Corynebacteriaceae; g__Corynebacterium; s__Corynebacterium_hadale;'
	taxid_dict['469608']='k__Bacteria; p__Proteobacteria; c__Gammaproteobacteria;  o__Enterobacterales; f__Enterobacteriaceae; g__Klebsiella; s__Klebsiella_variicola;'
	taxid_dict['469587']='k__Bacteria; p__Bacteroidetes; c__Bacteroidia;  o__Bacteroidales; f__Bacteroidaceae; g__Bacteroides; s__Bacteroides_fragilis;'
	taxid_dict['469595']='k__Bacteria; p__Proteobacteria; c__Gammaproteobacteria;  o__Enterobacterales; f__Enterobacteriaceae; g__Citrobacter; s__Citrobacter_portucalensis;'
	taxid_dict['469594']='k__Bacteria; p__Actinobacteria; c__Actinobacteria;  o__Bifidobacteriales; f__Bifidobacteriaceae; g__Bifidobacterium; s__Bifidobacterium_longum;'
	taxid_dict['2211115']='k__Bacteria; p__Proteobacteria; c__Gammaproteobacteria;  o__Enterobacterales; f__Enterobacteriaceae; g__Enterobacter; s__Enterobacter_roggenkampii_TUM15672;'
	taxid_dict['469596']='k__Bacteria; p__Firmicutes; c__Erysipelotrichia;  o__Erysipelotrichales; f__Erysipelotrichaceae; g__Coprobacillus; s__Coprobacillus_cateniformis;' 
	taxid_dict['469598']='k__Bacteria; p__Proteobacteria; c__Gammaproteobacteria;  o__Enterobacterales; f__Enterobacteriaceae; g__Escherichia; s__Escherichia_coli;'
	return taxid_dict
