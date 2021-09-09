infile = read.csv("maxbin_conflict.txt",header=T, sep='\t')

infile_sub = infile
infile_sub$Sample <-NULL
infile_sub$Count <- NULL
attach(infile_sub)
taxa_leve <- infile_sub$taxa_level
infile_sub$taxa_level <-NULL
aggdata <-aggregate(infile_sub, by=list(taxa_level), FUN=sum, na.rm=TRUE)
aggdata$conflict_percentage <- aggdata$with_conflict/(aggdata$with_taxa + aggdata$without_taxa)

write.csv(aggdata, "maxbin_conflict_levels.txt")



indata <- read.csv("sample.stats",header=F, sep='\t')

completeness <- mean(indata$V3)
contamination<- mean(indata$V4)
hetero <- mean(indata$V5)
completeness
contamination
hetero
