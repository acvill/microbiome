
library(ggplot2)
library(RColorBrewer)
setwd('/workdir/users/agk85/gates/hic/plotting/')
workdir='/workdir/users/agk85/gates'

args <- commandArgs(trailingOnly = TRUE)

###ggplot theme no background
theme_nogrid <- function (base_size = 12, base_family = "") {
  theme_bw(base_size = base_size, base_family = base_family) %+replace%
    theme(
      panel.grid = element_blank()
    )
}
theme_set(theme_nogrid())

#load in data
identity=args[1]
df <- read.csv(paste("Gates_percent_capture_", identity,"id.csv",sep=""),row.names=1)
#what's your cutoff? number of links minimum---must have calculated this before---in hic_trans_interactions.R
cutoff=args[2]
df2<- subset(df, grp=="Captured.by.trans.interactions" & cfs==cutoff & type !='trans')
df2$study<- as.factor(substr(df2$sampleids, 0,1))

#colourCount <- length(unique(df2$sampleids))
#cramp<-colorRampPalette(colors=c("darkred","lightcoral","blue4","lightblue"))
#colstopickfrom= cramp(12)
#colstopickfrom
colorful_colors <- c("#8B0000","#A62222","#C24545","#DD6868","#DA7481","#150B8A","#1F279B","#4E62B4","#7D9DCD","#ADD8E6")
pdf(paste("Percent_capture_trans_", identity, "id_min_", cutoff, ".pdf",sep=""),height=5, width=7)
ggplot(df2,aes(fill=sampleids,factor(type), mge_percents))+
        geom_bar(position='dodge', stat='identity')+
        geom_text(position=position_dodge(width=.9),cex=2,aes(label=paste(mge_captured, '/',mge_total,sep="")), vjust=-0.25)+
        ylim(0,100)+         #max(df2$mge_percents))+
        xlab(label=c("Annotation"))+ 
        ylab(label=c("Percentage of total MGEs"))+
        scale_fill_manual("Individuals", values = colorful_colors)+
        scale_x_discrete(labels=c("arg" = "ARG", "is" = "IS\nElement","org" = "Organism","phage"="Phage","plasmid"="Plasmid"))
dev.off()

pdf(paste("Percent_capture_trans_boxplot_", identity, "id_min_", cutoff, ".pdf",sep=""),height=5, width=7)
ggplot(df2, aes(type, mge_percents))+
	geom_boxplot(aes(fill=study), position="dodge",outlier.shape = NA)+
	geom_point(aes(col=sampleids),position = position_jitterdodge(jitter.width = .01, dodge.width = .8))+
	ylim(0,100)+         #max(df2$mge_percents))+
	xlab(label=c("Contig Annotation"))+ 
	ylab(label=c("Percentage of total annotated contigs"))+
	scale_fill_manual("Country", labels=c("G"="Fiji", "U"="USA"),values = c("G"="darksalmon",U="slategray2"))+
	scale_colour_manual("Individuals", values = colorful_colors)+
	scale_x_discrete(labels=c("arg" = "ARG", "is" = "IS\nElement","org" = "Organism","phage"="Phage","plasmid"="Plasmid"))
dev.off()
