SVM <- function() 
{
  library(R.matlab)
  library(e1071)
  data <- R.matlab::readMat("ss.mat")$ML
  
  X.train <- data.frame(data[,,1]$train[1])
  X.train <- cbind(X.train, data[,,1]$train[2])
  colnames(X.train)[ncol(X.train)] <- "Status"
  X.train$Status <- factor(X.train$Status, levels = c(0,1))
  
  model <- svm(x = X.train[,-ncol(X.train)], y = X.train$Status, kernel = "linear", type = "C-classification", probability = 1)
}

path <- paste("C:/Users/", Sys.info()["user"], "/Repositories/mestrado/src/data", sep = "")
setwd(path)
msgs <- capture.output(suppressWarnings(suppressMessages(SVM())))