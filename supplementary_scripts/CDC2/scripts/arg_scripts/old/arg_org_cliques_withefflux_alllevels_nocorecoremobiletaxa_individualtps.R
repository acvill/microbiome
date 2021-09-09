library(ggplot2)
library(gplots)
library(vegan)
library(reshape2)
library(RColorBrewer)
library(plyr)
library(gridExtra)
library("devtools")
library(igraph)
set.seed(42)
theme_nogrid <- function (base_size = 12, base_family = "") {
  theme_bw(base_size = base_size, base_family = base_family) %+replace% 
    theme(
      panel.grid = element_blank()
    )   
}
theme_set(theme_nogrid())

#testing
folder = 'CDC2'
folder2= 'nocorecorenomobilemobile'
argpid = '99'
hicpid = '0'

args <- commandArgs(trailingOnly = TRUE)
folder = args[1]
folder2 = args[2]
argpid = args[3]
hicpid = args[4]

#range01 <- function(x)(x-min(x))/diff(range(x))
#cRamp <- function(x, palette){
#  cols <- colorRamp(palette(100))(range01(x))
#  apply(cols, 1, function(xt)rgb(xt[1], xt[2], xt[3], maxColorValue=255))
#}
#Load latest version of heatmap.3 function
source_url("https://raw.githubusercontent.com/obigriffith/biostar-tutorials/master/Heatmaps/heatmap.3.R")
##################################################
#colors
arg.palette <-colorRampPalette(brewer.pal(12,"Set3"))
qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, rownames(qual_col_pals)))
n<-14
mech.col<-col_vector[59:(n+59)]
#pie(rep(1,n), col=mech.col)
n <- 37
kewl<-col_vector[1:(n+1)]
#pie(rep(1,n), col=kewl)
#n<-7
#phylum.col<-col_vector[47:(n+47)]
###################################################################
setwd(paste("/workdir/users/agk85/", folder, "/arg_v_org/metagenomes/cliques/", folder2, sep=""))
depth = 1
#import the cluster info
arginfo= read.csv(paste("/workdir/users/agk85/", folder, "/arg_v_org/metagenomes/arg_v_samp_", argpid, "_", argpid, "_names_mech.txt", sep=""), sep="\t",header = T)
indata = read.csv(paste("arg_org_hic_cliques_", argpid, "_", hicpid, "_" ,depth, "_2.tbl",sep=""), header=T, sep="\t",row.names=1)
merged =merge(arginfo, indata, by="Cluster", all.y=T)
sub2<- merged[order(merged$ARG_name,merged$Sub_mechanism, merged$Cluster),] #indata$Sample, do first if want to reorder

#remove the efflux genes JK I don't do that anymore
sub3 <- sub2
#remove all of the other columns
sub3$Protein<-NULL
sub3$Name<-NULL
sub3$CARD<-NULL
sub3$Resfams<-NULL
sub3$Mechanism<-NULL
sub3$Sub_mechanism<-NULL
sub4 <- sub3

connectdf = sub4[5:ncol(sub4)]
connectsum <- rowSums(connectdf)
#everything will either be normal or multitaxa
sub5 <- subset(sub4,connectsum>0)

#row colors
#do we really need this?
#patient.palette <- colorRampPalette(c("red",'blue',"orange","gray","purple","forestgreen","navy"))
patient.palette <- colorRampPalette(kewl)
#i don't know how to handle this well...for this one i don't want it to be the combos
sub5$pats <- as.vector(sapply(strsplit(as.character(sub5$Sample),"[+]"), function(x) trimws(x)[[1]]))

#sub5$patients<-as.vector(sapply(strsplit(sub5$pats, "-"),function(x) x[[1]]))
#sub5$pats <-NULL

sub5$patients<-sub5$pats
sub5$pats <-NULL
#sub5$patients <- as.vector(sapply(strsplit(as.character(sub5$Sample),"-"), function(x) x[[1]]))
patient.col=patient.palette(length(unique(factor(sub5$patients))))[factor(sub5$patients)]
######what about if you aggregate sub5 down to patients:
a = subset(arginfo, select=c("Cluster","Sub_mechanism"))
sub5_a <- merge(sub5, a, by="Cluster")
sub6 <- sub5_a[order(sub5_a$Sub_mechanism),]
sub6$Sample<-NULL
#sub6$Sub_mechanism<-NULL
sub6$Top_ARG<-NULL
sub6$ARG_name<-as.character(sub6$ARG_name)
df_melt <- melt(sub6, id = c("patients", "Cluster", "ARG_name","Sub_mechanism"))
#cast with the patients
sub7 <- dcast(df_melt, Sub_mechanism + Cluster+ patients + ARG_name ~ variable, sum)

connectdf <-sub7[,5:ncol(sub7)]
connectdf <- connectdf[,colSums(connectdf)>0]
connectdf <-(connectdf>0) + 0
sub7_metadata <- sub7[,1:4]
sub7_presence <-cbind(sub7_metadata, connectdf)
sub7_melt <- melt(sub7_presence, id = c("patients", "Cluster", "ARG_name", "Sub_mechanism"))
#cast with the patients
sub7_aggregate <- dcast(sub7_melt, Sub_mechanism + Cluster + ARG_name ~ variable, sum)

dim(sub7_aggregate)
connectdf <-sub7_aggregate[,4:ncol(sub7_aggregate)]
n=7
levels <-as.vector(sapply(strsplit(as.character(colnames(connectdf)),"[.][.]"), function(x) list(trimws(x))))
groupvar <- as.factor(sapply(levels, function(x) paste(x[n:n], collapse=";")))
groupvar_ending <- as.factor(sapply(levels, function(x) paste(x[n:7], collapse=";")))
connectdf_t <- data.frame(t(connectdf))
connectdf_t$groupvar <- groupvar
connectdf_speciesonly <- connectdf_t #subset(connectdf_t, groupvar!="s__.")
connectdf_speciesonly$groupvar <- NULL
r = rowSums(connectdf_speciesonly)
c = colSums(connectdf_speciesonly)
cdf_speciesonly <-connectdf_speciesonly[r>0,c>0]
sub7_speciesonly <-sub7_aggregate[c>0,] 
subdata = data.matrix(cdf_speciesonly)
n=5
levels <-as.vector(sapply(strsplit(as.character(rownames(subdata)),"[.][.]"), function(x) list(trimws(x))))
groupvar <- as.factor(sapply(levels, function(x) paste(x[n:n], collapse=";")))
groupvar_ending <- as.factor(sapply(levels, function(x) paste(x[n:7], collapse=";")))

colors <- c("white","lightblue","blue","purple","yellow","orange","red","pink")
heat.col = colors[0:max(subdata)+1]
n <- max(subdata)
namelist = c("not connected","connected")
names <- namelist[0:max(subdata)+1]
mydist=function(c) {dist(c)}
myclust=function(c) {hclust(c,method="average")}
taxa.colors <- colorRampPalette(brewer.pal(9,"Set1"))
taxa.col = taxa.colors(length(unique(groupvar)))
csc=cbind(taxa.col[groupvar])

connectdf <-sub7[,5:ncol(sub7)]
cdf <- connectdf[rowSums(connectdf)>1,colSums(connectdf)>0]
sub8_metadata <- sub7[rowSums(connectdf)>1,1:4]
connectdf <-(cdf>0) + 0
sub8_presence <-cbind(sub8_metadata, connectdf)
sub8_melt <- melt(sub8_presence, id = c("Sub_mechanism","patients", "Cluster", "ARG_name"))
#cast to aggregate on the patients
sub8_aggregate <- dcast(sub8_melt, Cluster + ARG_name ~ variable, sum)

connectdf <-sub8_aggregate[,3:ncol(sub8_aggregate)]
n=7
levels <-as.vector(sapply(strsplit(as.character(colnames(connectdf)),"[.][.]"), function(x) list(trimws(x))))
groupvar <- as.factor(sapply(levels, function(x) paste(x[n:n], collapse=";")))
connectdf_t <- data.frame(t(connectdf))
connectdf_t$groupvar <- groupvar
connectdf_speciesonly <- connectdf_t  #subset(connectdf_t, groupvar!="s__.")
connectdf_speciesonly$groupvar <- NULL
r = rowSums(connectdf_speciesonly)
c = colSums(connectdf_speciesonly)
cdf_speciesonly <-connectdf_speciesonly[r>0,c>0]
sub8_speciesonly <-sub8_aggregate[c>0,] 
subdata = data.matrix(cdf_speciesonly)
n=5
levels <-as.vector(sapply(strsplit(as.character(rownames(subdata)),"[.][.]"), function(x) list(trimws(x))))
groupvar <- as.factor(sapply(levels, function(x) paste(x[n:n], collapse=";")))
groupvar_ending <- as.factor(sapply(levels, function(x) paste(x[n:7], collapse=";")))

colors <- c("white","purple","blue","lightblue","yellow","orange","orangered","red","pink")
heat.col = colors[0:max(subdata)+1]
n <- max(subdata)
namelist = c("not connected","connected")
names <- namelist[0:max(subdata)+1]
mydist=function(c) {dist(c)}
myclust=function(c) {hclust(c,method="average")}
taxa.colors <- colorRampPalette(brewer.pal(9,"Set1"))
taxa.col = taxa.colors(length(unique(as.character(groupvar))))
csc=cbind(taxa.col[groupvar])
d<-data.frame(unique(cbind(as.character(groupvar),csc)))
colnames(d)<- c("Taxa","Taxacolor")

#row colors
#fixing the mechanism colors
merged <- merge(sub8_speciesonly, arginfo, by="Cluster")
mechs = unique(arginfo$Sub_mechanism)[order(unique(arginfo$Sub_mechanism))]
mcol = mech.col[1:length(levels(merged$Sub_mechanism))] 
cols = setNames(mcol, levels(merged$Sub_mechanism))
k = cols[merged$Sub_mechanism]
kmat = t(as.matrix(k))
kuniq = unique(k)
kuniqnames = unique(names(k))
#############################################################takes awhile for d=2
df_melt <- melt(sub6, id = c("Sub_mechanism","patients", "Cluster", "ARG_name"))
df_melted <- aggregate(value ~ ., max, data=df_melt)
sub7 <- dcast(df_melted, patients+Cluster + ARG_name ~ variable, sum)
connectdf <-sub7[,4:ncol(sub7)]

n=7
levels <-as.vector(sapply(strsplit(as.character(colnames(connectdf)),"[.][.]"), function(x) list(trimws(x))))
gxroupvar <- as.factor(sapply(levels, function(x) paste(x[n:n], collapse=";")))
connectdf_t <- data.frame(t(connectdf))
connectdf_t$groupvar <- groupvar
connectdf_speciesonly <- connectdf_t  #subset(connectdf_t, groupvar!="s__.")
connectdf_speciesonly$groupvar <- NULL
r = rowSums(connectdf_speciesonly)
c = colSums(connectdf_speciesonly)
cdf_speciesonly <-connectdf_speciesonly[,c>0]
sub7_metadata <-sub7[c>0,1:3]
sub7_speciesonly <- cbind(sub7_metadata, t(cdf_speciesonly))

pat_mats<-list()
pat_mats_melt<-list()
pats <- unique(sub7_speciesonly$patients)
for (i in seq(length(pats))){
	print(i)
	if (i!=30){
	patient <- pats[i]
	print(patient)
	sub9 <- subset(sub7_speciesonly, patients==patient)
	sub9$ARG_name <- NULL
	sub9$patients <- NULL
	rownames(sub9)<-sub9$Cluster
	sub9$Cluster<-NULL
	sub10<-as.data.frame(t(sub9[,0:(ncol(sub9))]))
	sub11 <- sub10[rowSums(sub10)>0,colSums(sub10)>1]
	x <-sub11
	x <- apply(x, 2,  function(x) as.numeric(x > 0))  #recode as 0/1
	v <- x %*% t(x)                                   #the magic matrix 
	diag(v) <- 0                                      #repalce diagonal
	dimnames(v) <- list(rownames(sub11), rownames(sub11))                #name the dimensions
	v[is.na(v)]<-0
	pat_mats[[i]]<-v
	pat_mats_melt[[i]] <- melt(v)
	}
}
allargs_pat_mats <-pat_mats
##############################
longdf = do.call(rbind, pat_mats_melt)
longdf.agg <- aggregate(value ~., data =longdf,sum)
longdf.link <- subset(longdf.agg, value>0)
el=as.matrix(longdf.link)
g=graph.edgelist(el[,1:2])
E(g)$weight=as.numeric(el[,3])
g_simp1<-as.undirected(g, "collapse")
g_simp <- simplify( g_simp1, remove.multiple=T, edge.attr.comb=c(weight="sum") )
E(g_simp)$weight<-E(g_simp)$weight/2

n=5
levels <-as.vector(sapply(strsplit(as.character(V(g_simp)$name),"[.][.]"), function(x) list(trimws(x))))
V(g_simp)$groupvar <- as.character(as.factor(sapply(levels, function(x) paste(x[5:5], collapse=";"))))
edgelist <-E(g_simp)[inc(V(g_simp)["f__Enterobacteriaceae" ==groupvar])]
E(g_simp)$enterocol <- ifelse(E(g_simp) %in% edgelist, "red","black")

pat_graphs = list()
for (i in seq(length(pats))){
if (i!=30){
pat.link <- as.matrix(subset(melt(pat_mats[[i]]), value>0))
g.pat <- graph.edgelist(pat.link[,1:2])
E(g.pat)$weight=as.numeric(as.matrix(pat.link)[,3])
g.pat.sim<-as.undirected(g.pat, "collapse")
g.pat.simp <- simplify(g.pat.sim, remove.multiple=T, edge.attr.comb=c(weight="sum") )
E(g.pat.simp)$weight<-E(g.pat.simp)$weight/2
pat_graphs[[i]] = g.pat.simp
}
}
#create an empty graph without edges
g_simp_noedges<-delete_edges(g_simp, E(g_simp))
#n=7
#levels <- as.vector(sapply(strsplit(as.character(V(g_simp_noedges)$name),"[.][.]"), function(x) list(trimws(x))))
#V(g_simp)$species <- as.factor(sapply(levels, function(x) paste(x[n:n], collapse=";")))
g_simp_species <- g_simp #delete_vertices(g_simp, V(g_simp)[species=='s__.'])
g_simp_species_noedges<-delete_edges(g_simp_species, E(g_simp_species))

n=5
levels <-as.vector(sapply(strsplit(as.character(V(g_simp_species_noedges)$name),"[.][.]"), function(x) list(trimws(x))))
groupvar <- as.factor(sapply(levels, function(x) paste(x[n:n], collapse=";")))
familydown <- as.factor(sapply(levels, function(x) paste(x[n:7], collapse=";")))
familycolor<-col_vector[1:(length(unique(factor(groupvar))))][factor(groupvar)]

n=2
levels <-as.vector(sapply(strsplit(as.character(V(g_simp_species_noedges)$name),"[.][.]"), function(x) list(trimws(x))))
phyname <- as.factor(sapply(levels, function(x) paste(x[n:n], collapse=";")))
phylumcolor<-arg.palette(length(unique(factor(phyname))))[factor(phyname)]

V(g_simp_species_noedges)$phylumcolor<- phylumcolor
V(g_simp_species_noedges)$phyname<- as.character(phyname)
V(g_simp_species_noedges)$familydown <- as.character(familydown)
V(g_simp_species_noedges)$familycolor<- familycolor
V(g_simp_species_noedges)$entero <- ifelse(groupvar== "f__Enterobacteriaceae","Enterobacteriaceae","Not Enterobacteriaceae")
V(g_simp_species_noedges)$enterocol <- ifelse(groupvar== "f__Enterobacteriaceae","orange","blue")
graph.to.plot<-g_simp_species_noedges

#for legend
phynamecolor <- data.frame(cbind(as.character(phyname), phylumcolor,V(g_simp_species)$name))
colnames(phynamecolor )<-c("Phylum","Phylumcolor","Fullname")
ppf <- phynamecolor [order(phynamecolor$Fullname),]
ppf$Fullname<-NULL
pp<- unique(ppf)
pp$Phylum<- as.character(pp$Phylum)
pp$Phylumcolor<- as.character(pp$Phylumcolor)

famnamecolor <- data.frame(cbind(as.character(groupvar), familycolor,V(g_simp_species)$name))
colnames(famnamecolor)<-c("Family","Familycolor","Fullname")
fff <- famnamecolor[order(famnamecolor$Fullname),]
fff$Fullname<-NULL
ff<- unique(fff)
ff$Family<- as.character(ff$Family)
ff$Familycolor<- as.character(ff$Familycolor)

l=layout_in_circle(g_simp_species,order =order(V(g_simp_species)$name))
node.size= c(10)
###############taxa labels present in the sample
#load in all the taxa that were ever called for B314---long list
taxalist_subbing=function(infilename) {
taxa = read.table(infilename, header=F,row.names=1,sep = "\t")
taxa = rownames(taxa)
taxa = gsub("; ", "..",taxa)
taxa = gsub(";", ".",taxa)
taxa = gsub("[[]", ".",taxa)
taxa = gsub("[]]", ".",taxa)
taxa = gsub("[']", ".",taxa)
taxa_df <- data.frame(taxa, rep(1,length(taxa)))
return(taxa_df)
}

gs = list()
g_taxa_dfs = list()
a = vector()
graphs_to_plot=list()

#add all vertices to figure is it too big??
#load in all the taxa that were ever called for
#get each patients graph merged with the nodes of everything
for (i in seq(length(pats))){
if (i!=30){
print(pats[i])
gs[[i]] <-pat_graphs[[i]]
#g_taxa_dfs[[i]]<-taxalist_subbing(paste("/workdir/users/agk85/",folder,"/arg_v_org/metagenomes/cliques/",pats[i],".taxa.txt", sep=""))
g_taxa_dfs[[i]]<-taxalist_subbing(paste("/workdir/users/agk85/",folder,"/arg_v_org/metagenomes/cliques/all.taxa.txt",sep=""))
V(gs[[i]])$present <- V(gs[[i]])$name %in% g_taxa_dfs[[i]]$taxa
a = c(a,V(gs[[i]])$present)
graphs_to_plot[[i]]<-graph.to.plot+gs[[i]]
write.graph(gs[[i]],file=paste("g",i,"_all_arg_graph_withnodes.gml",sep=""),format="gml")
#load in all the taxa that were called
g_taxa_dfs[[i]]<-taxalist_subbing(paste("/workdir/users/agk85/",folder,"/arg_v_org/metagenomes/cliques/",pats[i],".taxa.txt", sep=""))
V(graphs_to_plot[[i]])$present <- V(graphs_to_plot[[i]])$name %in% g_taxa_dfs[[i]]$taxa
}
}

all_taxa_df<-taxalist_subbing(paste("/workdir/users/agk85/",folder,"/arg_v_org/metagenomes/cliques/all.taxa.txt", sep=""))
write.graph(g_simp, file="g_simp_arg_attributes_withnodes.gml",format="gml")
write.csv(a,'Taxa_issues_withefflux_alllevels.csv')


pdf("Org_org_network_circle_phylum_separated_withefflux_alllevels_depth1_individual.pdf",height=50,width=50)
vsize=2
m=0
line_scaling = 5
for (i in seq(length(pats))){
if(i!=30){
print(pats[i])
plot(gs[[i]],layout=l,vertex.label=NA,vertex.frame.color=V(gs[[i]])$enterocol,vertex.size=vsize,vertex.color=V(gs[[i]])$phylumcolor,edge.color=kewl[i],edge.width=E(gs[[i]])$weight_2/line_scaling)
par(new=TRUE)
m = max(m,E(gs[[i]])$weight_2)
}}
legend("bottomright",cex = 4,pch=21,legend=c(pp$Phylum),col=c(pp$Phylumcolor),pt.bg=c(pp$Phylumcolor))
#legend("bottomright",cex = 4,pch=21,legend=c(ff$Family),col=c(ff$Familycolor),pt.bg=c(ff$Familycolor))
legend("topleft",cex = 5,pch=1,legend=c("Enterobacteriaceae","Not Enterobacteriaceae"),col=c("orange","blue"))
legend("topright",cex=5,lty=1,lwd=20,legend=pats,col=c(kewl))
#make sure that g1 still has the max
maxweight = m
legend("bottomleft", cex =5, legend=c("min: 1",paste("max: ",maxweight, sep="")), lty=1, lwd=c(1,maxweight/line_scaling) ,bty="n")
dev.off() 

patient_graphs <- graphs_to_plot
#this will get you the phylum graphs for each patient in circle mode
for (i in seq(length(pats))){
	if (i!=30){
	patient_graph = patient_graphs[[i]]
	print(pats[i])
	#highlighting the entero connections
	n=5
	V(patient_graph)$phylumcolor2 <- V(patient_graph )$phylumcolor
	V(patient_graph)$phylumcolor2[!V(patient_graph)$present]<-NA
	pdf(paste("Org_org_network_circle_g",i,"_phylum_withefflux_alllevels_depth1_individual.pdf",sep=""),height=50,width=50)
	#1-B314, 2-B316, 3-B320, 4-B331, 5-B335, 6-B357, 7-B370
	vsize=2
	plot(patient_graph, layout=l,vertex.label=NA,vertex.frame.color=NA,vertex.size=vsize,vertex.color=V(patient_graph)$phylumcolor2,edge.color=NA,edge.width=E(patient_graph)$weight_2/line_scaling)
	par(new=TRUE)
	plot(patient_graph,layout=l,vertex.label=NA,vertex.frame.color=NA,vertex.size=vsize,vertex.color=NA,edge.width=E(patient_graph)$weight_2/line_scaling,edge.color="black")
	legend("bottomright",cex = 4,pch=21,legend=c(pp$Phylum),col=c(pp$Phylumcolor),pt.bg=c(pp$Phylumcolor))
	maxweight = max(E(patient_graph)$weight_2)
	legend("bottomleft", cex =5, legend=c("min: 1",paste("max: ",maxweight, sep="")), lty=1, lwd=c(1,maxweight/line_scaling) ,bty="n")
	title(pats[i],cex.main=10)
	dev.off()
}
}


####this is a circle figure with phylum coloring of everything
pdf(paste("Org_org_network_circle_all_phylum_withefflux_alllevels_depth1_individual.pdf",sep=""),height=50,width=50)
vsize=2
plot(graph.to.plot,layout=l,vertex.label=NA,vertex.frame.color=V(graph.to.plot)$enterocol,vertex.size=vsize,vertex.color=V(graph.to.plot)$phylumcolor)
par(new=TRUE)
plot(g_simp_species,layout=l,vertex.label=NA,vertex.frame.color=NA,vertex.size=vsize,vertex.color=NA,edge.width=E(g_simp_species)$weight/line_scaling)
legend("bottomright",cex = 4,pch=21,legend=c(pp$Phylum),col=c(pp$Phylumcolor),pt.bg=c(pp$Phylumcolor))
legend("topleft",cex=5, lty=1, lwd=20, legend=c("US2","US3","US5","US6","US7"),col=c(kewl[8:12]))
legend("topright",cex=5,lty=1,lwd=20,legend=c("B314","B316","B320","B331","B335","B357","B370"),col=c(kewl))
maxweight = max(E(g_simp_species)$weight)
legend("bottomleft", cex =5, legend=c("min: 1",paste("max: ",maxweight, sep="")), lty=1, lwd=c(1,max(E(g_simp)$weight/line_scaling)) ,bty="n")
dev.off()
######################################################
