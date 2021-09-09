
library(VirFinder)
# only parse the command line arguments following the script name
argv <- commandArgs(TRUE)
infile <- argv[1]
#infile <- "/workdir/users/agk85/CDC/prodigal/metagenomes/B309-2/B309-2_test.fasta"
#infile <- system.file("data", "contigs.fa", package="VirFinder")
## (1) set the input fasta file name. 

## (2) prediction
predResult <- VF.pred(infile)

#### (2.1) sort sequences by p-value in ascending order
predResult[order(predResult$pvalue),]

#### (2.2) estimate q-values (false discovery rates) based on p-values
#predResult$qvalue <- VF.qvalue(predResult$pvalue)

#### (2.3) sort sequences by q-value in ascending order
#predResult[order(predResult$qvalue),]

write.table(predResult, argv[2],sep="\t")

proc.time()


