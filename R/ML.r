library(R.matlab)
library(caret)
library(pROC)

setwd("C:/Users/Caio Tavares/Repositories/mestrado/Spectrum Sensing/R")

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

MLP <- caret::train(X.train[,-ncol(X.train)], X.train$Status, 
                    trControl = trainControl(method = "cv", number = 10), method = "mlp", tuneLength = 1)
prediction <- predict(MLP$finalModel, X.test[,-ncol(X.test)])

threshold <- (1000:1)/1000
Pd <- c()
Pfa <- c()
index <- 1
for(t in threshold)
{
  result <- factor((prediction[,2]>=t)*1,levels = c(0,1))
  confMatrix <- table(actual = X.test$Status, predicted = result)
  Pd[index] <- confMatrix[2,2]/sum(X.test$Status==1)
  Pfa[index] <- confMatrix[1,2]/sum(X.test$Status==0)
  index <- index+1
}
writeMat(Pd = Pd, Pfa = Pfa, con = "../MLP.mat")