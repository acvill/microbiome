#plot histograms for arg org and org arg relationships
#updated to only include things that have taxonomy down to species to be counted
library(ggplot2)
library(gplots)
library(vegan)
library(reshape2)
library(RColorBrewer)
library(plyr)
library(scales)
theme_nogrid <- function (base_size = 12, base_family = "") {
  theme_bw(base_size = base_size, base_family = base_family) %+replace% 
    theme(
      panel.grid = element_blank()
    )   
}
theme_set(theme_nogrid())
setwd("/workdir/users/agk85/press2/maxbin")

header = c("Bin","Taxa","Completeness","Contamination","Hetero","Size")

infile = read.csv("ProxiMeta-1_maxbin.stats", sep="\t",header=F)
colnames(infile)<-header
infile$Binner = rep("Maxbin",length(infile$Bin))

infile1 = read.csv("ProxiMeta-1_concoct.stats", sep="\t", header =F)
colnames(infile1)<-header
infile1$Binner = rep("Concoct", length(infile1$Bin))

infile2 = read.csv("ProxiMeta-1_metabat.stats", sep="\t",header=F)
colnames(infile2)<-header
infile2$Binner = rep("Metabat",length(infile2$Bin))

infile3= read.csv("ProxiMeta-1_das.stats", sep="\t", header=F)
colnames(infile3) <-header
infile3$Binner = rep("DAS",length(infile3$Bin))


infiles = rbind(infile, infile1, infile2, infile3)
dim(infiles)

df <- subset(infiles, Size>100000)
dim(df)

pdf("Genome_bin_sizes_ProxiMeta.pdf")
ggplot(df, aes(Binner, Size))+
geom_boxplot(outlier.colour=NA)+
geom_point(position=position_jitter(width=.2))+
scale_y_log10(labels = comma)
dev.off()


pdf("Genome_bin_contamination_ProxiMeta.pdf")
ggplot(df, aes(Binner, Contamination))+
geom_boxplot(outlier.colour=NA)+
geom_point(position=position_jitter(width=.2))+
scale_y_continuous(labels = comma)
dev.off()

pdf("Genome_bin_contamination_0_200_ProxiMeta.pdf")
ggplot(df, aes(Binner, Contamination))+
geom_boxplot(outlier.colour=NA)+
geom_point(position=position_jitter(width=.2))+
scale_y_continuous(labels = comma,limits=c(0,200))
dev.off()


pdf("Genome_bin_completeness_ProxiMeta.pdf")
ggplot(df, aes(Binner, Completeness))+
geom_violin()+
geom_point(position=position_jitter(width=.1))+
scale_y_continuous(labels = comma)
dev.off()

library(psych)
a = describeBy(df, "Binner")

hq <- subset(df, Contamination<5 & Completeness>90)
mq <- subset(df, Contamination<10 & Completeness>=50)
lq <- subset(df, Contamination<10 & Completeness<50)
bad<-subset(df, Contamination>=10)

b = describeBy(hq, "Binner")
c = describeBy(mq, "Binner")
d = describeBy(lq, "Binner")
e = describeBy(bad, "Binner")


hqstats = rbind(b$DAS, b$Maxbin, b$Metabat, b$Concoct)
mqstats = rbind(c$DAS, c$Maxbin, c$Metabat, c$Concoct)
lqstats = rbind(d$DAS, d$Maxbin, d$Metabat, d$Concoct)

write.csv(hqstats, "HQ_bins_stats_ProxiMeta.txt")
write.csv(mqstats, "MQ_bins_stats_ProxiMeta.txt")
write.csv(lqstats, "LQ_bins_stats_ProxiMeta.txt")
