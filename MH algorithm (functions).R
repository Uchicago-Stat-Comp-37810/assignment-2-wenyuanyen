#### likelihood
likelihood <- function(param){
  a = param[1]
  b = param[2]
  sd = param[3]
  
  pred = a*x + b
  singlelikelihoods = dnorm(y, mean = pred, sd = sd, log = T)
  sumll = sum(singlelikelihoods)
  return(sumll)   
}

#### log-likelihood of the slope
slopevalues <- function(x){return(likelihood(c(x, trueB, trueSd)))}


#### Prior distribution
prior <- function(param){
  a = param[1]
  b = param[2]
  sd = param[3]
  aprior = dunif(a, min=0, max=10, log = T)
  bprior = dnorm(b, sd = 5, log = T)
  sdprior = dunif(sd, min=0, max=30, log = T)
  return(aprior+bprior+sdprior)
}

#### Posterior distribution
posterior <- function(param){
  return (likelihood(param) + prior(param))
}

#### Proposal distribution
proposalfunction <- function(param){
  return(rnorm(3,mean = param, sd= c(0.1,0.5,0.3)))
}

#### MCMC iteration
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

#### Summary of MCMC result
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

#### compare_outcomes

# burn_perc is the percentage of burning-in in the first part of iterations
compare_outcomes <- function(iterations, burn_perc){ # a vector of the numbers of iterations
  
  mu <- c() 
  sigma<- c()
  
  for(i in seq_along(iterations)){
    p1 <- runif(1, min=0, max=10)
    p2 <- rnorm(1, mean = 0, sd = 5)
    p3 <- runif(1, min=0, max=30)
    startvalue <- c(p1,p2,p3) # randomly choose starting values from the priors
    
    # run MCMC 
    result <- run_metropolis_MCMC(startvalue, iterations[i])
    mu <- c(mu, mean(result[-c(1:(burn_perc *  iterations[i] )),1]))  # append the mean of the chain for the slopes
    sigma <- c(sigma, sqrt(var(result[-c(1:(burn_perc *  iterations[i] )),1]))) # append the std of the chain for the slopes
  }
  output <- data.frame(MCMC.iterations = iterations, Mean = mu, Std.Error = sigma)
  return(output)
}
