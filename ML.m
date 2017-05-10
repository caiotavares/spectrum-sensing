%% Training Methodology (not operational)

% trainingPercent = 0.7;
% truePositives = find(A==1);
% trueNegatives = find(A==0);
% positiveTrainingIndexes = truePositives(randperm(length(truePositives),round(length(truePositives)*trainingPercent)));
% negativeTrainingIndexes = trueNegatives(randperm(length(trueNegatives),round(length(trueNegatives)*trainingPercent)));
% trainingIndexes = sort([positiveTrainingIndexes;negativeTrainingIndexes]);
% testIndexes = setdiff(1:size(X,1),trainingIndexes)';
% 
% X_training = array2table([X(trainingIndexes,:) A(trainingIndexes)]);
% X_test = array2table([X(testIndexes,:) A(testIndexes)]);
% 
% names = cell(1,size(scenario.SU,1));
% for i=1:size(scenario.SU,1)
%    names{i} = ['SU_' num2str(i)];
% end
% names{end+1} = 'Channel_Status';
% 
% X_training.Properties.VariableNames = names;
% X_test.Properties.VariableNames = names;

% startObj = struct('mu',mu,'Sigma',Sigma,'ComponentProportion',mixing);
% options = statset('Display','final');
% GM = fitgmdist(X_training,2,'Start',startObj,'Options',options,'CovarianceType','diagonal');