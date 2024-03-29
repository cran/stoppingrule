#' @title Stopping Boundary Calculation (Binary Data)
#' @description Internal workhorse function to calculate stopping boundary for a given method, treating toxicities as binary data
#'
#' @param n Maximum sample size for safety monitoring
#' @param p0 The toxicity probability under the null hypothesis
#' @param type The method used for constructing the stopping rule
#' @param cval Critical value for stopping rule method. For Wang-Tsiatis tests, this is the Delta parameter. For the Bayesian Beta-Binomial method, this is the threshold on the posterior probability. For the truncated SPRT, this is the threshold on the log likelihood ratio. For the MaxSPRT, this is the threshold on the log generalized likelihood ratio.
#' @param param A vector of the extra parameter(s) needed for certain stopping rule methods. For binomial Wang-Tsiatis tests, this is the Delta parameter. For the Geller et al. method, this is the vector of hyperparameters (a,b) for the beta prior on the toxicity probability. For Chen and Chaloner's method, this is the vector (a,b,p1,nu), containing the hyperparameters (a,b) for the beta prior on the toxicity probability, the targeted alternative toxicity probability p1, and the threshold nu for the posterior probability that the true toxicity probability p > p1. For truncated SPRT, this is the targeted alternative toxicity probability p1.
#'
#' @return A vector of stopping boundaries at the sample sizes 1, 2, ..., n

calc.bnd.bin = function(n,p0,type,cval,param) {
  bs = NULL
  if(type!="CC") {
    if(type=="Pocock") {f = bdryfcn.bin(n,p0,type,1-cval,param)}
    else {f = bdryfcn.bin(n,p0,type,cval,param)}
    bs = ceiling(f(1:n))
  }
  else if(type=="CC") {
    a = param[1]
    b = param[2]
    p1 = param[3]
    nu = param[4]
    postprob0 = postprob1 = matrix(0,nrow=n,ncol=n+1)
    for(j in 1:n) {
      postprob0[j,1:(j+1)] = pbeta(p0,a+0:j,b+j:0,lower.tail=FALSE)
      postprob1[j,1:(j+1)] = pbeta(p1,a+0:j,b+j:0,lower.tail=FALSE)
      if(max(postprob0[j,]) > cval & max(postprob1[j,]) > nu) {
        bs[j] = which(postprob0[j,] > cval & postprob1[j,] > nu)[1]-1
      }
      else {bs[j] = j+1}
    }
  }
  return(bs)
}
