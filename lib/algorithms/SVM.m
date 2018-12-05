function SVM = SVM(train, test, kernel)

scoreModel = fitcsvm(train.X,train.Y,'KernelFunction', kernel);
SVM.model = fitPosterior(scoreModel); % Transforms score to posterior probability
[~,SVM.P] = predict(SVM.model,test.X);
SVM.positiveClass = 2;
SVM.name = 'SVM';
