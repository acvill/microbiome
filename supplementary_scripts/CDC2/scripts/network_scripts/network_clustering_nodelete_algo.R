#Hi-C base networks
set.seed(472)
library(igraph)
library(qgraph)
library(ggplot2)
library(RColorBrewer)
start_time <- Sys.time() 
args <- commandArgs(trailingOnly = TRUE)
folder=args[1]
name=args[2]
name2 = args[3]
identity=args[4]
cut.off=args[5]
ref=args[6]
wrk=paste('/workdir/users/agk85/',folder,sep="")
workdir=paste('/workdir/users/agk85/',folder,'/networks/',sep="")
setwd(workdir)

print(folder)
print(name)
print(identity)
print(cut.off)
cutoff=as.numeric(cut.off)
infile<-paste(workdir, "/outputs/Stats_algorithm_", name2, "_", identity, "_", cut.off,".txt", sep="") 

#no euks version
#trans interactions from hic data
data <- read.table(paste(wrk, "/hicpro/output",name2, "_output/hic_results/data/",name2,"/",name2,"_","trans_primary_",identity,"_noeuks.txt",sep=""), sep="\t")
colnames(data)<-c("ID1","Flag1","Contig1","Start1","Mapq1","CIGAR1","ID2","Flag2","Contig2","Start2","Mapq2","CIGAR2")
annotations <- read.table(paste(wrk, "/combo_tables/metagenomes/", name,"_master_scf_table_binary.txt",sep=""),sep="\t",header=T,row.names=1)
amph <- read.table(paste(wrk, "/combo_tables/metagenomes/", name,"_master_scf_table.txt",sep=""),quote = "", sep="\t",header=T,row.names=1)
plasmids <- annotations$Plasmid_Finder + annotations$Full_Plasmids + annotations$Relaxase + annotations$Aclame_plasmid + annotations$Imme_plasmid + annotations$Plasmid_pfams + annotations$Mobile_pfams
args <- annotations$Resfams + annotations$Perfect + annotations$CARD
is <- annotations$ISEScan + annotations$Imme_transposon
phage <- annotations$Phage_Finder + annotations$Phaster + annotations$Imme_phage + annotations$Aclame_phage + annotations$Virus #+annotations$VOGS
org <- annotations$Amphora + annotations$Rnammer + annotations$Campbell + annotations$Metaphlan + annotations$GSMer# someday we will make this better

orgname<-amph$Amphora.best_taxonomy.confidence..
argname<-paste(amph$Resfams, amph$Perfect, amph$CARD, sep="")
bestorgname <-paste(amph$Best_org.amphora_rnammer.)
annot<- data.frame(plasmids, args, is, phage, org,orgname,argname,bestorgname )
rownames(annot)<-rownames(annotations)

mges <- data.frame(plasmids, is, phage)
rownames(mges)<-rownames(annotations)
#get the links c1 is first contig and c2 is second contig
a <- data.frame(as.character(data$Contig1),as.character(data$Contig2))
g<-graph_from_data_frame(a, directed=FALSE)
#give it weights for the edges
E(g)$weight<-1

#simplify by collapsing multiple edges and summing them
g_simp <- simplify( g, remove.multiple=T, edge.attr.comb=c(weight="sum") )

#normalize the width to the biggest width (so you don't have whoppers)
E(g_simp)$width <- E(g_simp)$weight   #E(g_simp)$weight/(max(E(g_simp)$weight)/30)

hist(E(g_simp)$weight,breaks=20000,xlim=c(0,100))
hist(degree(g_simp, V(g_simp)), breaks=400, xlim=c(0,max(degree(g_simp, V(g_simp)))))
hist(degree(g_simp, V(g_simp)), breaks=400, xlim=c(0,50))

#hist(E(g_simp)$weight,breaks=8000,xlim=c(0,50))
write(c(name2, "\t", identity, "\t", cut.off), file = infile, append=T)
write(paste('mean_weight:', mean(E(g_simp)$weight),sep=""), file = infile, append=T)
write(paste('median_weight:', median(E(g_simp)$weight),sep=""), file = infile, append=T)
write(paste('max_weight:', max(E(g_simp)$weight),sep=""), file = infile, append=T)
write(paste('vertices:', vcount(g_simp),sep=""), file = infile, append=T)
write(paste('edges:', ecount(g_simp),sep=""), file = infile, append=T)
##############
#cutoffs=c(1,2,5,10)
#for (cut.off in cutoffs){
g_one <- delete_edges(g_simp, E(g_simp)[weight<cutoff])
V(g_one)$deg <- degree(g_one, mode="all")                                              
g_one=delete.vertices(g_one,which(degree(g_one)<1))                              

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


#if bestorgname has s__; then turn it into '.' because we don't care about that sh**
b$bestorgname1 <- as.character(b$bestorgname)
b$bestorgname2 <- sapply(b$bestorgname1, function(x) ifelse(grepl('s__;', x), '.', x))

b_bestorgorig <- b$bestorgname
b_bestorgname <- b$bestorgname1
b$bestorgname <- NULL
b$bestorgname2 <- NULL

#change this if you want it to be more than just MGEs
b$sums <- rowSums(data.frame(b$plasmids, b$is, b$phage))
V(g_one)$plasmid<-b$plasmids
V(g_one)$phage<-b$phage
V(g_one)$arg<-b$args    
V(g_one)$is<-b$is
V(g_one)$org<-b$org		 
V(g_one)$deg <- degree(g_one, mode="all")
V(g_one)$sums <- b$sums
V(g_one)$orgname <- as.character(b_orgname)
V(g_one)$argname <- as.character(b_argname)
V(g_one)$bestorgname <- as.character(b_bestorgname)
V(g_one)$bestorgorig <- as.character(b_bestorgorig)
#g_no_mges=delete_vertices(g_one,which(V(g_one)$sums>0))
#instead of removing the mobile contigs keep them!!
g_no_mges=g_one
g_all_mges=delete_vertices(g_one,which(V(g_one)$sums<1))
V(g_no_mges)$deg <- degree(g_no_mges, mode="all")

#cluster_edge_betweenness, cluster_fast_greedy, cluster_label_prop, cluster_leading_eigen, cluster_louvain, cluster_optimal, cluster_spinglass, cluster_walktrap
write(paste('mean_weight:', mean(E(g_no_mges)$weight),'\t',sep=""), file = infile, append=T)
write(paste('median_weight:', median(E(g_no_mges)$weight),'\t',sep=""), file = infile, append=T)
write(paste('max_weight:', max(E(g_no_mges)$weight),'\t',sep=""), file = infile, append=T)
write(paste('vertices:', vcount(g_no_mges),'\t',sep=""), file = infile, append=T)
write(paste('edges:', ecount(g_no_mges),'\t',sep=""), file = infile, append=T)

g3 <- g_no_mges

cluster <- cluster_louvain(g3)

g7df <- data.frame(V(g3)$bestorgname, as.numeric(membership(cluster)),V(g3)$bestorgname)
write.csv(g7df, paste(workdir, '/memberships/',name2, "_min", cut.off,"_",identity,"_addon_species_membership_louvain.txt",sep=""))




graph.to.plot <- g3
l = layout_with_mds(graph.to.plot)
my_palette <- colorRampPalette(c("white","orange", "blue","purple","red", "slategray","navy"))(n =length(unique(V(graph.to.plot)$bestorgname)))
communityColors <-my_palette[factor(V(graph.to.plot)$bestorgname)]

pdf(paste(name2, "_min", cut.off,"_",identity,"_addon_membership_louvain.pdf", sep=""), height = 50, width = 50)
plot(graph.to.plot,layout=l,vertex.size=2, edge.color= "black",vertex.label=NA, vertex.color=communityColors,edge.width=1)
dev.off()

end_time <- Sys.time()
write(c(start_time), file = infile, append=T)
write(c(end_time), file = infile, append=T)

