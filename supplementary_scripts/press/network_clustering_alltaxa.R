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
infile<-paste(workdir, "/outputs/Stats_nomge_", name2, "_", identity, "_", cut.off,".txt", sep="") 

#no euks version
#trans interactions from hic data
data <- read.table(paste(wrk, "/hic/mapping/", name2,"/",name2,"_",ref, "_trans_primary_", identity, "_noeuks.txt",sep=""), sep="\t")
colnames(data)<-c("ID1","Flag1","Contig1","Start1","Mapq1","CIGAR1","ID2","Flag2","Contig2","Start2","Mapq2","CIGA
R2")
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
g_no_mges=delete_vertices(g_one,which(V(g_one)$sums>0))
g_all_mges=delete_vertices(g_one,which(V(g_one)$sums<1))
V(g_no_mges)$deg <- degree(g_no_mges, mode="all")

#cluster_edge_betweenness, cluster_fast_greedy, cluster_label_prop, cluster_leading_eigen, cluster_louvain, cluster_optimal, cluster_spinglass, cluster_walktrap
write(paste('mean_weight:', mean(E(g_no_mges)$weight),'\t',sep=""), file = infile, append=T)
write(paste('median_weight:', median(E(g_no_mges)$weight),'\t',sep=""), file = infile, append=T)
write(paste('max_weight:', max(E(g_no_mges)$weight),'\t',sep=""), file = infile, append=T)
write(paste('vertices:', vcount(g_no_mges),'\t',sep=""), file = infile, append=T)
write(paste('edges:', ecount(g_no_mges),'\t',sep=""), file = infile, append=T)

#g3<- as.undirected(g2)
g3 <- g_no_mges
df <-get.data.frame(g3)

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
conflict_comparison <- function(taxonomy1, taxonomy2){
	#compare each of the levels, if the same good, if different and not empty, then conflict
	#but you have to compare the upper stuff too, so like compare normaly if empty no conflict
	#but then ALSO compare down to the higher lowest including empty stuff
	#so compare lowest(taxonomy1)  
	conflict = 0
	levels = c('s__','g__', 'f__', 'o__', 'c__', 'p__', 'k__')
	#for (i in seq(length(levels))){
	#	taxa1 = strsplit(strsplit(taxonomy1,levels[i])[[1]][2], ";")[[1]][1]
	#	taxa2 = strsplit(strsplit(taxonomy2,levels[i])[[1]][2], ";")[[1]][1]
	#	if (taxa1!='' & taxa2!='' & taxa1!=taxa2){conflict = 1}
	#}
	l1 = lowest(taxonomy1)
	l2 = lowest(taxonomy2)
	biggest_lowest=ifelse(l1>=l2, l1,l2)
	#compare at that level and up 
	if (biggest_lowest == 1){
		#compare both taxonomies fully
		if (taxonomy1!=taxonomy2){conflict = 1} 
	}else{
		#compare at the level by splitting at the level below
		taxa1 = strsplit(taxonomy1,levels[biggest_lowest-1])[[1]][1]
		taxa2 = strsplit(taxonomy2,levels[biggest_lowest-1])[[1]][1]
		if (taxa1!=taxa2){conflict = 1}
	}
	return(conflict)
}

#function to get the species of a bestorgname 
get_species <- function(taxonomy) {
species = strsplit(taxonomy, 's__')[[1]][2]
return(species)
}

#function comparing two vertices
#f <- function(x, output) {
# vertex1 <- x[1]
# vertex2 <- x[2]
# taxonomy1 <- V(g3)[vertex1]$bestorgname
# taxonomy2 <- V(g3)[vertex2]$bestorgname
# #if the two species are the same and if they are not both '.', then put the bestorgname of one of them , else NA
# ifelse(get_species(V(g3)[vertex1]$bestorgname) == get_species(V(g3)[vertex2]$bestorgname),
#        ifelse(V(g3)[vertex2]$bestorgname!='.',V(g3)[vertex2]$bestorgname,NA),NA)
#}

#simplify
#g6 now is just g3
#iterate through all the edges in order
#compare the vertices -- if it has a grouporg then use that if not use the bestorgname, 
#if either is just a dot, then they are not in conflict
#but then you can update unannotated with annotated because connnected
#if both have taxonomies, then assess taxonomic conflict
#if they are in conflict, remove the edge
#if they are not in conflict, give the grouporganism of the lower to both grouporgs
#keep reiterating through until there are no changes
conflictleveltracker=rep(0,7)
#print(conflictleveltracker)

g6 <- g3
V(g6)$grouporg = V(g6)$bestorgname
diff = 1
count = 0
while(diff>0){
	E(g6)$toremove <- rep(0, ecount(g6))
	edges.to.delete <- rep(NA, ecount(g6))
	e_edges <- E(g6)
	e_top_weights <- order(e_edges$weight, decreasing=TRUE) 
	el <- E(g6)[as.vector(e_edges)[e_top_weights]] 
	diff = 0
	for(i in seq(length(el))){
		edge = el[i]
		verts = ends(g6,edge)
		v1group = V(g6)[verts[1]]$grouporg
		v2group = V(g6)[verts[2]]$grouporg
		#three questions
		#Are they identical grouporgs?
			#Is either one unannotated == '.' ----are there any NAs??
				#Are they in conflict
		different_taxonomies = (v1group != v2group)
		if (different_taxonomies){
			both_annotated=(v1group!='.' & v2group!='.')
			if(both_annotated){
				in_conflict = conflict_comparison(v1group, v2group)[1]
				conflictleveltracker=conflict_comparison(v1group, v2group)[2:8]
				
				if(in_conflict){
					#mark the edge
					#E(g6)$toremove[i] = 1
					edges.to.delete[i] = E(g6)[edge]
					#print(paste("weight:", edge$weight))
					#g6 = g6 - edge
					diff = diff + 1
					#increase conflict counter
					count = count + 1
					} else {
					#update both with the lowest taxonomy (because easier than figuring out which to do)
					l = lower_taxonomy(v1group, v2group)
					V(g6)[verts[1]]$grouporg = l
					V(g6)[verts[2]]$grouporg = l
					#increase diff
					diff = diff + 1
					}
				} else {
				#this means that one has a taxonomy and the other is unannotated
				#update the unannotated one with the annotated taxonomy
				diff = diff + 1
				V(g6)[verts[1]]$grouporg = ifelse(V(g6)[verts[1]]$grouporg == '.',        
               		         	V(g6)[verts[2]]$grouporg,V(g6)[verts[1]]$grouporg)                
                       		V(g6)[verts[2]]$grouporg = ifelse(V(g6)[verts[2]]$grouporg == '.',
					V(g6)[verts[1]]$grouporg,V(g6)[verts[2]]$grouporg)
				}
			}
		}
	#print(diff)
	#remove all of the edges with conflict
	#subset down to non-null values
	to_delete = edges.to.delete[!is.na(edges.to.delete)]
	ecount(g6)
	g6 = delete.edges(g6, to_delete)
	ecount(g6)
	count
	}

g_named =delete.vertices(g6,which(V(g6)$grouporg=='.'))
write(paste('g_named_vertices:', vcount(g_named),'\t',sep=" "), file = infile, append=T)
write(paste('g_named_edges:', ecount(g_named),'\t',sep=" "), file = infile, append=T)
write(paste("edges_undone_1:",count,'\t',sep=""), file=infile, append=T)
#delete singletons
g7=delete.vertices(g6,which(degree(g6)<1))
comps <- components(g7)
g7df <- data.frame(V(g7)$grouporg, comps$membership, V(g7)$bestorgorig)
write(paste('number_clusters:', comps$no, sep=""), file= infile, append=T)
write.csv(g7df, paste(workdir, '/memberships/',name2, "_min", cut.off,"_",identity,"_addon_species_membership.txt",sep=""))
####################################################################
write(paste('g7_vertices:', vcount(g7),'\t',sep=" "), file = infile, append=T)
write(paste('g7_edges:', ecount(g7),'\t',sep=" "), file = infile, append=T)

#graph.to.plot <- induced_subgraph(g7, subcomponent(g7, 2, mode = c("all")))
graph.to.plot <- g6
l = layout_with_mds(graph.to.plot)
my_palette <- colorRampPalette(c("white","orange", "blue","purple","red", "slategray","navy"))(n =length(unique(V(graph.to.plot)$grouporg)))
communityColors <-my_palette[factor(V(graph.to.plot)$grouporg)]

pdf(paste(name2, "_min", cut.off,"_",identity,"_addon_membership.pdf", sep=""), height = 50, width = 50)
plot(graph.to.plot,layout=l,vertex.size=2, edge.color= "black",vertex.label=NA, vertex.color=communityColors,edge.width=1)
dev.off()

end_time <- Sys.time()
write(c(start_time), file = infile, append=T)
write(c(end_time), file = infile, append=T)

g7_filename <- paste(workdir, "/graphs/Graph_nomge_", name2, "_", identity, "_", cut.off,".txt", sep="")
mge_filename <- paste(workdir, "/graphs/Graph_mge_", name2, "_", identity, "_", cut.off,".txt", sep="")

write.graph(g7, g7_filename, format="gml")
write.graph(g_all_mges, mge_filename, format="gml")
write(paste(c(name, identity, cutoff, conflictleveltracker,ecount(g_no_mges)),collapse='\t'), file=paste('/workdir/users/agk85/', folder, '/networks/outputs/Conflict_level_tracking.txt',sep=""), append=T)
