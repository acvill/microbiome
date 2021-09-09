#plot histograms for arg org and org arg relationships
#updated to only include things that have taxonomy down to species to be counted
library(ggplot2)
library(gplots)
library(vegan)
library(reshape2)
library(RColorBrewer)
library(plyr)
library(scales)
library(gridExtra)
theme_nogrid <- function (base_size = 12, base_family = "") {
  theme_bw(base_size = base_size, base_family = base_family) %+replace% 
    theme(
      panel.grid = element_blank()
    )   
}
theme_set(theme_nogrid())
setwd("/workdir/users/agk85/press2/das")

header = c("Bin","Taxa","Completeness","Contamination","Hetero","Size")

infile3= read.csv("das_checkm_stats.txt", sep="\t", header=F)
colnames(infile3) <-header
#infile3$partial = as.vector(sapply(strsplit(as.character(infile3$Bin), "_"),function(x) x[[1]]))
#infile3$Sample = as.vector(sapply(strsplit(as.character(infile3$partial), "[.]"),function(x) x[[1]]))
#infile3$partial <- NULL
infile3$Binner = rep("DAS",length(infile3$Bin))

infile4= read.csv("das_non_mobile_checkm_stats.txt", sep="\t", header=F)
colnames(infile4) <-header
infile4$Binner = rep("DAS_non_mobile",length(infile4$Bin))


infiles = merge(infile3,infile4,by="Bin")
infiles = rbind(infile3, infile4)
dim(infiles)

#df <- subset(infiles, Size.x>100000)
dim(df)
dfmelt <- melt(infiles)
#all in one?
df <- data.frame(group, session, value, index, U = interaction(session, group))
p <- ggplot(df, aes(x = U, y = value, fill = session)) + 
  scale_x_discrete(labels = rep(unique(group), each = 2))
p <- p + geom_line(aes(group = index), alpha = 0.6, colour = "black", data = df) 
                                                             # no need for dodge


infiles = merge(infile3,infile4,by="Bin")
infiles$Completeness_change <- infiles$Completeness.y/infiles$Completeness.x
infiles$Contamination_change <- infiles$Contamination.y/infiles$Contamination.x
infiles$Sqize_change <- infiles$Size.y/infiles$Size.x

a <- ggplot(infiles, aes(x=Binner.x, y=Completeness_change))+
	geom_boxplot(outlier.shape=NA)+
	geom_point(position=position_jitter(.25))
b <- ggplot(infiles, aes(x=Binner.x, y=Contamination_change))+
        geom_boxplot(outlier.shape=NA)+
        geom_point(position=position_jitter(.25))
c <- ggplot(infiles, aes(x=Binner.x, y=Size_change))+
        geom_boxplot(outlier.shape=NA)+
        geom_point(position=position_jitter(.25))
pdf("ProxiMeta_non_mobile_checkm.pdf")
grid.arrange(a,b,c, ncol=3,nrow=1, widths=c(2,2,2),heights=c(4))

dev.off()

pdf("Genome_bin_sizes_mobile_nomobile.pdf")
ggplot(df, aes(Binner, ))+
geom_boxplot(outlier.colour=NA)+
geom_point(position=position_jitter(width=.2))+
scale_y_log10(labels = comma)
dev.off()


pdf("Genome_bin_contamination5.pdf")
ggplot(df, aes(Binner, Contamination))+
geom_boxplot(outlier.colour=NA)+
geom_point(position=position_jitter(width=.2))+
scale_y_continuous(labels = comma)
dev.off()

pdf("Genome_bin_contamination4_0_200.pdf")
ggplot(df, aes(Binner, Contamination))+
geom_boxplot(outlier.colour=NA)+
geom_point(position=position_jitter(width=.2))+
scale_y_continuous(labels = comma,limits=c(0,200))
dev.off()


pdf("Genome_bin_completeness4.pdf")
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


hqstats = rbind(b$DAS_with_Concoct, b$DAS, b$Maxbin, b$Metabat, b$Concoct)
mqstats = rbind(c$DAS_with_Concoct, c$DAS, c$Maxbin, c$Metabat, c$Concoct)
lqstats = rbind(d$DAS_with_Concoct, d$DAS, d$Maxbin, d$Metabat, d$Concoct)

write.csv(hqstats, "HQ_bins_stats.txt")
write.csv(mqstats, "MQ_bins_stats.txt")
write.csv(lqstats, "LQ_bins_stats.txt")
