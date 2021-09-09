
for file in */*_scaffold_nomges.fasta; do mv $file ${file}.fna; ; done
for fold in B*; do grep '>' ${fold}/${fold}*.fasta > ${fold}/${fold}_binid_contig.txt; done
for fold in B*; do python contig_clusters.py ${fold}/${fold}_binid_contig.txt ${fold}/${fold}_networkcluster.txt; done
for fold in B*; do awk -v OFS="\t" '$1=$1' ${fold}/checkm_lineage/${fold}.qa | cut -f1,2,7,8,9,10 > ${fold}/${fold}.stats; done
