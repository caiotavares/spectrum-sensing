MLP <- function (training)
{
  library(R.matlab)
  library(RSNNS)
  data <- R.matlab::readMat("../../data/ss.mat")
  X <- data.frame(cbind(data$X,data$A))
  colnames(X)[ncol(X)] <- "Status"
  X$Status <- factor(X$Status, levels = c(0,1))
  
  X.train.len <- round(training*nrow(X))
  X.train <-  X[1:X.train.len,]
  X.test <- X[(X.train.len+1):nrow(X),]
  
  model <- RSNNS::mlp(X.train[, -ncol(X.train)], RSNNS::decodeClassLabels(X.train$Status), size = 3)
  P_mlp <- predict(model, X.test[,-ncol(X.test)])
  R.matlab::writeMat(P = P_mlp, A = X.test$Status==1, con = "../../data/MLP.mat")
  
  # MLP <- caret::train(X.train[,-ncol(X.train)], X.train$Status, 
  #                     trControl = trainControl(method = "cv", number = 10), method = "mlp", tuneLength = 1)
  # prediction.MLP <- predict(MLP$finalModel, X.test[,-ncol(X.test)])
  # R.matlab::writeMat(P_mlp = prediction.MLP, A_mlp = X.test$Status==1, con = "../data/MLP.mat")
}

path <- paste("C:/Users/", Sys.info()["user"], "/Repositories/mestrado/Spectrum Sensing/lib/R", sep = "")
setwd(path)
args = commandArgs(trailingOnly=TRUE)

if (length(args)==0)
{
  stop("Missing argument.")
}
trainingPercent =  as.double(args[1])

source("utils.r")

msgs <- capture.output(suppressWarnings(suppressMessages(MLP(trainingPercent))))

