#' @title Tabulate Stopping Rule (Binary Data)
#' @description Summarize a stopping rule in a condensed tabular format
#'
#' @param x A \code{rule.bin} object calculated by \code{calc.rule.bin()} function
#'
#' @return A matrix with two columns: the ranges of evaluable patients, and corresponding rejection boundaries for these ranges
#' @export
#'
#' @examples
#' # Binomial Pocock test in 50 patient cohort at 10% level, expected toxicity probability of 20%
#' poc_rule = calc.rule.bin(ns=1:50,p0=0.20,alpha=0.10,type="Pocock")
#'
#' # Tabulate stopping boundary
#' table.rule.bin(poc_rule)

table.rule.bin = function(x) {
  rule = x$Rule
  n = max(rule[,1])
  idx = NULL
  rule = rule[rule[,2]<=rule[,1],]
  # Find rows where rejection can happen
  bdry = unique(rule[,2])
  for(i in 1:length(bdry)){
    idx[i] = which(rule[,2]==bdry[i])[1]
  }
  rule = rule[idx,]

  k = nrow(rule)
  n_eval = rep(0,k)
  n_eval[-k] = paste(rule[-k,1],"-",rule[-1,1]-1)
  if((rule[2,1] - rule[1,1]) == 1) {n_eval[1] = rule[1,1]}
  if(rule[k,1] < n) {
    n_eval[k] = paste(rule[k,1],"-",n)
  }
  else {n_eval[k] = n}

  val = cbind(n_eval,rule[,2])
  colnames(val) = c("N Evaluable","Reject Bdry")

  return(val)
}
