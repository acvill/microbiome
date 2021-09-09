library(ggplot2)
library(gplots)
library(vegan)
library(reshape2)
library(RColorBrewer)
library(plyr)
library(gridExtra)
library(igraph)
set.seed(42)
theme_nogrid <- function (base_size = 12, base_family = "") {
  theme_bw(base_size = base_size, base_family = base_family) %+replace%
    theme(panel.grid = element_blank())}
theme_set(theme_nogrid())

args <- commandArgs(trailingOnly = TRUE)
minreads = args[1]
genetype = args[2]

###########
#import data
###########
setwd("/workdir/users/agk85/CDC2/bins/diversity_figures")
infile = paste(genetype, "_", minreads,"_sample_pairwise_connection_counts.txt",sep="")
df <-read.table(infile,header=T, sep="\t")
################
#colors
################
arg.palette <-colorRampPalette(brewer.pal(12,"Set3"))
qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
n <- 9
kewl<-col_vector[60:(n+60)]
################################
df$Connectivity = df$Connections/(df$Taxa*df$Genes)
df2 <- subset(df, Level =="s__")

#diversity metric taken from plotting_taxa_taxa_jaccard.R
#infile = '/workdir/users/agk85/CDC2/bins/arg_das_5_taxa_taxa_counts.txt'
#contacts = 5
###########
#import data
###########

metaphlan<- read.table("/workdir/users/agk85/CDC2/metaphlan/cdc/mgm/CDC_mgm_metaphlan.txt",stringsAsFactors = FALSE,header=F,sep="\t")
header = metaphlan[1,]
colnames(metaphlan)<-as.character(unlist(header))
metaphlan <- metaphlan[-1,]
taxnames = c("Kingdom","Phylum","Class","Order","Family","Genus","Species")
levs = c(2,3,4,5,6,7)
l = 7
taxalev=taxnames[l]
levels <-as.vector(sapply(strsplit(as.character(metaphlan$ID),"\\|"), function(x) length(x)))
metaphlan$levels <- levels
metaphlan_sub <- subset(metaphlan, levels == l)

#this gets a single name from the ID
taxa <-sapply(strsplit(as.character(metaphlan_sub$ID),"__"), `[`, length(strsplit(as.character(metaphlan_sub$ID),"__")[[l+1]]))
rownames(metaphlan_sub)<-taxa

metaphlan_sub$levels <-NULL

metaphlan_sub$ID <-NULL
Patient<-sapply(strsplit(colnames(metaphlan_sub),"\\."), function(x) x[1])

patients <- factor(Patient)
pat <- data.frame(patients)

dft <- t(metaphlan_sub)
#one.5 convert less than 1% to 0
# dft[dft<1]<-0
#aggregate
dflev <- matrix(as.numeric(unlist(dft)),nrow=nrow(dft))
colnames(dflev) <- colnames(dft)
rownames(dflev) <- rownames(dft)
#dflev$pat <- factor(Patient)


df5.dist <- vegdist(dflev, method="bray")
df5.dist.mat <- as.matrix(df5.dist)
df5.dist.melt <- melt(df5.dist.mat)
colnames(df5.dist.melt)<-c("Sample1","Sample2","Species_Dissimilarity_Bray")
#merge with the connectivity

div_con <- merge(df2, df5.dist.melt, by=c("Sample1","Sample2"), all.x=T)

pdf(paste("Sample_pairwise_diversity_vs_connectivity_",genetype,"_",minreads,".pdf",sep=""),height=5,width=8,useDingbats=FALSE)
ggplot(div_con,aes(x=Species_Dissimilarity_Bray,y=Connectivity))+
ylab("Connectivity (Connections/(Shared species*Shared taxa))")+
xlab("Diversity (Species Bray-Curtis Dissimilarity")+
geom_point(aes(color=Comparison))
dev.off()
