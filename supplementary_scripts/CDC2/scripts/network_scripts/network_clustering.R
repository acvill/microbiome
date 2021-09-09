#Hi-C base networks
set.seed(472)
library(igraph)
library(qgraph)
library(ggplot2)
library(RColorBrewer)
start_time <- Sys.time() 
#for testing
folder='simulated'
name='sim-1'
name2='sim-1'
identity='0'
cut.off='5'
ref='sim-1'
mgeness = 'nomge'
norm = 'normalized'

args <- commandArgs(trailingOnly = TRUE)
folder=args[1]
name=args[2]
name2 = args[3]
mgeness=args[4]
norm=args[5]
cut.off=args[6]
wrk=paste('/workdir/users/agk85/',folder,sep="")
workdir=paste('/workdir/users/agk85/',folder,'/networks/',sep="")
setwd(workdir)

identity = '0'
print(folder)
print(name)
print(identity)
print(cut.off)
cutoff=as.numeric(cut.off)
infile<-paste(workdir, "/outputs/Stats_", name2, "_", mgeness, "_", norm,".txt", sep="") 

#no euks version
#normalized trans interactions from hic data
data <- read.table(paste(wrk, "/hicpro/output/",name2, "_output/hic_results/data/",name2,"/",name2,"_","trans_primary_",identity,"_ncol_withexcise_noeuks_normalize_", cut.off, ".txt",sep=""), sep="\t")
colnames(data)<-c("ref1", "ref2", "normalized", "normalized_rf", "count","l1","l2","r1","r2", "rf1","rf2")

annotations <- read.table(paste(wrk, "/combo_tables/metagenomes/", name,"_master_scf_table_binary.txt",sep=""),sep="\t",header=T,row.names=1)
amph <- read.table(paste(wrk, "/combo_tables/metagenomes/", name,"_master_scf_table.txt",sep=""),quote = "", sep="\t",header=T,row.names=1)
plasmids <- annotations$Plasmid_Finder + annotations$Full_Plasmids + annotations$Relaxase + annotations$Aclame_plasmid + annotations$Imme_plasmid + annotations$Plasmid_pfams + annotations$Plasflow +  annotations$Mobile_pfams
args <- annotations$Resfams + annotations$Perfect + annotations$CARD
is <- annotations$ISEScan + annotations$Imme_transposon
phage <- annotations$Phage_Finder + annotations$Phaster + annotations$Imme_phage + annotations$Aclame_phage + annotations$Virus
org <- annotations$Kraken

bestorgname <-paste(amph$Best_org.amphora_rnammer.)
annot<- data.frame(plasmids, args, is, phage, org,bestorgname )
rownames(annot)<-rownames(annotations)

mges <- subset(annot, select=c(plasmids, is, phage))
#get the links from the normalized 'data'
#this one uses restriction fragment normalization: 
#1000000*count/(rpkm1*rpkm2*rf1*rf2)

#pick which normalization method you want to use!
if (norm == "normalized") { 
    n = 3
    } else if (norm == "normalized_rf") {
    n = 4
    } else {
    n = 5
}


a <- data[,c(1,2,n)]
colnames(a) <- c("ref1","ref2","weight")
g<-graph_from_data_frame(a, directed=FALSE)

#simplify by collapsing multiple edges and summing them
g_simp <- simplify( g, remove.multiple=T, edge.attr.comb=c(weight="sum") )

#normalize the width to the biggest width (so you don't have whoppers)
E(g_simp)$width <- E(g_simp)$weight   #E(g_simp)$weight/(max(E(g_simp)$weight)/30)

#hist(E(g_simp)$weight,breaks=20000,xlim=c(0,1000000))
#hist(degree(g_simp, V(g_simp)), breaks=400, xlim=c(0,max(degree(g_simp, V(g_simp)))))
#hist(degree(g_simp, V(g_simp)), breaks=400, xlim=c(0,50))

#hist(E(g_simp)$weight,breaks=8000,xlim=c(0,50))
write(c(name2, "\t", identity, "\t", cut.off), file = infile, append=T)
write(paste('mean_weight:', mean(E(g_simp)$weight),sep=""), file = infile, append=T)
write(paste('median_weight:', median(E(g_simp)$weight),sep=""), file = infile, append=T)
write(paste('max_weight:', max(E(g_simp)$weight),sep=""), file = infile, append=T)
write(paste('vertices:', vcount(g_simp),sep=""), file = infile, append=T)
write(paste('edges:', ecount(g_simp),sep=""), file = infile, append=T)
##############
g_one <- g_simp
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

b$bestorgname1 <- as.character(b$bestorgname)
b_bestorgorig <- b$bestorgname
b_bestorgname <- b$bestorgname1
b$bestorgname <- NULL

#change this if you want it to be more than just MGEs
#sums if the contig has plasmid, is, phage
b$sums <- rowSums(data.frame(b$plasmids, b$is, b$phage))
V(g_one)$plasmid<-b$plasmids
V(g_one)$phage<-b$phage
V(g_one)$arg<-b$args    
V(g_one)$is<-b$is
V(g_one)$org<-b$org		 
V(g_one)$deg <- degree(g_one, mode="all")
V(g_one)$sums <- b$sums
V(g_one)$bestorgname <- as.character(b_bestorgname)
V(g_one)$bestorgorig <- as.character(b_bestorgorig)
g_no_mges=delete_vertices(g_one,which(V(g_one)$sums>0))
g_all_mges=delete_vertices(g_one,which(V(g_one)$sums<1))
V(g_no_mges)$deg <- degree(g_no_mges, mode="all")

write(paste('mean_weight:', mean(E(g_no_mges)$weight),'\t',sep=""), file = infile, append=T)
write(paste('median_weight:', median(E(g_no_mges)$weight),'\t',sep=""), file = infile, append=T)
write(paste('max_weight:', max(E(g_no_mges)$weight),'\t',sep=""), file = infile, append=T)
write(paste('vertices:', vcount(g_no_mges),'\t',sep=""), file = infile, append=T)
write(paste('edges:', ecount(g_no_mges),'\t',sep=""), file = infile, append=T)

#change this to g_one if you want to keep the mobile genes in
if (mgeness=="nomge"){
g3 = g_no_mges
}else{
g3 = g_one
}

lowest <- function(taxonomy){
	#if it doesn't break i want the k__; to be higher value than the k__Bacteria;
        levels = c('s__','g__', 'f__', 'o__', 'c__', 'p__', 'k__','k__')
        for (i in seq(length(levels))){
                taxa = strsplit(taxonomy,levels[i])[[1]][2]
		taxa2 = strsplit(taxa, ";")[[1]][1]
		#print(taxonomy)
                if(taxa2 != '') {break}
	}
        level = i
        return(level)
}

lower_taxonomy <- function(taxonomy1, taxonomy2){
	l1 = lowest(taxonomy1)
	l2 = lowest(taxonomy2)
	lowest_taxonomy=ifelse(l1<=l2, taxonomy1, taxonomy2)
	return(lowest_taxonomy)
}

lowest_conflict <- function(taxonomy1, taxonomy2){
        levels = c('s__','g__', 'f__', 'o__', 'c__', 'p__', 'k__')
        l1 = lowest(taxonomy1)
        l2 = lowest(taxonomy2)
        biggest_lowest=ifelse(l1>=l2, l1,l2)
        for (i in rev(seq(biggest_lowest, length(levels)))){
                lev = levels[i]
                taxa1 = strsplit(strsplit(taxonomy1,levels[i])[[1]][2],';')[[1]][1]
                taxa2 = strsplit(strsplit(taxonomy2,levels[i])[[1]][2],';')[[1]][1]
                if (taxa1!=taxa2){
                break
                }
        }
        return(i)
}

#conflict function
#compare each of the levels, if the same good, if different and not empty, then conflict
#but you have to compare the upper stuff too, so like compare normaly if empty no conflict
#but then ALSO compare down to the higher lowest including empty stuff
#so compare lowest(taxonomy1)
conflict_comparison <- function(taxonomy1, taxonomy2){
        conflict = 0
        levels = c('s__','g__', 'f__', 'o__', 'c__', 'p__', 'k__')
        l1 = lowest(taxonomy1)
        l2 = lowest(taxonomy2)
        biggest_lowest=ifelse(l1>=l2, l1,l2)
        #compare at that level and up
        if (biggest_lowest == 1){
                #compare both taxonomies fully
                if (taxonomy1!=taxonomy2){
                        conflict = 1
                }
        }else{
                #compare at the level by splitting at the level below
                taxa1 = strsplit(taxonomy1,levels[biggest_lowest-1])[[1]][1]
                taxa2 = strsplit(taxonomy2,levels[biggest_lowest-1])[[1]][1]
                if (taxa1!=taxa2){
                        conflict = 1
                }
        }
        return(conflict)
}

#with the two vertices and the graph, set the v1 as v2 and then contract, delete v1, and simplify
contract_and_update <- function(v1, v2, g){
	i1 = as.numeric(V(g)[v1])
	i2 = as.numeric(V(g)[v2])
	a = seq(vcount(g))
	a[i1] = i2
	g2 <- contract(g, a, vertex.attr.comb=list(name=toString, bestorgname = function(x)x[1]))
        g2 <- delete_vertices(g2, i1)
        g2 <- simplify(g2, remove.multiple=T,remove.loops=T,edge.attr.comb = list(weight = "sum"))
	return(g2)
}

#iterate through all the edges in order
g6 <- g3
#Clean g6 so it is only name, weight, bestorgname 
g6 <- delete_vertex_attr(g6, "deg")
g6 <-delete_vertex_attr(g6, "plasmid")
g6 <-delete_vertex_attr(g6, "phage")
g6 <-delete_vertex_attr(g6, "arg")
g6 <-delete_vertex_attr(g6, "is")
g6 <-delete_vertex_attr(g6, "org")
g6 <-delete_vertex_attr(g6, "sums")
g6 <-delete_vertex_attr(g6, "bestorgorig")
g6 <-delete_edge_attr(g6, "width")

count = 0
while(length(E(g6))>0){
    e_top_weights <- order(E(g6)$weight, decreasing=TRUE)
    el <- E(g6)[as.vector(E(g6))[e_top_weights]]
    verts = ends(g6,el[1])
    v1 = verts[1]
    v2 = verts[2]
    v1group = V(g6)[v1]$bestorgname
    v2group = V(g6)[v2]$bestorgname
    if (v1group != v2group){
        if(v1group!='.' & v2group!='.'){
        	in_conflict = conflict_comparison(v1group, v2group)
            if(in_conflict){
            	g6 = delete.edges(g6, el[1])
                count = count + 1
            } else {
            	l = lower_taxonomy(v1group, v2group)
                V(g6)[v1]$bestorgname = l
            	V(g6)[v2]$bestorgname = l
                g6<-contract_and_update(v1,v2,g6)
        	}
        } else {
            V(g6)[v1]$bestorgname = ifelse(V(g6)[v1]$bestorgname == '.',V(g6)[v2]$bestorgname,V(g6)[v1]$bestorgname)
            V(g6)[v2]$bestorgname = ifelse(V(g6)[v2]$bestorgname == '.',V(g6)[v1]$bestorgname,V(g6)[v2]$bestorgname)
            g6<- contract_and_update(v1,v2,g6)
       	}
    } else {
        	g6<- contract_and_update(v1,v2,g6)
    }
}


g_named =delete.vertices(g6,which(V(g6)$bestorgname=='.'))
write(paste('g_named_vertices:', vcount(g_named),'\t',sep=" "), file = infile, append=T)
write(paste('g_named_edges:', ecount(g_named),'\t',sep=" "), file = infile, append=T)
write(paste("edges_undone_1:",count,'\t',sep=""), file=infile, append=T)

j = rep(paste(name, "_network_",sep=""), length(V(g6)$name))
k = seq(length(V(g6)$name))
l = paste(j, k, sep="")
n = V(g6)$name
o = V(g6)$bestorgname
p = data.frame(l,n,o)
write.table(p, paste(workdir, '/membership/',name2, "_", cut.off, '_',mgeness,"_",norm,"_membership.txt",sep=""),sep="\t", quote=FALSE)

####################################################################
g6_filename <- paste(workdir, "/graphs/", name2, "_", cut.off, "_",mgeness, "_", norm, "_", "graph.txt", sep="")

write.graph(g6, g6_filename, format="gml")
#write(paste(c(name, identity, cutoff, conflictleveltracker,ecount(g_no_mges)),collapse='\t'), file=paste('/workdir/users/agk85/', folder, '/networks/outputs/Conflict_level_tracking.txt',sep=""), append=T)


