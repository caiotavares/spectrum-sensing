function plotResults(test,models,options)

close all

X = test.X;
Y = test.Y;

% Received PU signal + noise in time
% t = ts:ts:T; % Time axis
% index = find(sum(S,2)==N,1); % Get first occurrence of all PUs active
% figure
% plot(t,abs(reshape(PU(1,:,index),1,samples)),'b',...
%      t,abs(reshape(n(1,:,index),1,samples)),'r');
% grid on
% legend('PUs','Noise')


% PU and SU location
% figure
% plot(scenario.PU(:,1),scenario.PU(:,2),'k^','MarkerFaceColor','k','MarkerSize',8), hold on
% plot(scenario.SU(:,1),scenario.SU(:,2),'ro','MarkerFaceColor','r','MarkerSize',8);
% grid on
% legend('PU', 'SU')
% hold off


% Actual channel states
if (ismember('Channel States', options))
    figure
    plot3(X(Y==1,1),X(Y==1,2),X(Y==1,3),'r+'), hold on
    plot3(X(Y==0,1),X(Y==0,2),X(Y==0,3),'bo')
    grid on
    % title('Channel States')
    legend('Channel unavailable','Channel available','Location','NorthWest');
    xlabel 'Normalized energy level of SU_1'
    ylabel 'Normalized energy level of SU_2'
    zlabel 'Normalized energy level of SU_3'
    hold off
end


% Analytical GMM contours for SU1 and SU3
% figure
% plot(X(A==1,1),X(A==1,3),'r+'), hold on
% plot(X(A==0,1),X(A==0,3),'bo')
% GMM = models.analytical.GMM.model;
% cluster1 = gmdistribution(GMM.mu(1,[1 3]), GMM.Sigma(1,[1 3],1), GMM.ComponentProportion(1));
% cluster2 = gmdistribution(GMM.mu(2,[1 3]), GMM.Sigma(1,[1 3],2), GMM.ComponentProportion(2));
% f1 = fcontour(@(x,z)pdf(cluster1,[x z]));
% f2 = fcontour(@(x,z)pdf(cluster2,[x z]));
% % axis([min(X(:,1)) max(X(:,1)) min(X(:,3)) max(X(:,3))]);
% axis([0 8 0 8]);
% xlabel('SU 1')
% ylabel('SU 3')
% title('Analytical GMM')
% xline = linspace(GMM.mu(1,1),GMM.mu(2,1),10);
% yline = linspace(GMM.mu(1,3),GMM.mu(2,3),10);
% line(xline,yline)
% hold off
% grid on


% Learned GMM contours for SU1 and SU3
% figure
% plot(X(A==1,1),X(A==1,3),'r+'), hold on
% plot(X(A==0,1),X(A==0,3),'bo')
% GMM = models.ML.GMM.model;
% cluster1 = gmdistribution(GMM.mu(1,[1 3]), GMM.Sigma([1 3],[1 3],1), GMM.ComponentProportion(1));
% cluster2 = gmdistribution(GMM.mu(2,[1 3]), GMM.Sigma([1 3],[1 3],2), GMM.ComponentProportion(2));
% f1 = fcontour(@(x,z)pdf(cluster1,[x z]));
% f2 = fcontour(@(x,z)pdf(cluster2,[x z]));
% % axis([min(X(:,1)) max(X(:,1)) min(X(:,3)) max(X(:,3))]);
% axis([0 8 0 8]);
% xlabel('SU 1')
% ylabel('SU 3')
% title('Learned GMM')
% xline = linspace(GMM.mu(1,1),GMM.mu(2,1),10);
% yline = linspace(GMM.mu(1,3),GMM.mu(2,3),10);
% line(xline,yline)
% hold off
% grid on


% SU1 and SU2 predicted channel states (AND rule)
% figure
% plot(X(detected_and,1),X(detected_and,2),'r+', 'DisplayName', 'Channel unavailable'), hold on
% legend('-DynamicLegend','Location','Northwest');
% plot(X(falseAlarm_and,1),X(falseAlarm_and,2),'b+', 'DisplayName', 'False alarm'), hold on
% plot(X(available_and,1),X(available_and,2),'bo', 'DisplayName', 'Channel available'), hold on
% plot(X(misdetected_and,1),X(misdetected_and,2),'ro', 'DisplayName', 'Misdetection')
% % axis(axisLimits)
% grid on
% title('Predicted Channel States (AND rule)')
% xlabel 'Normalized energy level of SU 1'
% ylabel 'Normalized energy level of SU 2'
% hold off


% SU1 and SU2 predicted channel states (OR rule)
% figure
% plot(X(detected_or,1),X(detected_or,2),'r+', 'DisplayName', 'Channel unavailable'), hold on
% legend('-DynamicLegend','Location','Northwest');
% plot(X(falseAlarm_or,1),X(falseAlarm_or,2),'b+', 'DisplayName', 'False alarm'), hold on
% plot(X(available_or,1),X(available_or,2),'bo', 'DisplayName', 'Channel available'), hold on
% plot(X(misdetected_or,1),X(misdetected_or,2),'ro', 'DisplayName', 'Misdetection')
% % axis(axisLimits)
% grid on
% title('Predicted Channel States (OR rule)')
% xlabel 'Normalized energy level of SU 1'
% ylabel 'Normalized energy level of SU 2'
% hold off

%% Training set size comparison
% figure
% trainingSamples = [25 50 75 100 500];
% % Pd = zeros(length(trainingSamples), length(fields(models(1).ML)) );
% 
% m1 = load('data/25_ss.mat');
% m2 = load('data/50_ss.mat');
% m3 = load('data/75_ss.mat');
% m4 = load('data/100_ss.mat');
% m5 = load('data/500_ss.mat');
% 
% NB(1) = m1.models.ML.NB.Pd(40);
% LSVM(1) = m1.models.ML.LSVM.Pd(40);
% GSVM(1) = m1.models.ML.GSVM.Pd(40);
% MLP(1) = m1.models.ML.MLP.Pd(40);
% 
% NB(2) = m2.models.ML.NB.Pd(40);
% LSVM(2) = m2.models.ML.LSVM.Pd(40);
% GSVM(2) = m2.models.ML.GSVM.Pd(40);
% MLP(2) = m2.models.ML.MLP.Pd(40);
% 
% NB(3) = m3.models.ML.NB.Pd(40);
% LSVM(3) = m3.models.ML.LSVM.Pd(40);
% GSVM(3) = m3.models.ML.GSVM.Pd(40);
% MLP(3) = m3.models.ML.MLP.Pd(40);
% 
% NB(4) = m4.models.ML.NB.Pd(40);
% LSVM(4) = m4.models.ML.LSVM.Pd(40);
% GSVM(4) = m4.models.ML.GSVM.Pd(40);
% MLP(4) = m4.models.ML.MLP.Pd(40);
% 
% NB(5) = m5.models.ML.NB.Pd(40);
% LSVM(5) = m5.models.ML.LSVM.Pd(40);
% GSVM(5) = m5.models.ML.GSVM.Pd(40);
% MLP(5) = m5.models.ML.MLP.Pd(40);
% 
% grid on
% plot(trainingSamples, NB), hold on
% plot(trainingSamples, LSVM)
% plot(trainingSamples, GSVM)
% plot(trainingSamples, MLP)
% legend('NB', 'Linear-SVM', 'Gaussian-SVM', 'MLP')


%% ROC Curve

if (ismember('ROC',options))
    figure
    mSize = 6;
    mPercent = 20;
    if (isfield(models,'basic'))
        len = length(models.basic.AND.Pfa);
        plot(models.basic.AND.Pfa, models.basic.AND.Pd,'k-o','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize), hold on
        leg = "AND";
        plot(models.basic.OR.Pfa, models.basic.OR.Pd,'r-v','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
        leg = [leg; 'OR'];
        
        if (ismember('IndividualROC',options))
            if (size(models.basic.Ind.Pfa,2)==3)
                plot(models.basic.Ind.Pfa(:,1),models.basic.Ind.Pd(:,1),'--d','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
                plot(models.basic.Ind.Pfa(:,2),models.basic.Ind.Pd(:,2),'-->','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
                plot(models.basic.Ind.Pfa(:,3),models.basic.Ind.Pd(:,3),'--<','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
                leg = [leg; 'SU 1'; 'SU 2'; 'SU 3'];
            else
                plot(models.basic.Ind.Pfa(:,1),models.basic.Ind.Pd(:,1),'--d','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
                plot(models.basic.Ind.Pfa(:,2),models.basic.Ind.Pd(:,2),'-->','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
                plot(models.basic.Ind.Pfa(:,3),models.basic.Ind.Pd(:,3),'--<','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
                plot(models.basic.Ind.Pfa(:,4),models.basic.Ind.Pd(:,4),'--p','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
                leg = [leg; 'SU 1'; 'SU 2'; 'SU 3'; 'SU 4'];
            end
        end
    end
    
    if (isfield(models,'analytical'))
        modelNames = structfun(@(x) (plotModel(x)), models.analytical, 'UniformOutput',false);
        fieldNames = fieldnames(modelNames);
        for i=1:length(fieldNames)
            name = modelNames.(char(fieldNames(i)));
            leg = [leg; name];
        end
    end
    
    if (isfield(models,'ML'))
        modelNames = structfun(@(x) (plotModel(x)), models.ML, 'UniformOutput',false);
        fieldNames = fieldnames(modelNames);
        for i=1:length(fieldNames)
            name = modelNames.(char(fieldNames(i)));
            leg = [leg; name];
        end
    end
    
    legend(string(leg));
    grid on
    xlabel 'False Alarm Probability'
    ylabel 'Detection Probability'
    hold off
    
end

    function name = plotModel(model)
        len = length(model.Pfa);
        plot(model.Pfa, model.Pd,'MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize), hold on
        name = model.name;
    end

end
