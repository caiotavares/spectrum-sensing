library(R.matlab)
library(caret)

accuracy <- function(confusion)
{
  return(sum(diag(confusion))/sum(confusion))
}

data <- R.matlab::readMat("../data/ss.mat")
X <- data.frame(cbind(data$X,data$A))
colnames(X)[ncol(X)] <- "Status"
X$Status <- factor(X$Status, levels = c(0,1))

training <- 0.7
X.train.len <- round(training*nrow(X))
X.train <-  X[1:X.train.len,]
X.test <- X[(X.train.len+1):nrow(X),]

MLP <- caret::train(X.train[,-ncol(X.train)], X.train$Status, 
                    trControl = trainControl(method = "cv", number = 10), method = "mlp", tuneLength = 1)
prediction.MLP <- predict(MLP$finalModel, X.test[,-ncol(X.test)])

R.matlab::writeMat(P_mlp = prediction.MLP, A_mlp = X.test$Status==1, con = "../data/MLP.mat")