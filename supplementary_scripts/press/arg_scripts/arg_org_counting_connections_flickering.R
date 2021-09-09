#arg_org_counting_connections_vs_not.R
library(ggplot2)
library(gplots)
library(vegan)
library(reshape2)
library(RColorBrewer)
library(plyr)
library(gridExtra)
theme_nogrid <- function (base_size = 12, base_family = "") {
  theme_bw(base_size = base_size, base_family = base_family) %+replace% 
    theme(
      panel.grid = element_blank()
    )   
}
theme_set(theme_nogrid())

#testing
folder = 'press'
folder2= 'nocorecorenomobilemobile'
argpid = '99'
hicpid = '99'

args <- commandArgs(trailingOnly = TRUE)
folder = args[1]
folder2 = args[2]
argpid = args[3]
hicpid = args[4]


setwd(paste("/workdir/users/agk85/", folder, "/arg_v_org/metagenomes/flickering", sep=""))
indata = read.csv(paste("arg_org_hic_separated_", argpid,"_", hicpid, "_1_2.tbl",sep=""), header=T, sep="\t",row.names=1)
#indata = read.csv("arg_org_hic_separated_95_98_0_2.tbl", header=T, sep="\t",row.names=1)

sub2<-indata
orgdf = sub2[,grep("_org",colnames(sub2))]
argdf = sub2[,grep("_arg",colnames(sub2))]
connectdf = sub2[,grep("_connect",colnames(sub2))]
colordf = sub2[,grep("color",colnames(sub2))]

cd<-colordf[colordf>3]

test <-head(colordf)
#this worked ont he cluster but not on my computer idk-why

colnames(colordf)
patients <-as.vector(sapply(strsplit(colnames(colordf),"color"), function(x) x[[1]]))
pats<- unique(patients)
colordf$Cluster<-sub2$Cluster
colordf$Organism<-sub2$Organism
colordf$ARG_name<-sub2$ARG_name

starts <- c(1,5,12,17,21,24,30)
stops <- c(4, 11, 16,20,23,29,32)
starts<- c(1,2)
stops <-c(2,3)
avg_metric<-list()
pass_metric<-list()
all_metric<-list()
for (i in seq(length(pats))){
	patient<- pats[i]
	print(patient)
	start <-starts[i]
	stop <- stops[i]
	poi<- colordf[,start:stop]
fours <-rowSums(as.matrix((poi > 3) + 0))
threes <- rowSums(as.matrix((poi  > 2) + 0))-fours
poi$fours <-fours
poi$threes<-threes
poi$Cluster <- colordf$Cluster
poi$ARG_name <- colordf$ARG_name
poi$Organism <- colordf$Organism
poiconnect <- subset(poi, poi$fours>0)
poiconnect$proportion <- poiconnect$fours /(poiconnect$fours + poiconnect$threes)
#get which ones are 1 and which are less than one (can't be more than .99 because only max 7 timepoints)
poiconnect$passfail<-(poiconnect$proportion>.99) + 0
print(mean(poiconnect$proportion))
print(sum(poiconnect$passfail==1)/length(poiconnect$passfail))
print(sum(poiconnect$fours)/(sum(poiconnect$fours)+sum(poiconnect$threes)))
write.csv(poiconnect, paste(patient, "_poiconnect.csv",sep=""))
avg_metric[[i]]<-mean(poiconnect$proportion)
pass_metric[[i]]<-sum(poiconnect$passfail==1)/length(poiconnect$passfail)
all_metric[[i]]<-sum(poiconnect$fours)/(sum(poiconnect$fours)+sum(poiconnect$threes))
}

#####
d<- data.frame(pats, unlist(avg_metric), unlist(pass_metric),unlist(all_metric))
colnames(d)<-c("Patients","Average","Pass","Alltogether")

pdf("Flickering_argorg_patient_passing_base.pdf")
ggplot(data=d,aes(Patients,Pass))+
	geom_bar(stat="identity")+
	ylim(0,1)
dev.off()

pdf("Flickering_argorg_patient_alltogether_base.pdf")
ggplot(data=d,aes(Patients,Alltogether))+
	geom_bar(stat="identity")+
	ylim(0,1)
dev.off()

pdf("Flickering_argorg_patient_average_base.pdf")
ggplot(data=d,aes(Patients,Average))+
	geom_bar(stat="identity")+
	ylim(0,1)
dev.off()

