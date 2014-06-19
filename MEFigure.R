## Figure for 
expit<-function(p){
  exp(p)/(1+exp(p))
}
logit<-function(p){
  log(p/(1-p))
}

set.seed(123789)
n<-1000

# z is a coefficient measured without error
z<-rnorm(n, 1, 1)
# x is a coefficient measured with error
x<-rnorm(n, 1+ (.2*z), 1)

# the treatment depends on both x and z
beta0<- -2*log(2)
beta1<-log(2)
beta2<-log(2)
t<-rbinom(n, 1, prob=expit(beta0 + beta1*z + beta2*x))
probt<-expit(beta0 + beta1*z + beta2*x)
# y is the outcome variable
psi0<-0
psi1<-3
psi2<-2
psi3<-2
meany<-psi0 + psi1*t + psi2*x + psi3*z
y<- rnorm(n, meany, 1)

# w is the mismeasured x. it is measured differentially by treatment.
delta0<-0.5 #measurement error in control group
delta1<-1 #extra measurement error in tx group
mevar<-delta0*(1+(delta1*t))^2
gamma0<-0
gamma1<-1
gamma2<- 2
gamma3<- 0
meanw<-gamma0 + gamma1*x + gamma2*t + gamma3*t*x
w<-rnorm(n, meanw, sqrt(mevar))

me<-data.frame(z,x,as.factor(as.character(t)),w, y, probt, probw)
colnames(me)<-c("Z", "X", "Treatment", "W", "Y", "PSX", "PSW")
ggplot(me, aes(x=x, y=w, colour=t)) + geom_point(shape=1) + geom_abline(intercept=0, slope=1))
