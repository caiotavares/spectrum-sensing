MLP <- function ()
{
  library(R.matlab)
  library(RSNNS)
  data <- R.matlab::readMat("ss.mat")$ML
  
  X.train <- data.frame(data[,,1]$train[1])
  X.train <- cbind(X.train, data[,,1]$train[2])
  colnames(X.train)[ncol(X.train)] <- "Status"
  X.train$Status <- factor(X.train$Status, levels = c(0,1))
  
  X.test <- data.frame(data[,,1]$test[1])
  X.test <- cbind(X.test, data[,,1]$test[2])
  colnames(X.test)[ncol(X.test)] <- "Status"
  X.test$Status <- factor(X.test$Status, levels = c(0,1))
  
  model <- RSNNS::mlp(X.train[, -ncol(X.train)], RSNNS::decodeClassLabels(X.train$Status), size = 3)
  P_mlp <- predict(model, X.test[,-ncol(X.test)])
  R.matlab::writeMat(P = P_mlp, con = "MLP.mat")
  
  # MLP <- caret::train(X.train[,-ncol(X.train)], X.train$Status, 
  #                     trControl = trainControl(method = "cv", number = 10), method = "mlp", tuneLength = 1)
  # prediction.MLP <- predict(MLP$finalModel, X.test[,-ncol(X.test)])
  # R.matlab::writeMat(P_mlp = prediction.MLP, A_mlp = X.test$Status==1, con = "../data/MLP.mat")
}

path <- paste("C:/Users/", Sys.info()["user"], "/Repositories/mestrado/Spectrum Sensing/data", sep = "")
setwd(path)
msgs <- capture.output(suppressWarnings(suppressMessages(MLP())))
