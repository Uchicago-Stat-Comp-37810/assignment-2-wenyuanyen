trueA <- 5
trueB <- 0
trueSd <- 10
sampleSize <- 31

# create independent x-values 
x <- (-(sampleSize-1)/2):((sampleSize-1)/2)
# create dependent values according to ax + b + N(0,sd)
y <-  trueA * x + trueB + rnorm(n=sampleSize,mean=0,sd=trueSd)

plot(x,y, main="Test Data")



likelihood <- function(param){
  a = param[1]
  b = param[2]
  sd = param[3]
  
  pred = a*x + b
  singlelikelihoods = dnorm(y, mean = pred, sd = sd, log = T)
  sumll = sum(singlelikelihoods)
  return(sumll)   
}

# Example: plot the likelihood profile of the slope a
slopevalues <- function(x){return(likelihood(c(x, trueB, trueSd)))}
slopelikelihoods <- lapply(seq(3, 7, by=.05), slopevalues )
plot (seq(3, 7, by=.05), slopelikelihoods , type="l", xlab = "values of slope parameter a", ylab = "Log likelihood")

prior <- function(param){
  a = param[1]
  b = param[2]
  sd = param[3]
  aprior = dunif(a, min=0, max=10, log = T)
  bprior = dnorm(b, sd = 5, log = T)
  sdprior = dunif(sd, min=0, max=30, log = T)
  return(aprior+bprior+sdprior)
}

posterior <- function(param){
  return (likelihood(param) + prior(param))
}


######## Metropolis algorithm ################

proposalfunction <- function(param){
  return(rnorm(3,mean = param, sd= c(0.1,0.5,0.3)))
}

run_metropolis_MCMC <- function(startvalue, iterations){
  chain = array(dim = c(iterations+1,3))
  chain[1,] = startvalue
  for (i in 1:iterations){
    proposal = proposalfunction(chain[i,])
    
    probab = exp(posterior(proposal) - posterior(chain[i,]))
    if (runif(1) < probab){
      chain[i+1,] = proposal
    }else{
      chain[i+1,] = chain[i,]
    }
  }
  return(chain)
}

startvalue = c(4,0,10)
chain = run_metropolis_MCMC(startvalue, 10000)

burnIn = 5000
acceptance = 1-mean(duplicated(chain[-(1:burnIn),]))

### Summary: #######################

summary_mcmc <- function(matrix, k, A, B, Sd){
  par(mfrow = c(2,3))
  hist(matrix[-(1:k),1],nclass=30, main="Posterior of a", xlab="True value = red line")
  abline(v = mean(matrix[-(1:k),1]))
  abline(v = A, col="red" )
  hist(matrix[-(1:k),2],nclass=30, main="Posterior of b", xlab="True value = red line")
  abline(v = mean(matrix[-(1:k),2]))
  abline(v = B, col="red" )
  hist(matrix[-(1:k),3],nclass=30, main="Posterior of sd", xlab="True value = red line")
  abline(v = mean(matrix[-(1:k),3]) )
  abline(v = Sd, col="red" )
  plot(matrix[-(1:k),1], type = "l", xlab="True value = red line" , main = "Chain values of a")
  abline(h = A, col="red" )
  plot(matrix[-(1:k),2], type = "l", xlab="True value = red line" , main = "Chain values of b")
  abline(h = B, col="red" )
  plot(matrix[-(1:k),3], type = "l", xlab="True value = red line" , main = "Chain values of sd")
  abline(h = Sd, col="red" )
  }

summary_mcmc(chain, burnIn, trueA, trueB, trueSd)

# for comparison:
summary(lm(y~x))

