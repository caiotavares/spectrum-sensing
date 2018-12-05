m(1) = load('data/25_ss.mat');
m(2) = load('data/50_ss.mat');
m(3) = load('data/100_ss.mat');
m(4) = load('data/150_ss.mat');
m(5) = load('data/200_ss.mat');
m(6) = load('data/250_ss.mat');
m(7) = load('data/500_ss.mat');

NB = zeros(1,7);
LSVM = zeros(1,7);
GSVM = zeros(1,7);
MLP = zeros(1,7);

training = [25 50 100 150 200 250 500];

for i=1:7
    index(i) = structfun( @(m) (findPfa(m.Pfa, 0.1)), m(i).models.ML, 'UniformOutput', false);
    NB(i) = models.ML.NB.Pd(index(i).NB);
    LSVM(i) = models.ML.LSVM.Pd(index(i).LSVM);
    GSVM(i) = models.ML.GSVM.Pd(index(i).GSVM);
    MLP(i) = models.ML.MLP.Pd(index(i).MLP);
end

figure
semilogy(training, NB), hold on
semilogy(training, LSVM)
semilogy(training, GSVM)
semilogy(training, MLP)
xlabel 'Training Size'
ylabel 'Detection Probability'
legend('NB', 'Linear-SVM', 'Gaussian-SVM', 'MLP')

function index = findPfa(pfa, target)
    [~,index] = min(abs(pfa-target));
end

% mLen = length(m1.models.ML.NB.Pfa);
% mSize = 6;
% mPercent = 20;
% 
% figure
% plot(m1.models.ML.NB.Pfa, m1.models.ML.NB.Pd,'-*','MarkerIndices',1:mLen/mPercent:mLen,'MarkerSize',mSize), hold on
% plot(m2.models.ML.NB.Pfa, m2.models.ML.NB.Pd,'-+','MarkerIndices',1:mLen/mPercent:mLen,'MarkerSize',mSize)
% plot(m3.models.ML.NB.Pfa, m3.models.ML.NB.Pd,'-o','MarkerIndices',1:mLen/mPercent:mLen,'MarkerSize',mSize)
% plot(m4.models.ML.NB.Pfa, m4.models.ML.NB.Pd,'->','MarkerIndices',1:mLen/mPercent:mLen,'MarkerSize',mSize)
% plot(m5.models.ML.NB.Pfa, m5.models.ML.NB.Pd,'-<','MarkerIndices',1:mLen/mPercent:mLen,'MarkerSize',mSize)
% plot(m6.models.ML.NB.Pfa, m6.models.ML.NB.Pd,'-^','MarkerIndices',1:mLen/mPercent:mLen,'MarkerSize',mSize)
% plot(models.analytical.GMM.Pfa, models.analytical.GMM.Pd,'--','MarkerIndices',1:mLen/mPercent:mLen,'MarkerSize',mSize)
% grid on
% legend('25 training samples','50 training samples','100 training samples',...
%     '250 training samples','500 training samples','5000 training samples',...
%     'GMM')
% axis([0 0.2 0.7 1]);
% xlabel 'False Alarm Probability'
% ylabel 'Detection Probability'


