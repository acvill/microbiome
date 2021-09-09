import argparse, re, sys
from string import maketrans
from argparse import RawDescriptionHelpFormatter

#def getOptions():
description="""This script filters SAM files based on a minimum percent identity of reads mapping. Input: SAM and a min percent"""


parser = argparse.ArgumentParser(description=description, formatter_class=RawDescriptionHelpFormatter)
parser.add_argument('-i','--input', dest="sam", action='store', required=True,  help='Input sam file [REQUIRED]', metavar="SAM_FILE")
parser.add_argument('-p','--percent_id', dest="pct", action='store',required=True,   help='Minimum percent identity [REQUIRED]', type=float, metavar="PCT_ID")
#parser.add_argument('-o','--out', dest="out", action='store', required=True, help='Output file [REQUIRED]', metavar="OUT")
args = parser.parse_args()
#return(args)



def decode_cigar(cigar):
    # convert cigar string to number of hardclipped/match bases and total length
    hbeg = 0 # hardclipped bases at start
    alen = 0 # alignment length
    hend = 0 # hardclipped bases at end
    tlen = 0 # total length
    # split cigar string: 10H80M10S -> [10, 'H', 80, 'M', 10, 'S', '']
    tabs = re.split('([a-zA-Z])', cigar)[:-1]
    # iterate through cigar positions
    for i in range(len(tabs)/2):
        ci = int(tabs[i*2])
        li = tabs[i*2 + 1]
        # get hardclipped bases (all clipped bases are hardclipped)
        if li == 'H':
            if i == 0:
                hbeg += ci
            else:
                hend += ci
        # get matched bases
        if li == 'M':
            alen += ci
        # calculate total length
        if li != 'H' and li != 'D':
            tlen += ci
    # return numbers of hard-clipped bases, alignment length, total length
    return [hbeg, alen, hend, tlen]


def reverse_complement(seq):
    return seq.translate(maketrans('ACGTacgtNn', 'TGCAtgcaNn'))[::-1]


# initialize variables
cquery = '' # current query
cseq = '' # current seq
cqual = '' # current quals
cflag = 1 # current flag
cstrand = '' # current strand
# parse file
for line in open(args.sam):
    flag = 0
	# print header
    if line.startswith('@'):
        print line.rstrip()
        continue

    # Skip lines of type '@SQSN:BACT_983_t[M::main_mem] read 49506 sequences (10000212 bp)', which only contain one tab, or lines that aren't complete
    if len(line.split('\t')) < 13:
        continue
    
    # get fields
    sline = line.rstrip().split('\t') # split line
    query = sline[0] # query
    code = bin(int(sline[1]))[2:].zfill(12) # code
    strand = int(code[-5]) # strand
    ref = sline[2] # reference
    cigar = sline[5] # cigar
    seq = sline[9]
    qual = sline[10]

    # convert all clipped bases to hardclipped
    cigar = re.sub('H','S',cigar) # convert all clipped bases to hardclipped
    sline[5] = cigar
    
    # skip empty hits
    if ref == '*' or cigar == '*':
        continue

    # make sure read is mapped
    if int(code[-3]) == 1:
        print 'ERROR 0'
        quit()

    # calculate edit distance, total length
    [hbeg, alen, hend, tlen] = decode_cigar(cigar)
    mismatch = int(re.search('[NX]M:i:(\d+)', line).group(1))
    match = alen - mismatch

    # handle empty seq, qual fields
    # TG MODIFICATION: using FASTA so no qual
    #if (seq == '*' or qual == '*') and (cquery != query):
    if (seq == '*') and (cquery != query):
	flag = 1
	#print line
        #print 'ERROR 1'
        #quit()

    # update current seq, qual
    # TG MODIFICATION: using FASTA not FASTQ
    if cquery != query:
        #if seq == '*' or qual == '*':
        if seq == '*':
		flag = 1
	    #print 'ERROR 2'
            #quit()
        cquery = query
        cseq = seq
        cqual = qual
        cstrand = strand
        cflag = 1
    
    # filter by percent identity
    if 1.*match/tlen < 1.*args.pct/100.:
        continue
    
    # set the seq/qual columns
    if strand == cstrand:
        sline[9] = cseq
        sline[10] = cqual
    else:
        sline[9] = reverse_complement(cseq)
        sline[10] = reverse_complement(cseq)
    
    # double check our arithmetic
    #if tlen != (len(cseq) - hbeg - hend):
    #    quit()

    # finally, print quality filtered line
    if flag == 0:
	print '\t'.join(sline)



  
