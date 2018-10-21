trueA <- 5   # true slope
trueB <- 0   # true intercept
trueSd <- 10 # true error term std
sampleSize <- 31 #  number of realized data points

# create independent x-values: from -15 to 15
x <- (-(sampleSize-1)/2):((sampleSize-1)/2)
# create dependent values according to ax + b + N(0,sd)
y <-  trueA * x + trueB + rnorm(n=sampleSize,mean=0,sd=trueSd)

# plot the realized test data
plot(x,y, main="Test Data")


# define a function "likelihood", where input is a 3-dimension vector
likelihood <- function(param){
  a = param[1]   # 1st is slope
  b = param[2]   # 2nd is intercept
  sd = param[3]  # 3rd is error's std
  
  pred = a*x + b   # a vector of fitted response ys'
  
  # a vector of fitted response ys' log-likelihood
  singlelikelihoods = dnorm(y, mean = pred, sd = sd, log = T) 
  
  # sum of that vector of log-likelihood, assuming independence
  sumll = sum(singlelikelihoods)
  return(sumll)   # return the full test data log-likelihood(a scalar)
}

# Example: plot the likelihood profile of the slope a
slopevalues <- function(x){return(likelihood(c(x, trueB, trueSd)))} # fix the intercept, error std in the true, and test data
slopelikelihoods <- lapply(seq(3, 7, by=.05), slopevalues ) # return a list of log-like, w.r.t. a vector of slopes
# plot the slopes and the corresponding log-likelihoods
plot (seq(3, 7, by=.05), slopelikelihoods , type="l", xlab = "values of slope parameter a", ylab = "Log likelihood") 

# define a function "prior", where input is a 3-dimension vector
prior <- function(param){
  a = param[1]   # 1st is slope
  b = param[2]   # 2nd is intercept
  sd = param[3]  # 3rd is error's std
  
  aprior = dunif(a, min=0, max=10, log = T) # log-probability of a given slope from Uni(0,10)
  bprior = dnorm(b, sd = 5, log = T) # log-probability of a given intercept from N(0, 25)
  sdprior = dunif(sd, min=0, max=30, log = T) # log-probability of a given error std from Uni(0, 30)
  
  # assuming independence of prior parameters, return their joint log-probability
  return(aprior+bprior+sdprior)
}

# define a function "posterior", where input is a 3-dimension vector
posterior <- function(param){
  return (likelihood(param) + prior(param)) # since f(param)f(data | param) prop to f(param | data)
}


######## Metropolis algorithm ################

# define a function "proposalfunction", given a 3-dimension vector parameter
proposalfunction <- function(param){
  
  # sample 3 independent normals from N(param[1], 0.01), N(param[2], 0.25), N(param[3], 0.09), respectively
  return(rnorm(3,mean = param, sd= c(0.1,0.5,0.3)))  
}

# define a function "run_metropolis_MCMC", where inputs are 3-dim vector of parameters, and # of iterations of MCMC
run_metropolis_MCMC <- function(startvalue, iterations){
  chain = array(dim = c(iterations+1,3)) # create a iterations+1 by 3 matrix
  chain[1,] = startvalue # the first row is the starting vlaue
  for (i in 1:iterations){  
    proposal = proposalfunction(chain[i,]) # proposal parameters at current values, which are in the previous row
    
    # posterior probability ratio  at proposal parameters versus at current parametrs (not log scale)
    probab = exp(posterior(proposal) - posterior(chain[i,])) 
    if (runif(1) < probab){  # sample from a uni(0,1). If it is smaller than that ratio, 
      chain[i+1,] = proposal  # then fill in the current row the proposal parameters
    }else{
      chain[i+1,] = chain[i,]  # Otherwise, fill in the current row the current parameters
    }
  }
  return(chain)
}

startvalue = c(4,0,10) # let initial start be: slope = 4, intercept = 0, error std = 10
chain = run_metropolis_MCMC(startvalue, 10000) # run 10000 times, and save the chain 

burnIn = 5000 # throw out the first 5000 rows of chain


# compute the proportion of unique values in burned-in chain
acceptance = 1-mean(duplicated(chain[-(1:burnIn),]))

### Summary: #######################

par(mfrow = c(2,3)) # frame the graphes to be determined in 2 by 3

# plot a histogram of the 1st column of chain, which is slopes, with 30 bins.
hist(chain[-(1:burnIn),1],nclass=30, , main="Posterior of a", xlab="True value = red line" )
# superimpose a black vertical line indicating mean of 1st column
abline(v = mean(chain[-(1:burnIn),1]))
# superimpose a red vertical line indicating the true value of the slope
abline(v = trueA, col="red" )

# plot a histogram of the 2nd column of chain, which is intercepts, with 30 bins.
hist(chain[-(1:burnIn),2],nclass=30, main="Posterior of b", xlab="True value = red line")
# superimpose a black vertical line indicating mean of 2nd column
abline(v = mean(chain[-(1:burnIn),2]))
# superimpose a red vertical line indicating the true value of the intercept
abline(v = trueB, col="red" )

# plot a histogram of the 3rd column of chain, which is error std's, with 30 bins.
hist(chain[-(1:burnIn),3],nclass=30, main="Posterior of sd", xlab="True value = red line")
# superimpose a black vertical line indicating mean of 3rd column
abline(v = mean(chain[-(1:burnIn),3]) )
# superimpose a red vertical line indicating the true value of the error std
abline(v = trueSd, col="red" )

# plot a series of the 1st column of chain after burning-in the first 5000.
plot(chain[-(1:burnIn),1], type = "l", xlab="True value = red line" , main = "Chain values of a")
# superimpose a red horizontal line indicating the true value of the slope
abline(h = trueA, col="red" )

# plot a series of the 2nd column of chain after burning-in the first 5000.
plot(chain[-(1:burnIn),2], type = "l", xlab="True value = red line" , main = "Chain values of b")
# superimpose a red horizontal line indicating the true value of the intercept
abline(h = trueB, col="red" )

# plot a series of the 3rd column of chain after burning-in the first 5000.
plot(chain[-(1:burnIn),3], type = "l", xlab="True value = red line" , main = "Chain values of sd")
# superimpose a red horizontal line indicating the true value of the error std
abline(h = trueSd, col="red" )

# for comparison:
summary(lm(y~x))  # OLS of test data

