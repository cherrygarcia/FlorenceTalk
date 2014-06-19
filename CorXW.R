setwd("/Users/kararudolph/Documents/PhD/NIMH/NCSA/urbanicity&disadvantage")
library(mitools)
library(survey)
library(mice)
library(MatchIt)
library(plyr)
library(splines)
library(car)
library(xtable)
load("impdata100.Rdata")
tmp<-list(rep(NA,100))
tmpone<-list(rep(NA,100))

for(i in 1:100){
  tmp[[i]]<-complete(imp, action=i, include=FALSE)
}

library(MatchIt)

dat<-list(rep(NA,100))
tmp.out.subclass<-list(rep(NA,100))
tmp.subcl<-list(rep(NA,100))
s.tmp.out<-list(rep(NA,100))
n<-list(rep(NA,100))

full.out.subclass<-list(rep(NA,100))
full.subcl<-list(rep(NA,100))
s.full.out<-list(rep(NA,100))
n.full<-list(rep(NA,100))

for(i in 1:100){
tmp[[i]]$tertscore<-ifelse(tmp[[i]]$score < (-2.293536), 1, 0)

#make income variable
tmp[[i]]$inc<-ifelse(tmp[[i]]$lninc==0, 0, 1)
tmp[[i]]$inccomp<-tmp[[i]]$inc*tmp[[i]]$lninc
#mean maternal age at birth is 26. 
tmp[[i]]$cmage<-tmp[[i]]$mage-26
tmp[[i]]$cmage2<-tmp[[i]]$cmage^2
#mean log income = mean(dat[[1]]$lninc[which(dat[[1]]$lninc!=0)],) = 11.16733
tmp[[i]]$inc2<-ifelse(tmp[[i]]$lninc==0, 11.16733, tmp[[i]]$lninc)
tmp[[i]]$cinc<-tmp[[i]]$inc2 - 11.16733
tmp[[i]]$nonzeroinc<-ifelse(tmp[[i]]$lninc==0, 0, 1)
tmp[[i]]$meducat<-tmp[[i]]$meducat - 1
tmp[[i]]$racecat<-tmp[[i]]$racecat - 1
  }

keep<-c("SampleID", "meducat", "moth", "fath", "Id2", 
  	"urbancat", "suburb", "age_cent", "CH33", "imgen", 
		"SEXF", "d_mdddys12_NIMH2", "pc_psych_minor", "d_anxiety12_NIMH2", "d_mood12_NIMH2","any", "internal", "pc_pa_minor", "pc_pa_severe", "pp_pa_minor", "pp_pa_severe",
        "cp_CdOddh12_NIMH2", "cinc", "nonzeroinc",
        "racecat",  "tertscore", "score", "str", "secu", "final_weight", "region", "cmage", "cmage2")
for(i in 1:100){
dat[[i]]<-tmp[[i]][keep]}

setwd("/Users/kararudolph/Documents/JHSPHpostdoc/measurementErrorImputation")
agestuff<-read.csv("ncsaage.csv", header=TRUE)
agestuff$m_mAge<-ifelse(!is.na(agestuff$S1_101) & agestuff$S1_101==1, agestuff$p_mAge, NA)

agetomerge<-agestuff[,c("sampleID", "c_mAge", "m_mAge")]
colnames(agetomerge)<-c("SampleID", "cmatAge", "mmatAge")

setwd("/Users/kararudolph/Documents/PhD/NIMH/NCSA/cortisol")
two<- read.csv("confound2.csv", header = TRUE)

data1<-merge(dat[[1]],  agetomerge, by="SampleID", all.x=TRUE, all.y=FALSE)
data<-merge(data1, two, by="SampleID", all.x=TRUE, all.y=FALSE)
data$cmatAge<-ifelse(data$cmatAge>100 | data$cmatAge<13, NA, data$cmatAge)
data$mmatAge<-ifelse(data$mmatAge>97, NA, data$mmatAge)
validation<-data[!is.na(data$cmatAge)&!is.na(data$mmatAge),]
plot(validation$cmatAge[!is.na(validation$mmatAge)], validation$mmatAge[!is.na(validation$mmatAge)])
cor(validation$cmatAge, validation$mmatAge)
var(validation$cmatAge)
var(validation$mmatAge)

validation$measerror<-validation$cmatAge-validation$mmatAge
summary(validation$measerror[validation$tertscore==1])
summary(validation$measerror[validation$tertscore==0])

ddply(validation, .(tertscore), summarise, 
	varme=var(measerror, na.rm=TRUE), 
	sdme=sd(measerror, na.rm=TRUE), 
	mean=mean(measerror, na.rm=TRUE))

##add measurement error to cmatAge
datacomp<-data[!is.na(data$cmatAge),]
datacomp$cmatAgeworse<-rnorm(nrow(datacomp), mean=datacomp$cmatAge, sd=5)
validationcomp<-datacomp[!is.na(datacomp$mmatAge),]
cor(validationcomp$cmatAgeworse, validationcomp$mmatAge)
#.705
datacomp$cmatAgeevenworse<-rnorm(nrow(datacomp), mean=datacomp$cmatAge, sd=12)
validationcomp<-datacomp[!is.na(datacomp$mmatAge),]
cor(validationcomp$cmatAgeevenworse, validationcomp$mmatAge)

plot(validationcomp$mmatAge, validationcomp$cmatAge, xlab="Mother-reported, years", ylab="Adolescent-reported, years")
abline(0,1)