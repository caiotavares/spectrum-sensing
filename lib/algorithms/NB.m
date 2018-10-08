function NB = NB(train, test)

NB.model = fitcnb(train.X,train.Y);
[~,NB.P,~] = predict(NB.model,test.X);
NB.positiveClass = 2;
NB.name = 'Naive Bayes';
