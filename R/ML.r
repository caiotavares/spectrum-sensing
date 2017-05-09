library(caret)

accuracy <- function(confusion)
{
  return(sum(diag(confusion))/sum(confusion))
}

X <- R.matlab::readMat("ss.mat")$exportX
X <- data.frame(X)
colnames(X) <- c("SU1", "SU2", "SU3","SU4","Status")
X$Status <- factor(X$Status, levels = c(0,1))

training <- 0.7
X.train.len <- round(training*nrow(X))

X.train <-  X[1:X.train.len,]
X.test <- X[(X.train.len+1):nrow(X),]

MLP <- caret::train(X.train[,-ncol(X.train)], X.train$Status, trControl = trainControl(method = "cv", number = 10), 
             method = "mlp", tuneLength = 1)

result <- predict(MLP$finalModel, X.test[,-ncol(X.test)])
# The max.col methods can be replaced in order to control the Pfa/Pd trade-off
result <- matrix(max.col(result, ties.method = "first")-1, ncol = 1)
confMatrix <- table(actual = X.test$Status, predicted = result)
MLP.accuracy = accuracy(confMatrix)