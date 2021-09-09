indata0 <- read.csv("sample.stats",header=F, sep='\t')
indata <- subset(indata0, indata0$V3>0)


print("without zeroes")
completeness <- mean(indata$V3)
contamination<- mean(indata$V4)
hetero <- mean(indata$V5)
avgbp <- mean(indata$V6)

s1<-sd(indata$V3)
s2<-sd(indata$V4)
s3<-sd(indata$V5)
s4 <- sd(indata$V6)
n = length(indata$V3)
completeness
contamination
hetero
avgbp 
s1
s2
s3
s4
n

print("with zeroes")
c1 <- mean(indata0$V3)
c2 <- mean(indata0$V4)
c3 <- mean(indata0$V5)
avgbp <- mean(indata0$V6)
s1<-sd(indata0$V3)
s2<-sd(indata0$V4)
s3<-sd(indata0$V5)
s4 <- sd(indata0$V6)
n = length(indata0$V3)
c1
c2
c3
avgbp
s1
s2
s3
s4
n
