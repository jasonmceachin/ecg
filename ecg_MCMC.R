proposal_sd <- 0.5 #assume same for alpha_curr, beta, delta_curr, DC (the paper did not specify proposal standard deviation ie stepsize)

# prior pdf for all model parameters (used gamma(0.01,0.01) for uninformative prior)
prior_lpdf <- function(theta){
  lpdf <- dnorm(theta, proposal_sd, log = T)
  return(lpdf)
}


# likelihood pdf for all model parameters 
likelihood_lpdf <- function(y, mean, tao){
  lpdf <- 0
  K <- length(y)
  for(k in 1:K){
    #print(c("k", k))
    #print(c("MEAN", mean[k]))
    #print(c("y", y[k]))
    #print(c("DNORM", dnorm(y[k], mean = mean[k], sd = 1 / sqrt(tao), log = T)))
    lpdf <- lpdf + dnorm(y[k], mean = mean[k], sd = 1 / sqrt(tao), log = T)
    #print(lpdf)
  }
  return(lpdf)
}

# this function calculates the new miu based on the updated theta, theta_star
gen_miu_star <- function(t, alpha_curr, beta_curr, delta_curr) {
  miu_star <- rep(0, length(y))
  for (i in 1:length(t)){
    if (0 < t[i] && t[i] < delta_curr[1]) {
      miu_star[i] <- alpha_curr[1] * cos(pi * t[i] / delta_curr[1]) + beta_curr
    }
    
    
    if (delta_curr[1] < t[i] && t[i] < delta_curr[2]) {
      miu_star[i] <- alpha_curr[2] * (1 - cos(pi * (t[i] - delta_curr[1]) / (delta_curr[2]-delta_curr[1]))) + beta_curr - alpha_curr[1]
    }
    
    
    if (delta_curr[2] < t[i] && t[i] < delta_curr[3]) {
      miu_star[i] <- alpha_curr[3] * (1 - cos(pi * (t[i] - delta_curr[2]) / (delta_curr[3]-delta_curr[2]))) + beta_curr - alpha_curr[1] + 2 * alpha_curr[2]
    }
    
    
    if (delta_curr[3] < t[i] && t[i] < delta_curr[4]) {
      miu_star[i] <- 0.5 * (beta_curr - alpha_curr[1] + 2 * alpha_curr[2] + 2 * alpha_curr[3]) * (1 + cos(pi * (t[i] - delta_curr[3]) / (delta_curr[4]-delta_curr[3])))
    }
    
    if (delta_curr[4] < t[i] && t[i] < delta_curr[5]) {
      miu_star[i] <- 0
    }
    
    if (delta_curr[5] < t[i] && t[i]< delta_curr[6]) {
      miu_star[i] <- alpha_curr[4] * (1 - cos(pi * (t[i] - delta_curr[5]) / (delta_curr[6]-delta_curr[5]))) 
    }
    
    
    if (delta_curr[6] < t[i] && t[i] < delta_curr[7]) {
      miu_star[i] <- alpha_curr[4] * (1 + cos(pi * (t[i] - delta_curr[6]) / (delta_curr[7]-delta_curr[6]))) 
    }
    
    
    if (delta_curr[7] < t[i] && t[i] < delta_curr[8]) {
      miu_star[i] <- alpha_curr[5] * (cos(pi * (t[i] - delta_curr[7]) / (delta_curr[8] - delta_curr[7])) - 1) 
    }
    
    
    if (delta_curr[8] < t[i] && t[i] < delta_curr[9]) {
      miu_star[i] <- alpha_curr[6] * (1 - cos(pi * (t[i] - delta_curr[8]) / (delta_curr[9] - delta_curr[8]))) - 2 * alpha_curr[5]
    }
    
    
    if (delta_curr[9] < t[i] && t[i] < delta_curr[10]) {
      miu_star[i] <- alpha_curr[7] * (cos(pi * (t[i] - delta_curr[9]) / (delta_curr[10] - delta_curr[9])) - 1)  + 2 * alpha_curr[6] - 2 * alpha_curr[5]
    }
    
    
    if (delta_curr[10] < t[i] && t[i] < delta_curr[11]) {
      miu_star[i] <- alpha_curr[8] * (1 - cos(pi * (t[i] - delta_curr[10]) / (delta_curr[11] - delta_curr[10]))) - 2 * alpha_curr[7] + 2 * alpha_curr[6] - 2 * alpha_curr[5]
    }
    
    if (delta_curr[11] < t[i] && t[i] < delta_curr[12]) {
      miu_star[i] <- alpha_curr[9] * (1 - cos(pi * (t[i] - delta_curr[11]) / (delta_curr[12] - delta_curr[11]))) + 2 * alpha_curr[8] - alpha_curr[7] + 2 * alpha_curr[6] - 2 * alpha_curr[5]
    }
    
    
    if (delta_curr[12] < t[i] && t[i] < delta_curr[13]) {
      miu_star[i] <- (alpha_curr[9] + alpha_curr[8] - alpha_curr[7] + alpha_curr[6] - alpha_curr[5]) * (1 + cos(pi * (t[i] - delta_curr[12]) / (delta_curr[13] - delta_curr[12])))
    }
    
    
    if (delta_curr[13] < t[i] && t[i] < delta_curr[14]) {
      miu_star[i] <- (alpha_curr[9] + alpha_curr[8] - alpha_curr[7] + alpha_curr[6] - alpha_curr[5]) * (1 + cos(pi * (t[i] - delta_curr[12]) / (delta_curr[13] - delta_curr[12])))
    } 
    
    
    if (delta_curr[14] < t[i] && t[i] < delta_curr[15]) {
      miu_star[i] <- 0
    } 
    
    
    if (delta_curr[14] < t[i] && t[i] < delta_curr[15]) {
      miu_star[i] <- alpha_curr[10] * (1 - cos(pi * (t[i] - delta_curr[14]) / (delta_curr[15] - delta_curr[14])))
    } 
    
    
    if (delta_curr[15] < t[i] && t[i] < delta_curr[16]) {
      miu_star[i] <- alpha_curr[10] * (1 + cos(pi * (t[i] - delta_curr[15]) / (delta_curr[16] - delta_curr[15])))
    } 
    
    
    if (delta_curr[16] < t[i] && t[i] < delta_curr[17]) {
      miu_star[i] <- alpha_curr[11] * (cos(pi * (t[i] - delta_curr[16]) / (delta_curr[17] - delta_curr[16])) - 1)
    } 
    
    
    if (delta_curr[17] < t[i] && t[i] < end_time) {
      miu_star[i] <- alpha_curr[12] * (1 - cos(pi * (t[i] - delta_curr[17]) / (end_time - delta_curr[17]))) - 2 * alpha_curr[11]
    } 
  }
  
  return (miu_star)
}

#function for generating samples for beta

beta_one_samp <- function(beta_curr, BETA, s) { 
  #generate candidate value
  beta_star <- rnorm(1, beta_curr, proposal_sd)
  
  #
  miu_star <- gen_miu_star(t, alpha_curr = alpha_curr, beta_curr = beta_star, delta_curr = delta_curr)
  
  #
  mean_star <- miu_star + dc_curr 
  
  #
  r <- exp(likelihood_lpdf(y, mean_star, tao_curr) - likelihood_lpdf(y, mean_curr, tao_curr) + prior_lpdf(beta_star) - prior_lpdf(beta_curr))
  
  #print(r)  
  if(runif(1) < r){
    beta_curr <- beta_star
  }
  BETA <- c(BETA, beta_curr)
  return (list(beta_curr, BETA))
}


#function for generating samples for alphai

alpha_one_samp <- function(i, alpha_i_curr, ALPHA_i, s) { 
  #generate candidate value
  alpha_i_star <- rnorm(1, alpha_i_curr, proposal_sd)
  #print(c("ALPHA STAR: ", alpha_i_star))
  
  #
  alpha_proposed <- alpha_curr
  alpha_proposed[[k]] <- alpha_i_star #alpha_proposed is pointing to a different object than alpha_curr; no change to the list alpha_curr in the global is made
  miu_star <- gen_miu_star(t, alpha_curr = alpha_proposed, beta_curr = beta_curr, delta_curr = delta_curr)
  #print(c("MIU STAR: ", miu_star))
  
  #
  mean_star <- miu_star + dc_curr 
  #print(c("MEAN STAR: ", mean_star))
  
  #
  r <- exp(likelihood_lpdf(y, mean_star, tao_curr) - likelihood_lpdf(y, mean_curr, tao_curr) + prior_lpdf(alpha_i_star) - prior_lpdf(alpha_i_curr))
  
  #print(c("R: ", r))
  
  if(runif(1) < r){
    alpha_i_curr <- alpha_i_star
  }
  ALPHA_i <- c(ALPHA_i, alpha_i_curr)
  return (list(alpha_i_curr, ALPHA_i))
}

#function for generating samples for deltai

delta_one_samp <- function(delta_i_curr, delta_i_before, delta_i_next, DELTA_i, s) { 
  #generate candidate value
  delta_i_star <- rnorm(1, delta_i_curr, proposal_sd)
  
  #delta i proposed must be between delta i-1 and next delta i+1, if not just reject it
  if (delta_i_star > delta_i_before && delta_i_star < delta_i_next) { 
    #
    delta_proposed <- delta_curr
    delta_proposed[[k]] <- delta_i_star #delta_proposed is pointing to a different object than delta_curr; no change to the list delta_curr in the global is made
    miu_star <- gen_miu_star(t, alpha_curr = alpha_curr, beta_curr = beta_curr, delta_curr = delta_proposed)
    
    #
    mean_star <- miu_star + dc_curr 
    
    #
    r <- exp(likelihood_lpdf(y, mean_star, tao_curr) - likelihood_lpdf(y, mean_curr, tao_curr) + dunif(delta_i_star, delta_i_before, delta_i_next, log = T) - dunif(delta_i_curr, delta_i_before, delta_i_next, log = T)) 
    
    if(runif(1) < r){
      delta_i_curr <- delta_i_star
    }
  } 
  
  DELTA_i <- c(DELTA_i, delta_i_curr)
  return (list(delta_i_curr, DELTA_i))
}


#function for generating samples for tao

tao_one_samp <- function(tao_curr, TAO, s) { 
  #generate candidate value
  tao_star <- rgamma(1, 0.01, 0.01)
  
  #
  miu_star <- gen_miu_star(t, alpha_curr = alpha_curr, beta_curr = beta_curr, delta_curr = delta_curr)
  
  #
  mean_star <- miu_star + dc_curr 
  
  # note that tao in likelihood_lpdf is now tao_star
  r <- exp(likelihood_lpdf(y, mean_star, tao_star) - likelihood_lpdf(y, mean_curr, tao_curr) + dgamma(tao_star, 0.01, 0.01, log = T) - dgamma(tao_curr, 0.01, 0.01, log = T))
  print(r)
  
  if(runif(1) < r){
    tao_curr <- tao_star
  }
  TAO <- c(TAO, tao_curr)
  return (list(tao_curr, TAO))
}

tao_one_samp_cond <- function(tao_curr, TAO, s) {
  #generate candidate value
  shape_star <- 0.5 * (length(y) + 0.02)
  sum_diff <- sum( (y - mean_curr)^2 )
  rate_star <- 0.5 * (0.02 + sum_diff)
  tao_curr <- rgamma(1, shape_star, rate_star)
  TAO <- c(TAO, tao_curr)
  return (list(tao_curr, TAO))
}


#function for generating samples for DC

dc_one_samp <- function(dc_curr, DC, s) { 
  #generate candidate value
  dc_star <- rnorm(1, dc_curr, proposal_sd)
  
  #
  miu_star <- gen_miu_star(t, alpha_curr = alpha_curr, beta_curr = beta_curr, delta_curr = delta_curr)
  
  # note that dc_star is now used instead of dc_curr
  mean_star <- miu_star + dc_star 
  
  #
  r <- exp(likelihood_lpdf(y, mean_star, tao_curr) - likelihood_lpdf(y, mean_curr, tao_curr) + prior_lpdf(dc_star) - prior_lpdf(dc_curr))
  
  #print(r)  
  if(runif(1) < r){
    dc_curr <- dc_star
  }
  DC <- c(DC, dc_curr)
  return (list(dc_curr, DC))
}

#initialization
S <- 3000
proposal_sd <- 0.05 #assume same for alpha_curr, beta, delta_curr, DC for now (the paper did not specify proposal standard deviation ie stepsize)
data <- read_csv("heartbeat_data/samples_normal_sinus_rhythm/heartbeat_1.csv", col_names = FALSE)
y <- unlist(data[,2]) / 1000 #transform units back to mV because priors are not jeffrey's prior
t <- unlist(data[,1]) - unlist(data[,1])[1] #make sure that time starts from 0
beta_curr <- 1
alpha_curr <- rep(1, 12)
delta_curr<- seq(0, max(t), length.out = 17) 
end_time <- max(t)
tao_curr <- 1
mean_curr <- rep(mean(y), length(y)) 
dc_curr <- 0.5
miu_curr <- mean_curr - dc_curr

#storage

DC <- NULL
ALPHA <- rep(list(NULL), 12)
BETA <- NULL
DELTA <- rep(list(NULL), 17)
TAO <- NULL
MEAN <- rep(list(NULL), length(y))

#sampling model parameters from 1 heartbeat

for(s in 1:S) {
  print(c("s: ", s))
  
  #1 draw of Beta
  
  beta_lst <- beta_one_samp(beta_curr, BETA, s)
  beta_curr <- beta_lst[[1]]
  BETA <- beta_lst[[2]]
  #1 draw of Alphas (1-12)
  
  for (k in 1:12) {
    alpha_lst <- alpha_one_samp(k, alpha_curr[k], ALPHA[[k]], s)
    alpha_curr[k] <- alpha_lst[[1]]
    ALPHA[[k]] <- alpha_lst[[2]]
  }
  
  #1 draw of Deltas (1-17)
  
  delta_lst <- delta_one_samp(delta_curr[1], 0, delta_curr[2], DELTA[[1]], s)
  delta_curr[1] <- delta_lst[[1]]
  DELTA[[1]] <- delta_lst[[2]]
  
  for (k in 2:16) {
    delta_lst <- delta_one_samp(delta_curr[k], delta_curr[k-1], delta_curr[k+1], DELTA[[k]], s)
    delta_curr[k] <- delta_lst[[1]]
    DELTA[[k]] <- delta_lst[[2]]
  }
  
  delta_lst <- delta_one_samp(delta_curr[17], delta_curr[[16]], end_time,  DELTA[[17]], s)
  delta_curr[17] <- delta_lst[[1]]
  DELTA[[17]] <- delta_lst[[2]]
  
  #1 draw of Tao 
  tao_lst <- tao_one_samp_cond(tao_curr, TAO, s)
  tao_curr <- tao_lst[[1]]
  TAO <- tao_lst[[2]]
  
  #1 draw of DC 
  dc_lst <- dc_one_samp(dc_curr, DC, s)
  dc_curr <- dc_lst[[1]]
  DC <- dc_lst[[2]]
  
  mean_curr <- dc_curr + gen_miu_star(t, alpha_curr = alpha_curr, beta_curr = beta_curr, delta_curr = delta_curr)
  for (k in 1:length(y)) {
    MEAN[[k]] <- c(MEAN[[k]], mean_curr[[k]])
  }
  
  #print(c("MEAN CURR: ", mean_curr))
}