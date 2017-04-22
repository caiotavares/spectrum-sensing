%% Setup

clear
close all
addpath('lib');

realiz = 5e3;
T = 10e-6; % SU spectrum sensing period
w = 5e6; % SU spectrum sensing bandwidth
N = round(2*w*T); % Number of samples
NoisePSD_dBm = -150; % Noise PSD in dBm/Hz
NoiseVariance = (10^(NoisePSD_dBm/10)*1e-3)*w;

%% Distribute the SU and PU locations and active probability
               
scenario = struct();
scenario.PU = [1.0 1.0]*1e3;
scenario.SU = [0.25 1.0 ; 2.0 1.0; 1.0 0.5]*1e3;
scenario.Pr = [0.5];
scenario.NoisePower = NoiseVariance;
scenario.TXPower = 0.1; % PU transmission power in W
               
%% Spectrum Sensing Procedure

[X,A,PU,n,Z,SNR] = SS_MCS(scenario, T, w,realiz);

meanSNR = zeros(size(SNR,1),1);

for i=1:size(SNR,1)
   meanSNR(i) = mean(SNR(i,SNR(i,:)>0));
end

SNR_dB = 10*log10(meanSNR); 

%% ML  

% Bayesian 
e = 1e-3;
P_X0_H1 = chi2cdf((X+e)*N./(1+meanSNR)',N) - chi2cdf((X-e)*N./(1+meanSNR)',N);
P_X0_H0 = chi2cdf((X+e)*N,N) - chi2cdf((X-e)*N,N);
P_H1 = scenario.Pr;
P_H0 = 1-P_H1;
P_H1_X0 = P_X0_H1*P_H1./(P_X0_H0*P_H0 + P_X0_H1*P_H1);
P_H0_X0 = 1-P_H1_X0;

% GMM
% start = struct('mu',[1 1],'Sigma',diag(sigmaY),'ComponentProportion',[0.25 0.75]);
start = A+1;
[Y,GM] = GMM(X,2);

%%

predict
plotResults
