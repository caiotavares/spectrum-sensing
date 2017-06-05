MLP <- function ()
{
  library(R.matlab)
  library(RSNNS)
  data <- R.matlab::readMat("ss.mat")$ML
  
  X.train <- data.frame(data[,,1]$train[1])
  X.train <- cbind(X.train, data[,,1]$train[2])
  colnames(X.train)[ncol(X.train)] <- "Status"
  X.train$Status <- factor(X.train$Status, levels = c(0,1))
  
  inputs = ncol(X.train)-1
  hiddenUnits = inputs
  
  model <- RSNNS::mlp(X.train[, -ncol(X.train)], RSNNS::decodeClassLabels(X.train$Status), size = hiddenUnits, hiddenActFunc = "Act_Logistic")
  weights = weightMatrix(model)
  W_hidden <- weights[1:inputs,(inputs+1):(inputs+hiddenUnits)]
  W_output <- weights[(inputs+1):(inputs+hiddenUnits),(inputs+hiddenUnits+1):(inputs+hiddenUnits+2)]
  bias <- extractNetInfo(model)$unitDefinitions$unitBias
  R.matlab::writeMat(W_hidden = W_hidden, W_output = W_output, bias = bias, con = "MLP.mat")
}

path <- paste("C:/Users/", Sys.info()["user"], "/Repositories/mestrado/Spectrum Sensing/data", sep = "")
setwd(path)
msgs <- capture.output(suppressWarnings(suppressMessages(MLP())))
