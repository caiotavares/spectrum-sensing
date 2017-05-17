accuracy <- function(confusion)
{
  return(sum(diag(confusion))/sum(confusion))
}