#this program will plot the histograms for one sample
library(ggplot2)
library(gridExtra)

theme_nogrid <- function (base_size = 12, base_family = "") {
  theme_bw(base_size = base_size, base_family = base_family) %+replace%
    theme(
      panel.grid = element_blank()
    )
}
theme_set(theme_nogrid())
setwd("/workdir/users/agk85/CDC2/bins")

args <- commandArgs(trailingOnly = TRUE)
inhandle=args[1]
inhandle2=args[2]


#infile = read.csv("/workdir/users/agk85/CDC2/bins/B370-3_contig_taxa_network_2_fgs",header=T, sep="\t",row.names=1)

infile = read.csv(inhandle,header=T, sep="\t",row.names=1)
infile2 = read.csv(inhandle2, header=T,sep="\t",row.names=1)

sample = infile$Sample[1]

infile$Bintypes = factor(infile$Bintype, levels=c("quality","anybin","bin+contig"), labels=c("Quality-bin","Any-bin","Bin or Contig")) 

f = subset(infile, Level == "f__")
g = subset(infile, Level == "g__")
s = subset(infile, Level == "s__")

delimname = 'f__'
df = f

a<-ggplot(data=df, aes(TaxaCount)) +
geom_histogram(binwidth = 1, size=2)+
labs(title=paste("Network_", sample))+
xlab(paste("Number of ", delimname)) +
ylab("ARG contig Taxa Counts")+
facet_grid(Bintype~Thresh)


delimname = 'g__'
df = g
b<-ggplot(data=df, aes(TaxaCount)) +
geom_histogram(binwidth = 1, size=2)+
labs(title=paste("Network_", sample))+
xlab(paste("Number of ", delimname)) +
ylab("ARG contig Taxa Counts")+
facet_grid(Bintype~Thresh)

delimname = 's__'
df = s
c<-ggplot(data=df, aes(TaxaCount)) +
geom_histogram(binwidth = 1, size=2)+
labs(title=paste("Network_", sample))+
xlab(paste("Number of ", delimname)) +
ylab("ARG contig Taxa Counts")+
facet_grid(Bintype~Thresh)


#das 
infile2$Bintypes = factor(infile2$Bintype, levels=c("quality","anybin","bin+contig"), labels=c("Quality-bin","Any-bin","Bin or Contig")) 

f = subset(infile2, Level == "f__")
g = subset(infile2, Level == "g__")
s = subset(infile2, Level == "s__")

delimname = 'f__'
df = f

d<-ggplot(data=df, aes(TaxaCount)) +
geom_histogram(binwidth = 1, size=2)+
labs(title=paste("DAS_", sample))+
xlab(paste("Number of ", delimname)) +
ylab("ARG contig Taxa Counts")+
facet_grid(Bintype~Thresh)


delimname = 'g__'
df = g
e<-ggplot(data=df, aes(TaxaCount)) +
geom_histogram(binwidth = 1, size=2)+
labs(title=paste("DAS_", sample))+
xlab(paste("Number of ", delimname)) +
ylab("ARG contig Taxa Counts")+
facet_grid(Bintype~Thresh)

delimname = 's__'
df = s
f<-ggplot(data=df, aes(TaxaCount)) +
geom_histogram(binwidth = 1, size=2)+
labs(title=paste("DAS_", sample))+
xlab(paste("Number of ", delimname)) +
ylab("ARG contig Taxa Counts")+
facet_grid(Bintype~Thresh)


pdf(paste("ARG_ORG_histogram_no0_",sample,".pdf",sep=""), height = 20, width =25)
grid.arrange(a,b,c,d,e,f,
        ncol=3, nrow=2, widths=c(1,1,1), heights=c(1,1))
dev.off()









