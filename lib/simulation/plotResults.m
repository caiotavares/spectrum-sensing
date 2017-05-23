function plotResults(X,Y,Pd,Pfa,varargin)

close all

default.suppressIndividual = false;

if (nargin >4)
    options = varargin{1};
    models = varargin{2};
else
    options = default;
end

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


%% ROC Curve

figure
len = length(Pfa.bayes);
mSize = 6;
mPercent = 20;
plot(Pfa.and,Pd.and,'k-o','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize), hold on
plot(Pfa.or,Pd.or,'r-v','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
plot(Pfa.bayes,Pd.bayes,'b-*','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
plot(Pfa.gmm,Pd.gmm,'m-+','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
plot(Pfa.lgmm,Pd.lgmm,'m--','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
plot(Pfa.mlp,Pd.mlp,'g--','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
plot(Pfa.kmeans,Pd.kmeans,'r--','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
plot(Pfa.svm,Pd.svm,'b--','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
plot(Pfa.nb,Pd.nb,'k--','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
if (options.suppressIndividual == false)
    if (size(Pfa.ind,2)==3)
        plot(Pfa.ind(:,1),Pd.ind(:,1),'--d','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
        plot(Pfa.ind(:,2),Pd.ind(:,2),'-->','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
        plot(Pfa.ind(:,3),Pd.ind(:,3),'--<','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
        leg = ['SU 1'; 'SU 2'; 'SU 3'];
    else
        plot(Pfa.ind(:,1),Pd.ind(:,1),'--d','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
        plot(Pfa.ind(:,2),Pd.ind(:,2),'-->','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
        plot(Pfa.ind(:,3),Pd.ind(:,3),'--<','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
        plot(Pfa.ind(:,4),Pd.ind(:,4),'--p','MarkerIndices',1:len/mPercent:len,'MarkerSize',mSize)
        leg = ['SU 1'; 'SU 2'; 'SU 3'; 'SU 4'];
    end
    legend(['AND','OR','Weighted Bayesian','Analytical GMM','Learned GMM',...
            'Multilayer Perceptron','K-Means','SVM','Naive Bayes',string(leg)']);
else
    legend('AND','OR','Weighted Bayesian','Analytical GMM','Learned GMM',...
           'Multilayer Perceptron','K-Means','SVM','Naive Bayes');
end
grid on
xlabel 'False Alarm Probability'
ylabel 'Detection Probability'
hold off
