function SVM = GSVM(train, test)

scoreModel = fitcsvm(train.X,train.Y,'KernelFunction', 'gaussian');
SVM.model = fitPosterior(scoreModel); % Transforms score to posterior probability
[~,SVM.P] = predict(SVM.model,test.X);
SVM.positiveClass = 2;
SVM.name = 'GSVM';
