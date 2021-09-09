

from Bio import SeqIO
import collections
import argparse
from argparse import RawDescriptionHelpFormatter

def getOptions():
        """Get arguments"""
        description="""This script splits a fasta file into X entries"""
        parser = argparse.ArgumentParser(description=description, formatter_class=RawDescriptionHelpFormatter)
        parser.add_argument('-f', '--fasta', dest='fasta', action='store', required=True, type=str, help='Fasta file [Required]', metavar='FASTA') 
        parser.add_argument('-n', '--number', dest='number',action = 'store', required=True, type=int, help='Number of entries [Required]', metavar='NUMBER')
        parser.add_argument('-o', '--outfile', dest='outfile', action='store', required=True, type=str, help='Outfile [Required]', metavar='OUT')
	args = parser.parse_args()
        return(args)

args = getOptions()
fasta = args.fasta
number = args.number
outfile = args.outfile
print(number)

def batch_iterator(iterator, batch_size):
	"""Returns lists of length batch_size.

	This can be used on any iterator, for example to batch up
	SeqRecord objects from Bio.SeqIO.parse(...), or to batch
	Alignment objects from Bio.AlignIO.parse(...), or simply
	lines from a file handle.

	This is a generator function, and it returns lists of the
	entries from the supplied iterator.  Each list will have
	batch_size entries, although the final list may be shorter.
	"""
	entry = True  # Make sure we loop once
	while entry:
		batch = []
		while len(batch) < batch_size:
			try:
				entry = iterator.next()
			except StopIteration:
				entry = None
			if entry is None:
				# End of file
				break
			batch.append(entry)
		if batch:
			yield batch




record_iter = SeqIO.parse(open(fasta),"fasta")
for i, batch in enumerate(batch_iterator(record_iter, number)):
    filename = outfile + "_group_%i.fasta" % (i + 1)
    with open(filename, "w") as handle:
        count = SeqIO.write(batch, handle, "fasta")
    print("Wrote %i records to %s" % (count, filename))
