function P = MLP(X, model, inputs)

outputs = 2;
S = model.activationFunc;
hiddenUnits = size(model.W_hidden,2);
bias_H = model.bias((inputs+1):(2*inputs))';
bias_O = model.bias((inputs+hiddenUnits+1):(inputs+hiddenUnits+outputs))';

H = S((X*model.W_hidden)+bias_H);
P = S((H*model.W_output)+bias_O);