% Lavanya Krishna, Michael Shteyn, Adam Smoulder, Pati Stan
% Neural Data Analysis
% Last Updated: 12/12/17

%% properties of data 
total_stim = 12; 
total_trials = 50;
total_neurons = 100;
dist = 'poisson'; %%%%%%%%%%%%%%%%%%%%% ENTER 'gauss' OR 'poisson' OR 'bimodal' %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%generate lmbdas from gauss distribution (so have gaussian tuning curves)
max_mean_FR = 30;       %max mean firing rate of all cells will be 30
gauss_mean = 10;        %mean of the gaussian used to define the tuning curve
gauss_std = 1.5;        %stdev of the gaussian used to define the tuning curve
gauss = [];             %this will store values that will be used 
x=8.5;                  %starting point for what will be used as "sample mean" when calculating the value for the distribution
for i = 1:total_stim
    x = x+0.25; %incrementing by 0.25
    %equation for gaussian distribution
    gauss(i) = (2/sqrt(2*3.14159*gauss_std^2))*exp(-(x - gauss_mean)^2/(2*gauss_std^2));
end
gauss = gauss./max(gauss);                          %normalize so can multiply by the mean max firing rate
lambda_values = round(gauss.*max_mean_FR,2);        %multiply by our mean max FR
lambda_values_repeated = repmat(lambda_values,1,2); %matrix to make it easier to shift tuning curve

%% generate spikes for each neuron, each stim, each trial
dataset_1 = zeros(total_neurons,total_stim,total_trials);
%for each neuron
for n = 1:total_neurons
    start = randi(total_stim); %choose a random stimulus to start at (this will be peak of tuning curve)
    n_lambdas = lambda_values_repeated(start:start+total_stim-1); %choose lambda/mean values from that starting point
    %for each stimulus
    for s = 1:total_stim
        s_lambda = n_lambdas(s); % for each stim's lmabda/mean value
        %for each repetition
        for t = 1: total_trials
            if strcmp(dist,'poisson')
                dataset_1(n,s,t) = poissrnd(s_lambda); %get FR from Poisson
            elseif strcmp(dist,'gauss')
                sigma = s_lambda/4;
                dataset_1(n,s,t) = normrnd(s_lambda,sigma); %get response from Gauss
            elseif strcmp(dist,'bimodal')
                % select randomly between the two gaussian distributions
                if mod(t,2)
                    s_lambda_forTrial = s_lambda-10; %mean peak firing rate will be 20
                else
                    s_lambda_forTrial = s_lambda;    %mean peak firing rate will be 30
                end
                sigma = 2; %variance for gauss
                dataset_1(n,s,t) = normrnd(s_lambda_forTrial,sigma); %get response from Gauss
            else
                error('no distribution chosen');
            end
        end
    end
end


%% save stuff
if strcmp(dist,'poisson')
    save('dataset1.mat','dataset_1','lambda_values','dist','max_mean_FR','gauss','total_neurons','total_trials','total_stim');
elseif strcmp(dist,'gauss')
    dataset_2 = dataset_1;
    save('datasetGauss.mat','dataset_2','lambda_values','dist','max_mean_FR','gauss','sigma','total_neurons','total_trials','total_stim');
elseif strcmp(dist,'bimodal')
    dataset_3 = dataset_1;
    save('dataset3.mat','dataset_3','lambda_values','dist','max_mean_FR','gauss_mean','gauss_std','sigma','total_neurons','total_trials','total_stim');
end
