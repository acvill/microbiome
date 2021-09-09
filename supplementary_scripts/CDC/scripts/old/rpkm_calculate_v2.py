#!/usr/bin/env python

from __future__ import division
import argparse
import pysam
import logging
import csv
import collections
import numpy as np
from argparse import RawDescriptionHelpFormatter
csv.field_size_limit(1000000000)

# Author: Felicia New, 2017


def getOptions():
    """ Function to pull in arguments """

    description="""This script can be used to calculates coverage (RPKM) using a BAM file and the output from SAMTools idxstats.\n
    RPKM = Reads per kilobase per million, (Mortazavi, 2008)"""



    parser = argparse.ArgumentParser(description=description, formatter_class=RawDescriptionHelpFormatter)
    parser.add_argument("-b", "--bam", dest="bname", action='store', required=True, help="bam alignment file [Required]", metavar="BAM_FILE")     
    parser.add_argument("-s", "--stat", dest="sname", action='store', required=True, help="Output from samtools idxstats [Required]", metavar="STAT_FILE")
    parser.add_argument("-g", "--log", dest="log", action='store', required=False, help="Log File", metavar="LOG_FILE") 
    parser.add_argument("-o", "--out", dest="out", action='store', required=True, help="Out File", metavar="OUT_FILE")
    args = parser.parse_args()
    return(args)


def setLogger(fname, loglevel):
    """ Function to handle error logging """
    logging.basicConfig(filename=fname, filemode='w', level=loglevel, format='%(asctime)s - %(levelname)s - %(message)s')


# SAM functions
def read_bam(args):
    """ Function to read BAM file to get number of mapped reads """
    logging.info("Reading BAM file '%s'." % args.bname)
    samfile = pysam.AlignmentFile(args.bname, "rb")
    total_mapped_reads=int(samfile.mapped)
    return(total_mapped_reads)


# IDXStats Functions
def read_stats(args):
    """ Reading the IDXStats output file to get region_length and number of reads mapped to each region """
    logging.info("Reading the idxstats output file '%s'." % args.sname)
    bdict = collections.defaultdict(dict)
    with open(args.sname,'r') as STAT:
        reader = csv.reader(STAT,delimiter='\t')
	for row in reader:
	    name = row[0]
	    length = int(row[1])
	    num_mapped = int(row[2])
	    num_unmapped = int(row[3])
	    start = 0
	    end = length
	    bdict[name]['name'] = name #Name of the gene/reference
            bdict[name]['length'] = length #Length of the gene
	    bdict[name]['num_mapped'] = num_mapped #Number of reads mapped to the gene
	    bdict[name]['num_unmapped'] = num_unmapped
	    bdict[name]['start'] = start
	    bdict[name]['end'] = end
        cdict = collections.defaultdict(dict)
	for gene in bdict:
	    name = bdict[name]['name']
	    num_mapped = bdict[name]['num_mapped']
	    start = bdict[name]['start']
	    end = bdict[name]['end']
	    length = bdict[name]['length']
            cdict[name].update(dict((x,name) for x in xrange(start,end+1))) #Create a look up dict by gene
	return(bdict,cdict)    


# Coverage Functions
    """ Calculate different coverage metrics: Estimate number of reads in regions, Average per nucleotide coverage (APN),
    Reads per kilobase per million mapped reads (RPKM), average coverage across region (mean), stdev of coverage in region (std),
    and coefficient of variation (cv). """
def calc_coverage(args,bdict,total_mapped_reads):
    logging.info("Calculating Coverage Counts")
    for name in bdict:
	depth = (bdict[name]['num_mapped'])
	if depth != 0:
	    adj_length = bdict[name]['length'] / 1000
	    adj_total_reads = total_mapped_reads / 1000000
	    bdict[name]['rpkm'] = (bdict[name]['num_mapped']) / (adj_length * adj_total_reads) # Calculates reads per kilobase per million mapped reads RPKM from Moretzavi et al.
	else:
	    # if there is no coverage set everything to 0
	    bdict[name]['rpkm'] = 0
    return(bdict)


#Output Functions
def writeOutput(args,bdict):
    """ Brute force methods... """
    logging.info("Writing Output")

    header = ['gene_id','mapped_reads','region_length','rpkm']
    with open(args.out, 'wb') as OUT:
	OUT.write(','.join(header) + '\n')
	for key in bdict:
	    OUT.write(','.join(str(x) for x in [key,bdict[key]['num_mapped'],bdict[key]['length'],bdict[key]['rpkm']]) + '\n')



def main():
    """ MAIN Function to execute everything """
    args = getOptions()
    if args.log:                               # Turn on logging if option -g was given
	setLogger(args.log,logging.INFO)

    total_mapped_reads = read_bam(args)  #Use BAM file to count the number of mapped reads
    bdict,cdict = read_stats(args)                    #Read through stats file and create dictionary to sort all info
    calc_coverage(args,bdict,total_mapped_reads)    # Use info stored in bdict to calculate coverage (APN, RPKM), and other measures
    writeOutput(args,bdict) #Write output to CSV file

if __name__=='__main__':
    main()
    logging.info("Script complete")


