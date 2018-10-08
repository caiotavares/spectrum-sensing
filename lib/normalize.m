function resultModels = normalize(modelsHolder,epochs, manifest)

if manifest.ML.NB
    models.Pd.NB = zeros(length(modelsHolder(1).models.ML.NB.Pd),1); 
    models.Pfa.NB = zeros(length(modelsHolder(1).models.ML.NB.Pfa),1);
    models.AUC.NB = zeros(length(modelsHolder(1).models.ML.NB.AUC),1);
end
if manifest.ML.GMM
    models.Pd.GMM = zeros(length(modelsHolder(1).models.ML.GMM.Pd),1);
    models.Pfa.GMM = zeros(length(modelsHolder(1).models.ML.GMM.Pfa),1);
    models.AUC.GMM = zeros(length(modelsHolder(1).models.ML.GMM.AUC),1);
end
if manifest.ML.KMeans
   models.Pd.KMeans = zeros(length(modelsHolder(1).models.ML.KMeans.Pd),1);
   models.Pfa.KMeans = zeros(length(modelsHolder(1).models.ML.KMeans.Pfa),1);
   models.AUC.KMeans = zeros(length(modelsHolder(1).models.ML.KMeans.AUC),1);
end
if manifest.ML.SVM
   models.Pd.SVM = zeros(length(modelsHolder(1).models.ML.SVM.Pd),1);
   models.Pfa.SVM = zeros(length(modelsHolder(1).models.ML.SVM.Pfa),1);
   models.AUC.SVM = zeros(length(modelsHolder(1).models.ML.SVM.AUC),1);
end
if manifest.ML.MLP
   models.Pd.MLP = zeros(length(modelsHolder(1).models.ML.MLP.Pd),1);
   models.Pfa.MLP = zeros(length(modelsHolder(1).models.ML.MLP.Pfa),1);
   models.AUC.MLP = zeros(length(modelsHolder(1).models.ML.MLP.AUC),1);
end

for i=1:epochs
    models.Pd = sumstructs(structfun( @(m) (m.Pd) , modelsHolder(i).models.ML, 'UniformOutput', false), models.Pd);
    models.Pfa = sumstructs(structfun( @(m) (m.Pfa) , modelsHolder(i).models.ML, 'UniformOutput', false), models.Pfa);
    models.AUC = sumstructs(structfun( @(m) (m.AUC) , modelsHolder(i).models.ML, 'UniformOutput', false), models.AUC);
end

models.Pd = structfun( @(m) (m./epochs), models.Pd,'UniformOutput',false);
models.Pfa = structfun( @(m) (m./epochs), models.Pfa,'UniformOutput',false);
models.AUC = structfun( @(m) (m./epochs), models.AUC,'UniformOutput',false);

resultModels = modelsHolder(1).models;
modelNames = fieldnames(resultModels.ML);
fieldNames = fieldnames(models);

for j=1:length(modelNames)
    m = modelNames(j);
    for k=1:length(fieldNames)
        f = fieldNames(k);
        resultModels.ML.(m{:}).(f{:}) = models.(f{:}).(m{:});
    end
end

end