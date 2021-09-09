mv MluCI.1.fastq MluCI-1.1.fastq
mv MluCI.1.solo.fastq MluCI-1.1.solo.fastq
mv MluCI.2.fastq MluCI-1.2.fastq
mv MluCI.2.solo.fastq MluCI-1.2.solo.fastq
mv ProxiMeta.1.fastq ProxiMeta-1.1.fastq
mv ProxiMeta.1.solo.fastq ProxiMeta-1.1.solo.fastq
mv ProxiMeta.2.fastq ProxiMeta-1.2.fastq
mv ProxiMeta.2.solo.fastq ProxiMeta-1.2.solo.fastq
mv Sau3aI.1.fastq Sau3aI-1.1.fastq
mv Sau3aI.1.solo.fastq Sau3aI-1.1.solo.fastq
mv Sau3aI.2.fastq Sau3aI-1.2.fastq
mv Sau3aI.2.solo.fastq Sau3aI-1.2.solo.fastq

#cleaning the idba output because you don't need it ever
rm contig-20.fa
rm contig-40.fa
rm contig-60.fa
rm contig-80.fa
rm graph-20.fa
rm graph-40.fa
rm graph-60.fa
rm graph-80.fa
rm align-20
rm align-40
rm align-60
rm align-80
rm kmer
rm local-contig-20.fa
rm local-contig-40.fa
rm local-contig-60.fa
rm local-contig-80.fa
