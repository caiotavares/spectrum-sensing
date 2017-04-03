% Fit the GM model
options = statset('Display','final');
gm = fitgmdist(Y,2,'Options',options,'Start',A+1);

% Check the scatter plot
figure;
scatter(Y(:,1),Y(:,2),10,'bo')
axis([0.8 1.4 0.8 1.4])
hold on
fcontour(@(x,y)pdf(gm,[x y]),[0.8 1.4],[0.8 1.4]);
title('Scatter Plot and Fitted GMM Contour')
xlabel 'SU 1'
ylabel 'SU 2'
hold off

% Cluster the data
idx = cluster(gm,Y);
% predicted0 = (idx == 1); % channel available
% predicted1 = (idx == 2); % channel unavailable

% Plot the clustered data
figure;
gscatter(Y(:,1),Y(:,2),idx,'br','o+');
axis([0.8 1.4 0.8 1.4])
grid on
legend('Channel available','Channel unavailable','Location','NorthWest');
title 'GMM Prediction'

% Get the performance metrics
temp = (A+1)==idx;
correct = length(temp(temp==1));
incorrect = length(A)-correct;
acc = correct/length(A);