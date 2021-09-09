
library(ggplot2)
library(gplots)
library(vegan)
library(reshape2)
library(RColorBrewer)
library(plyr)
library(gridExtra)
library("devtools")
set.seed(42)
theme_nogrid <- function (base_size = 12, base_family = "") {
  theme_bw(base_size = base_size, base_family = base_family) %+replace% 
    theme(
      panel.grid = element_blank()
    )   
}
theme_set(theme_nogrid())

infile1 = 'test1'
infile2 = 'test2'
name = 'MluCI'



args <- commandArgs(trailingOnly = TRUE)
infile1=args[1] #normal cluster
infile2=args[2] #trans cluster
name=args[3] #name of sample

#load in hic das cluster matrix
df1 = read.csv(infile1, header=T, row.names=1, sep="\t")

df1.mat = as.matrix(df1)
df1.dist= dist((df1.mat))
#Load latest version of heatmap.3 function

my_palette <- colorRampPalette(c("white", "red"))(n = 1000)


pdf(paste("Heatmap_das_clusters_hic_", name, ".pdf",sep=""), height=60, width=60,useDingbats=FALSE)
heatmap.2(log10(df1.mat+1), na.rm = TRUE, scale="none",col=my_palette,
        dendrogram="both",Rowv=T,Colv=T,key=T,symbreaks=FALSE, margins=c(30,30),
        symkey=F, density.info="none", trace="none", cexCol=.8,
        cexRow=.4)
dev.off()


df2 = read.csv(infile2, header=T, row.names=1, sep="\t")
df2.mat = as.matrix(df2)
pdf(paste("Heatmap_das_clusters_transhic_", name, ".pdf",sep=""), height=60, width=60,useDingbats=FALSE)
heatmap.2(log10(df2.mat+1), na.rm = TRUE, scale="none",col=my_palette,
        dendrogram="both",Rowv=T,Colv=T,key=T,symbreaks=FALSE, margins=c(30,30),
        symkey=F, density.info="none", trace="none", cexCol=.8,
        cexRow=.4)
dev.off()
##################NON_MOBILE######################
infile1 = 'test1_non_mobile'
infile2 = 'test2_non_mobile'
name = 'MluCI'



args <- commandArgs(trailingOnly = TRUE)
infile1=args[1] #normal cluster
infile2=args[2] #trans cluster
name=args[3] #name of sample

#load in hic das cluster matrix
df1 = read.csv(infile1, header=T, row.names=1, sep="\t")

df1.mat = as.matrix(df1)
df1.dist= dist((df1.mat))
#Load latest version of heatmap.3 function

my_palette <- colorRampPalette(c("white", "red"))(n = 1000)


pdf(paste("Heatmap_das_clusters_hic_non_mobile_", name, ".pdf",sep=""), height=60, width=60,useDingbats=FALSE)
heatmap.2(log10(df1.mat+1), na.rm = TRUE, scale="none",col=my_palette,
        dendrogram="both",Rowv=T,Colv=T,key=T,symbreaks=FALSE, margins=c(30,30),
        symkey=F, density.info="none", trace="none", cexCol=.8,
        cexRow=.4)
dev.off()


df2 = read.csv(infile2, header=T, row.names=1, sep="\t")
df2.mat = as.matrix(df2)
pdf(paste("Heatmap_das_clusters_transhic_non_mobile_", name, ".pdf",sep=""), height=60, width=60,useDingbats=FALSE)
heatmap.2(log10(df2.mat+1), na.rm = TRUE, scale="none",col=my_palette,
        dendrogram="both",Rowv=T,Colv=T,key=T,symbreaks=FALSE, margins=c(30,30),
        symkey=F, density.info="none", trace="none", cexCol=.8,
        cexRow=.4)
dev.off()
