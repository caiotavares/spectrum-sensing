function P = MLP(X, model, N)

S = model.activationFunc;
hiddenUnits = size(model.W_hidden,2);
bias_H = model.bias((N+1):(2*N))';
bias_O = model.bias((N+hiddenUnits+1):(N+hiddenUnits+2))';

H = S((X*model.W_hidden)+bias_H);
P = S((H*model.W_output)+bias_O);