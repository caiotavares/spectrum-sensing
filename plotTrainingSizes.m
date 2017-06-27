m1 = load('data/train25.mat');
m2 = load('data/train50.mat');
m3 = load('data/train100.mat');
m4 = load('data/train250.mat');
m5 = load('data/train500.mat');

mLen = length(m1.models.ML.NB.Pfa);
mSize = 6;
mPercent = 20;

figure
plot(m1.models.ML.NB.Pfa, m1.models.ML.NB.Pd,'-*','MarkerIndices',1:mLen/mPercent:mLen,'MarkerSize',mSize), hold on
plot(m2.models.ML.NB.Pfa, m2.models.ML.NB.Pd,'-+','MarkerIndices',1:mLen/mPercent:mLen,'MarkerSize',mSize)
plot(m3.models.ML.NB.Pfa, m3.models.ML.NB.Pd,'-o','MarkerIndices',1:mLen/mPercent:mLen,'MarkerSize',mSize)
plot(m4.models.ML.NB.Pfa, m4.models.ML.NB.Pd,'->','MarkerIndices',1:mLen/mPercent:mLen,'MarkerSize',mSize)
plot(m5.models.ML.NB.Pfa, m5.models.ML.NB.Pd,'-<','MarkerIndices',1:mLen/mPercent:mLen,'MarkerSize',mSize)
grid on
legend('25','50','100','250','500')
axis([0 0.2 0.7 1]);
xlabel 'False Alarm Probability'
ylabel 'Detection Probability'

