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
infile = paste(genetype, "_", minreads,"_pairwise_connection_counts.txt",sep="")
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
df$Patient = sapply(strsplit(df$Sample,"-") function(x) x[1])
df2 <- subset(df, Level =="s__")
df2$Connections = paste(df2$Taxa1, df2$Taxa2)


#diversity metric taken from plotting_taxa_taxa_jaccard.R
#infile = '/workdir/users/agk85/CDC2/bins/arg_das_5_taxa_taxa_counts.txt'
#contacts = 5
###########
#import data
###########
infile = paste(genetype, "_das_", minreads, "_taxa_taxa_sample_counts.txt",sep="")
df <-read.table(infile,header=T, row.names=1,sep="\t")
# reduce number of counts by 2 because of the doubling
df$Genes <- df$Genecount/2














pdf("Pairwise_diversity_vs_connectivity.pdf",height=10,width=10,useDingbats=FALSE)
ggplot(df2,aes(x=Taxa,y=Connectivity))+
geom_point(aes(color=patient))
dev.off()
