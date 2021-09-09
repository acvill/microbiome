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

#inhandle='B314_das_5_argtaxa.txt'
#inhandle2='B314_network_5_argtaxa.txt' 



infile_1 = read.csv(inhandle,header=T, sep="\t",row.names=1)
infile_2 = read.csv(inhandle2, header=T,sep="\t",row.names=1)



infile_1$Binner=rep("DAS",nrow(infile_1))
infile_2$Binner=rep("Network",nrow(infile_2))

#I don't want ot see resident for network
infile1 = subset(infile_1, Thresh=="contacts")
infile2 = subset(infile_2, Thresh=="contacts" & Residency=="hic")

infile = rbind(infile1, infile2)

sample = infile_1$Patient[1]
min_contact = infile_1$Min_contacts[1]

#remap the bintypes
infile$Bintype = factor(infile$Bintype, levels=c("quality","anybin","bin+contig"), labels=c("Quality-bin","Any-bin","Bin or Contig")) 

infile$Residency = factor(infile$Residency, levels=c("resident","hic"), labels=c("Resident","Resident or Hi-C"))

f = subset(infile, Level == "f__")
g = subset(infile, Level == "g__")
s = subset(infile, Level == "s__")

delimname = 'g__'
lev = 'genus'
df = g
plot1<-ggplot(data=df, aes(TaxaCount)) +
geom_histogram(binwidth = 1, size=2)+
labs(title=paste(sample))+
xlab(paste("Number of ", lev)) +
ylab("ARG contig Taxa Counts")+
facet_grid(Bintype~Binner+Thresh+Residency,scales = "free_y")

delimname = 's__'
lev = 'species'
df = s
plot2<-ggplot(data=df, aes(TaxaCount)) +
geom_histogram(binwidth = 1, size=2)+
labs(title=paste(sample))+
xlab(paste("Number of ", lev)) +
ylab("ARG contig Taxa Counts")+
facet_grid(Bintype~Binner+Thresh+Residency,scales = "free_y")
#geom_text(size=5,data=dat_text,mapping=aes(x=Inf,y=Inf,label=label),hjust=1.05,vjust=1.5)


pdf(paste("ARG_ORG_histogram_genus_", min_contact, "_", sample,".pdf",sep=""), height = 10, width =15)
grid.arrange(plot1,ncol=1, nrow=1, widths=c(1), heights=c(1))
dev.off()

pdf(paste("ARG_ORG_histogram_species_", min_contact, "_",sample,".pdf",sep=""), height = 10, width =15)
grid.arrange(plot2, ncol=1, nrow=1, widths=c(1), heights=c(1))
dev.off()

infile$Counter <- rep(1,nrow(infile))
infile$Taxaset <- NULL
agg <-aggregate(Counter ~ Patient+Thresh+Bintype+Residency+Level+Binner, infile, sum)
agg$Min_contact <- rep(min_contact, nrow(agg))
agg$Total_args <- rep(df$Total_args[1],nrow(agg))
print(agg)
write.table(agg, paste("Numbers_",min_contact, "_",sample,".txt",sep=""), row.names=F,quote=FALSE,sep="\t")


agg <-aggregate(Counter ~ Patient+Thresh+Bintype+Residency+Level+Binner+factor(TaxaCount), infile, sum)
agg$Min_contact <- rep(min_contact, nrow(agg))
agg$Total_args <- rep(df$Total_args[1],nrow(agg))
print(agg)
write.table(agg, paste("Taxa_Count_Numbers_",min_contact, "_",sample,".txt",sep=""),row.names=F, quote=FALSE,sep="\t")

agg_sum <-aggregate(TaxaCount ~ Patient+Thresh+Bintype+Residency+Level+Binner, infile, sum)
agg_sum$metric <- rep("sum",nrow(agg_sum))
agg_mean <-aggregate(TaxaCount ~ Patient+Thresh+Bintype+Residency+Level+Binner, infile, mean)
agg_mean$metric <- rep("mean",nrow(agg_mean))
agg_median<-aggregate(TaxaCount ~ Patient+Thresh+Bintype+Residency+Level+Binner, infile, median)
agg_median$metric <- rep("median",nrow(agg_median))
agg <- rbind(agg_sum,agg_mean, agg_median)
write.table(agg, paste("Metrics_",min_contact, "_",sample,".txt",sep=""), row.names=F,quote=FALSE,sep="\t")

