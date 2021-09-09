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
infile = paste(genetype, "_", minreads,"_connection_counts.txt",sep="")
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
df$Patient = sapply(strsplit(as.character(df$Sample),"-"), function(x) x[1])
df2 <- subset(df, Level =="s__")



outhandle = paste("Diversity_vs_connectivity_",genetype,"_",minreads,".pdf",sep="")
pdf(outhandle,height=5,width=8,useDingbats=FALSE)
ggplot(df2,aes(x=Taxa,y=Connectivity))+
geom_point(color="black",shape = 21,size=3,aes(fill=Patient))+
scale_fill_manual(values=kewl)
dev.off()

readcounts = read.table("/workdir/users/agk85/CDC2/read_distributions/ReadCounts.txt",sep="\t",header=T)
dfrc <- merge(df2, readcounts, by="Sample")

pdf(
