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

infile_1 = read.csv(inhandle,header=T, sep="\t",row.names=1)
infile_2 = read.csv(inhandle2, header=T,sep="\t",row.names=1)



infile_1$Binner=rep("Network",nrow(infile_1))
infile_2$Binner=rep("DAS",nrow(infile_2))


infile1 = subset(infile_1, Thresh=="contacts" & Residency=="hic")
infile = rbind(infile_1, infile_2)
print(infile)
sample = infile_1$Patient[1]
min_contact = infile_1$Min_contacts[1]

infile1 = subset(infile_1, Thresh=="contacts" & Residency=="hic")
infile1$Bintypes = factor(infile1$Bintype, levels=c("quality","anybin","bin+contig"), labels=c("Quality-bin","Any-bin","Bin or Contig")) 

f = subset(infile1, Level == "f__")
g = subset(infile1, Level == "g__")
s = subset(infile1, Level == "s__")

delimname = 'g__'
lev = 'genus'
df = g
b<-ggplot(data=df, aes(TaxaCount)) +
geom_histogram(binwidth = 1, size=2)+
labs(title=paste("Network_", sample))+
xlab(paste("Number of ", lev)) +
ylab("ARG contig Taxa Counts")+
facet_grid(Bintype~Thresh)

delimname = 's__'
lev = 'species'
df = s
c<-ggplot(data=df, aes(TaxaCount)) +
geom_histogram(binwidth = 1, size=2)+
labs(title=paste("Network_", sample))+
xlab(paste("Number of ", lev)) +
ylab("ARG contig Taxa Counts")+
facet_grid(Bintype~Thresh)


#das 
infile2 = subset(infile_2, Thresh=="contacts")
infile2$Bintypes = factor(infile2$Bintype, levels=c("quality","anybin","bin+contig"), labels=c("Quality-bin","Any-bin","Bin or Contig")) 

f = subset(infile2, Level == "f__")
g = subset(infile2, Level == "g__")
s = subset(infile2, Level == "s__")

delimname = 'g__'
lev = 'genus'
df = g
e<-ggplot(data=df, aes(TaxaCount)) +
geom_histogram(binwidth = 1, size=2)+
labs(title=paste("DAS_", sample))+
xlab(paste("Number of ", lev)) +
ylab("ARG contig Taxa Counts")+
facet_grid(Bintype~Thresh+Residency)

delimname = 's__'
lev = 'species'
df = s
f<-ggplot(data=df, aes(TaxaCount)) +
geom_histogram(binwidth = 1, size=2)+
labs(title=paste("DAS_", sample))+
xlab(paste("Number of ", lev)) +
ylab("ARG contig Taxa Counts")+
facet_grid(Bintype~Thresh+Residency)


pdf(paste("ARG_ORG_histogram_no0_genus_", min_contact, "_", sample,".pdf",sep=""), height = 10, width =15)
grid.arrange(b,e,
        ncol=2, nrow=1, widths=c(1,2), heights=c(1))
dev.off()

pdf(paste("ARG_ORG_histogram_no0_species_", min_contact, "_",sample,".pdf",sep=""), height = 10, width =15)
grid.arrange(c,f,
        ncol=2, nrow=1, widths=c(1,2), heights=c(1))
dev.off()








