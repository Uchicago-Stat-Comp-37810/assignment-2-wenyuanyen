trueA <- 5
trueB <- 0
trueSd <- 10
sampleSize <- 31
set.seed(1)

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
compare_outcomes(n, 0.5)

## Solutions are
## MCMC.iterations     Mean Std.Error
#1           1e+03 5.032702 0.1624983
#2           1e+04 4.968373 0.2032423
#3           1e+05 4.972852 0.2083943

### Loop 10 times compare_outcomes function
m <- seq(1000,100000,length = 10)
compare_outcomes(m, 0.5)

#   MCMC.iterations     Mean Std.Error
#1             1000 5.019288 0.1939780
#2            12000 4.975565 0.1870400
#3            23000 4.981208 0.2024805
#4            34000 4.972683 0.2041796
#5            45000 4.983221 0.2066155
#6            56000 4.965214 0.1976723
#7            67000 4.967183 0.2044790
#8            78000 4.963924 0.2018631
#9            89000 4.968850 0.2003716
#10          100000 4.977272 0.2014431
