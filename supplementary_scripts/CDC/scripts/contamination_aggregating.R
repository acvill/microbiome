indata0 <- read.csv("sample.stats",header=F, sep='\t')
indata <- subset(indata0, indata0$V3>0)


print("without zeroes")
meancompleteness <- mean(indata$V3)
meancontamination<- mean(indata$V4)
meanhetero <- mean(indata$V5)
meanbp <- mean(indata$V6)

mediancompleteness <- median(indata$V3)
mediancontamination<- median(indata$V4)
medianhetero <- median(indata$V5)
medianbp <- median(indata$V6)

s1<-sd(indata$V3)
s2<-sd(indata$V4)
s3<-sd(indata$V5)
s4 <- sd(indata$V6)
n = length(indata$V3)
meancompleteness
meancontamination
meanhetero
meanbp
s1
s2
s3
s4
mediancompleteness
mediancontamination
medianhetero
medianbp
n

print("with zeroes")
c1 <- mean(indata0$V3)
c2 <- mean(indata0$V4)
c3 <- mean(indata0$V5)
c4 <- mean(indata0$V6)
d1 <- median(indata0$V3)
d2 <- median(indata0$V4)
d3 <- median(indata0$V5)
d4 <- median(indata0$V6)
s1<-sd(indata0$V3)
s2<-sd(indata0$V4)
s3<-sd(indata0$V5)
s4 <-sd(indata0$V6)

n = length(indata0$V3)
c1
c2
c3
c4
s1
s2
s3
s4
d1
d2
d3
d4
n
