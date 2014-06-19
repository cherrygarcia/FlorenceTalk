expit<-function(p){
  exp(p)/(1+exp(p))
}
logit<-function(p){
  log(p/(1-p))
}

set.seed(123789)
nsims<-50

n<-1000

effects <- matrix(NA, ncol=5, nrow=nsims)
colnames(effects) <- c("ATE", "ATEW", "ATEconfound", "ATT" ,"ATTW")
ate <-att <- replicate(nsims, diag(3), simplify=FALSE)

for(i in 1:nsims){
  print(i)

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