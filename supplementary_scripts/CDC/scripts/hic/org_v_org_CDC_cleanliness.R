#org_v_org_gates
library(ggplot2)
library(gplots)
library(vegan)
library(reshape2)
library(RColorBrewer)
theme_nogrid <- function (base_size = 12, base_family = "") {
  theme_bw(base_size = base_size, base_family = base_family) %+replace% 
    theme(
      panel.grid = element_blank()
    )   
}
theme_set(theme_nogrid())
setwd("/workdir/users/agk85/CDC/newhic/plotting/")
#methods = c("0","0_mge","50","50_mge","90","90_mge")
methods = c("98","98_mge")
#method = "98_mge"
for (method in methods){
df <- read.csv(paste("CDC_org_v_org_", method, ".txt", sep=""),header=T,row.names=1,sep="\t")
hist(colSums(df)) #, xlim=c(0,100), breaks=2000)
mat2 <- as.matrix(df)
print(sum(mat2))

my_palette <- colorRampPalette(c("white", "blue", "purple","red"))(n = 1000)
my_palette  <- c("white", colorRampPalette(c("blue", "red"))(n=1000))

mydist=function(c) {vegdist(c)}
myclust=function(c) {hclust(c,method="average")}
pdf(paste("heatmap_org_v_org_", method, ".pdf",sep=""), height=50, width=50,useDingbats=FALSE)
heatmap.2((mat2), hclustfun=myclust, distfun=mydist, na.rm = TRUE, scale="none",
	dendrogram="none",	Rowv=F,Colv=F,key=TRUE,symbreaks=FALSE, margins=c(22,22),
	symkey=F, density.info="none", trace="none", labCol=colnames(mat2), labRow=rownames(mat2),
	cexRow=.3, cexCol=.3, col=my_palette,keysize=0.5,key.par = list(cex=2))
dev.off()
}




#what if you want to aggregate to a certain level??
#methods = c("0","0_mge","50","50_mge","90","90_mge")
methods = c("98", "98_mge")
taxnames = c("Kingdom","Phylum","Class","Order","Family","Genus","Species")
delims = c("k__","p__","c__","o__","f__","g__","s__")
taxlevels=c(2,3,4,5,6,7)
for (method in methods){
	for (n in taxlevels){
df <- read.csv(paste("CDC_org_v_org_", method, ".txt", sep=""),header=T,row.names=1,sep="\t")
rnames <- row.names(df)
taxa <- taxnames[n]
delim <- delims[n]
levels <-as.vector(sapply(strsplit(as.character(rownames(df)),"\\;"), function(x) list(trimws(x))))
s = as.factor(sapply(levels, function(x) paste(x[n:n], collapse=";")))
dfnew <- df[s!=delim,s!=delim]

levels <-as.vector(sapply(strsplit(as.character(rownames(dfnew)),"\\;"), function(x) list(trimws(x))))
groupvar <- as.factor(sapply(levels, function(x) paste(x[0:n], collapse=";")))

aggdata <-aggregate(dfnew, by=list(groupvar), FUN=sum, na.rm=TRUE)
aggdata$Group.1 <- NULL
write.table(unique(s), paste("Taxapresent_", taxa, ".txt",sep=""))
df2 <- t(aggdata)
aggdata2 <-aggregate(df2, by=list(groupvar), FUN=sum, na.rm=TRUE)
newnames <- aggdata2$Group.1
aggdata2$Group.1<-NULL
colnames(aggdata2)<-newnames
rownames(aggdata2)<-newnames
mat2 <- as.matrix(aggdata2)
#figure out percentages inside the diagonal versus/ total(row + column - diag)
proportion_clean <- 100*2*diag(mat2)/(rowSums(mat2)+colSums(mat2))
totes <- (rowSums(mat2)+colSums(mat2))
clean_df<- data.frame(proportion_clean, totes)
colnames(clean_df) <- c("prop","total")
levels <-as.vector(sapply(strsplit(as.character(rownames(clean_df)),"\\;"), function(x) list(trimws(x))))
clean_df$groupvar <- as.factor(sapply(levels, function(x) paste(x[2:2], collapse=";")))
clean_df_major <- subset(clean_df, total>10)

levels <-as.vector(sapply(strsplit(rownames(mat2),";"), function(x) x[[2]]))
colors <- colorRampPalette(brewer.pal(9,"Set1"))
taxa.col = colors(length(unique(levels)))
rsc=taxa.col[factor(levels)]
d<-unique(data.frame(levels,rsc))

pdf(paste("Heatmap_org_v_org_lev_", taxa, "_", method, ".pdf",sep=""), height=20, width=20,useDingbats=FALSE)
heatmap.2((mat2), hclustfun=myclust, distfun=mydist, na.rm = TRUE, scale="none",
	dendrogram="none",	Rowv=F,Colv=F,key=TRUE,symbreaks=FALSE, margins=c(30,30),
	symkey=F, density.info="none", trace="none", labCol=colnames(mat2), labRow=rownames(mat2),
	cexRow=.8, cexCol=.8, col=my_palette, RowSideColors=rsc,ColSideColors=rsc)
legend("left",legend=c(as.character(d$levels)), fill=c(as.character(d$rsc)))
dev.off()
##############################################################################################################
levels <-as.vector(sapply(strsplit(as.character(rownames(df)),"\\;"), function(x) list(trimws(x))))
groupvar <- as.factor(sapply(levels, function(x) paste(x[0:n], collapse=";")))

aggdata <-aggregate(df, by=list(groupvar), FUN=sum, na.rm=TRUE)
aggdata$Group.1 <- NULL
write.table(unique(s), paste("Taxapresent_", taxa, ".txt",sep=""))
df2 <- t(aggdata)
aggdata2 <-aggregate(df2, by=list(groupvar), FUN=sum, na.rm=TRUE)
newnames <- aggdata2$Group.1
aggdata2$Group.1<-NULL
colnames(aggdata2)<-newnames
rownames(aggdata2)<-newnames
mat2 <- as.matrix(aggdata2)
#figure out percentages inside the diagonal versus/ total(row + column - diag)
proportion_clean <- 100*2*diag(mat2)/(rowSums(mat2)+colSums(mat2))
totes <- (rowSums(mat2)+colSums(mat2))
clean_df<- data.frame(proportion_clean, totes)
colnames(clean_df) <- c("prop","total")
levels <-as.vector(sapply(strsplit(as.character(rownames(clean_df)),"\\;"), function(x) list(trimws(x))))
clean_df$groupvar <- as.factor(sapply(levels, function(x) paste(x[2:2], collapse=";")))
clean_df_major <- subset(clean_df, total>10)

levels <-as.vector(sapply(strsplit(rownames(mat2),";"), function(x) x[[2]]))
colors <- colorRampPalette(brewer.pal(9,"Set1"))
taxa.col = colors(length(unique(levels)))
rsc=taxa.col[factor(levels)]
d<-unique(data.frame(levels,rsc))

pdf(paste("Heatmap_org_v_org_lev_", taxa, "_", method, "+higherlevels.pdf",sep=""), height=20, width=20,useDingbats=FALSE)
heatmap.2((mat2), hclustfun=myclust, distfun=mydist, na.rm = TRUE, scale="none",
        dendrogram="none",      Rowv=F,Colv=F,key=TRUE,symbreaks=FALSE, margins=c(30,30),
        symkey=F, density.info="none", trace="none", labCol=colnames(mat2), labRow=rownames(mat2),
        cexRow=.8, cexCol=.8, col=my_palette, RowSideColors=rsc,ColSideColors=rsc)
legend("left",legend=c(as.character(d$levels)), fill=c(as.character(d$rsc)))
dev.off()




	}
}
