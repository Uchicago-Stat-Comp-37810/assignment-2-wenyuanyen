trueA <- 5
trueB <- 0
trueSd <- 10
sampleSize <- 31

# create independent x-values 
x <- (-(sampleSize-1)/2):((sampleSize-1)/2)
# create dependent values according to ax + b + N(0,sd)
y <-  trueA * x + trueB + rnorm(n=sampleSize,mean=0,sd=trueSd)

plot(x,y, main="Test Data")

setwd('~/Desktop')
source('MH algorithm (functions).R')

slopelikelihoods <- lapply(seq(3, 7, by=.05), slopevalues )
plot (seq(3, 7, by=.05), slopelikelihoods , type="l", xlab = "values of slope parameter a", ylab = "Log likelihood")

######## Metropolis algorithm ################
startvalue = c(4,0,10)
chain = run_metropolis_MCMC(startvalue, 10000)

burnIn = 5000
acceptance = 1-mean(duplicated(chain[-(1:burnIn),]))

### Summary: #######################

summary_mcmc(chain, burnIn, trueA, trueB, trueSd)

# for comparison:
summary(lm(y~x))

### Test compare_outcomes function for 1000,10000,100000
n <- 10^seq(3,5)
compare_outcomes(n)
## Solutions are
## MCMC.iterations     Mean Std.Error
#1           1e+03 4.817297 0.6526214
#2           1e+04 4.999467 0.2834009
#3           1e+05 5.004784 0.2190319

### Loop 10 times compare_outcomes function
m <- seq(1000,100000,length = 10)
compare_outcomes(m)

#   MCMC.iterations     Mean Std.Error
#1             1000 4.578495 0.8490063
#2            12000 5.013927 0.2232360
#3            23000 5.024772 0.3368471
#4            34000 5.004579 0.2173755
#5            45000 5.012142 0.2264606
#6            56000 5.015311 0.2676614
#7            67000 4.995680 0.2661762
#8            78000 5.009395 0.2282833
#9            89000 5.003853 0.2248064
#10          100000 5.005646 0.2248295
