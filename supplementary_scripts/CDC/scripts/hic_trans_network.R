#Hi-C trans interactions mapped in igraph
#
library(igraph)
library(qgraph)
library(ggplot2)
setwd('/workdir/users/agk85/gates/hic/plotting/')
workdir='/workdir/users/agk85/gates'

df <- data.frame(Name=character(),
	Type=character(),
	Group=character(),
	Percents=numeric(),
	MGE_counts=numeric(),
	MGE_totals=numeric(),
	Cutoff=numeric()) 

argorgdf <- data.frame(Name=character(),
	v1 = character(),
	v2 = character(),
	weight = numeric())

names = read.table(paste(workdir,'/MetaDesign_all.txt',sep=""), header=F)
names = as.character(names$V1)
remove <- c ("US1","US4")
names <- names[!names %in% remove]
for (name in names){
#trans interactions from hic data
data <- read.table(paste(workdir, "/hic/mapping/", name,"/",name, "_trans_primary.txt",sep=""), sep="\t")
colnames(data)<-c("ID1","Flag1","Contig1","Start1","Mapq1","CIGAR1","ID2","Flag2","Contig2","Start2","Mapq2","CIGAR2")

annotations <- read.table(paste(workdir, "/combo_tables/metagenomes/", name,"_master_scf_table_binary.txt",sep=""),sep="\t",header=T,row.names=1)

amph <- read.table(paste(workdir, "/combo_tables/metagenomes/", name,"_master_scf_table.txt",sep=""),quote = "", sep="\t",header=T,row.names=1)

plasmids <- annotations$Plasmid_Finder + annotations$Full_Plasmids + annotations$Relaxase + annotations$Aclame_plasmid
args <- annotations$Resfams + annotations$Perfect + annotations$CARD
is <- annotations$ISEScan
phage <- annotations$Phage_Finder + annotations$Prophet + annotations$Phaster + annotations$VOGS
org <- annotations$Amphora
#TODO make sure this little bit works....do I have to do something??
orgname<-amph$Amphora.best_taxonomy.confidence..
argname<-paste(amph$Resfams, amph$Perfect, amph$CARD, sep="")
annot<- data.frame(plasmids, args, is, phage, org,orgname,argname )
rownames(annot)<-rownames(annotations)

#testing purposes a subset of the interactions
data_s <- data
#get the links c1 is first contig and c2 is second contig
a <- data.frame(as.character(data_s$Contig1),as.character(data_s$Contig2))
g<-graph_from_data_frame(a, directed=FALSE)

#get the plasmids to match the vertex names
#b<- merge(as.data.frame(V(g)$name), plasmids,by.x="V(g)$name",by.y=1,all.x=T)
#V(g)$plasmid<-!is.na(b[,5])*1

#give it weights for the edges
E(g)$weight<-1

#simplify by collapsing multiple edges and summing them
g_simp <- simplify( g, remove.multiple=T, edge.attr.comb=c(weight="sum") )

#normalize the width to the biggest width (so you don't have whoppers)
E(g_simp)$width <- E(g_simp)$weight   #E(g_simp)$weight/(max(E(g_simp)$weight)/30)

#set a layout 
#l <- layout_with_kk(g_simp)
#plot(g_simp,vertex.label=NA,vertex.size=5,vertex.color=c( "white", "red")[1+(V(g_simp)$plasmid==1)] )

#l <- layout_with_kk(g_simp)
#plot(g_simp, layout=l, vertex.label=NA, vertex.size=5)
hist(E(g_simp)$weight,breaks=35)
mean(E(g_simp)$weight)

#cut.off <- 3
#g_one <- delete_edges(g_simp, E(g_simp)[weight<cut.off])
#g_one_v=delete.vertices(g_one,which(degree(g_one)<1))
#g_plasmids = delete.vertices(g_one, which(g_one))

#merge with whatever cutoff you have
#b<- merge(as.data.frame(V(g_one_v)$name), annot,by.x="V(g_one_v)$name",by.y=1,all.x=T)


##############
cutoffs=c(1,2,3,4,5)

for (cut.off in cutoffs){
g_one <- delete_edges(g_simp, E(g_simp)[weight<cut.off])
V(g_one)$deg <- degree(g_one, mode="all")                                              
g_one=delete.vertices(g_one,which(degree(g_one)<1))                              

#make sure sort is False because when  you just tack it on the vertex attributes it has tobe the same order
b<- merge(as.data.frame(V(g_one)$name), annot,by.x="V(g_one)$name",by.y=0,all.x=T,sort=F)
dim(b)
dim(data)

rownames(b)<-b$`V(g_one)$name`
b$`V(g_one)$name` <- NULL
b_orgname <- b$orgname
b$orgname <- NULL

b_argname <- b$argname
b$argname <- NULL

b$sums <- rowSums(b)
V(g_one)$plasmid<-b$plasmids
V(g_one)$phage<-b$phage
V(g_one)$arg<-b$args
V(g_one)$is<-b$is
V(g_one)$org<-b$org
V(g_one)$deg <- degree(g_one, mode="all")
V(g_one)$sums <- rowSums(b)
V(g_one)$orgname <- as.character(b_orgname)
V(g_one)$argname <- as.character(b_argname)
g_one_annot=delete_vertices(g_one,which(V(g_one)$sums<1))
V(g_one_annot)$deg <- degree(g_one_annot, mode="all")
g_one_annot=delete.vertices(g_one_annot,which(degree(g_one_annot)<1))

#df <- as.data.frame(V(g_one_annot)$name)
#c<- merge(df, b,by.x="V(g_one_annot)$name",by.y="row.names",all.x=T)
#rownames(c)<-c$`V(g_one_annot)$name`
#c$`V(g_one_annot)$name` <- NULL
#########################################################################################

#get the percentage captured 
mge_percents = rep(0,12)
mge_captured = rep(0,12)
mge_total = rep(0,12)
#percent mgm mge's captured in trans interactions 
mge_percents[1]<-100*sum(V(g_one)$plasmid>0)/sum(plasmids>0)
mge_percents[2]<-100*sum(V(g_one)$phage>0)/sum(phage>0)
mge_percents[3]<-100*sum(V(g_one)$is>0)/sum(is>0)
mge_percents[4]<-100*sum(V(g_one)$arg>0)/sum(args>0)
mge_percents[5]<-100*sum(V(g_one)$org>0)/sum(org>0)
mge_percents[6]<-100*vcount(g_one)/length(annotations$Plasmid_Finder)
mge_captured[1]<-sum(V(g_one)$plasmid>0)
mge_captured[2]<-sum(V(g_one)$phage>0)
mge_captured[3]<-sum(V(g_one)$is>0)
mge_captured[4]<-sum(V(g_one)$arg>0)
mge_captured[5]<-sum(V(g_one)$org>0)
mge_captured[6]<-vcount(g_one)
mge_total[1]<-sum(plasmids>0)
mge_total[2]<-sum(phage>0)
mge_total[3]<-sum(is>0)
mge_total[4]<-sum(args>0)
mge_total[5]<-sum(org>0)
mge_total[6]<-length(annotations$Plasmid_Finder)
#percent mgm mge's captured in trans interactions connected to 
mge_percents[7]<-100*sum(V(g_one_annot)$plasmid>0)/sum(plasmids>0)
mge_percents[8]<-100*sum(V(g_one_annot)$phage>0)/sum(phage>0)
mge_percents[9]<-100*sum(V(g_one_annot)$is>0)/sum(is>0)
mge_percents[10]<-100*sum(V(g_one_annot)$arg>0)/sum(args>0)
mge_percents[11]<-100*sum(V(g_one_annot)$org>0)/sum(org>0)
mge_percents[12]<-100*vcount(g_one_annot)/length(annotations$Plasmid_Finder)
mge_captured[7]<-sum(V(g_one_annot)$plasmid>0)
mge_captured[8]<-sum(V(g_one_annot)$phage>0)
mge_captured[9]<-sum(V(g_one_annot)$is>0)
mge_captured[10]<-sum(V(g_one_annot)$arg>0)
mge_captured[11]<-sum(V(g_one_annot)$org>0)
mge_captured[12]<-vcount(g_one_annot)
mge_total[7]<-sum(plasmids>0)
mge_total[8]<-sum(phage>0)
mge_total[9]<-sum(is>0)
mge_total[10]<-sum(args>0)
mge_total[11]<-sum(org>0)
mge_total[12]<-length(annotations$Plasmid_Finder)

sampleids <- rep(name,12)
cfs <- rep(cut.off, 12)
type <- c("plasmid","phage","is","arg","org","trans","plasmid","phage","is","arg","org","trans")
grp <-c(rep("Captured.by.trans.interactions",6),rep("Both.annotated",6))
newdf<-data.frame(sampleids, type, grp,mge_percents,mge_captured,mge_total, cfs)
df <- rbind(df,newdf)
}
}

write.csv(df, "Gates_percent_capture.csv")

pdf("Percent_capture_trans.pdf",height=5, width=6)
df <- read.csv("Gates_percent_capture.csv",row.names=1)
df2<- subset(df, grp=="Captured.by.trans.interactions" & cutoffs==1 & type !='trans')
df2$study<- as.factor(substr(df2$sampleids, 0,1))
ggplot(df2)+
	geom_bar(aes(fill=sampleids,factor(type), mge_percents), position='dodge', stat='identity')+
	#geom_point(aes(factor(type), mge_percents,col=study))+
	ylim(0,max(df2$mge_percents))+
	xlab(label=c("Annotation"))+ ylab(label=c("Percentage of total contigs"))+
	#scale_color_manual("Study", values = c("G" = "green", "U" = "blue"),labels = c("Fiji","US"))+
	scale_x_discrete(labels=c("arg" = "ARG", "is" = "IS\nElement","org" = "Organism","phage"="Phage","plasmid"="Plasmid"))
	#facet_grid(grp~.)
dev.off()
