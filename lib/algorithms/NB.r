NB <- function() 
{
  library(R.matlab)
  data <- R.matlab::readMat("ss.mat")$ML
  
  X.train <- data.frame(data[,,1]$train[1])
  X.train <- cbind(X.train, data[,,1]$train[2])
  colnames(X.train)[ncol(X.train)] <- "Status"
  X.train$Status <- factor(X.train$Status, levels = c(0,1))
  
  model <- naiveBayes(x = X.train[, -ncol(X.train)], y = X.train$Status, laplace = 0, type = "raw")
}

cur_dir <- getwd()
path <- paste(cur_dir, "/data", sep = "")
setwd(path)
msgs <- capture.output(suppressWarnings(suppressMessages(NB())))