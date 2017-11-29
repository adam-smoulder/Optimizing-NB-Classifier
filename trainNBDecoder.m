% This is a function to learn the needed parameters for a two class 
% Naive Bayes decoder. 
%
% Usage: [classMeans, classVars, classPriors] = trainPoissonNBDecoder(trainCounts, trainLabels)
%
% Inputs: 
%
%   trainCounts - a matrix of spike counts, where each column is a trial
%   and each row is a neuron. 
%
%   trainLabels - a vector of labels for each trial (column) in
%   trainCounts. 
%
% Outputs: 
%
%   classMeans - a matrix, where the first column gives the mean counts for
%   class 1 and the second column gives the mean counts for class 2. 
%   
%   classVars - same as classMeans but variance of the data instead
%
%   classPriors - a vector where the first entry gives the prior
%   probability for class 1 and the second entry gives the prior
%   probability for class 2. 
%
function [classMeans, classVars, classPriors] = trainNBDecoder(trainCounts, trainLabels)

% Works for any number of classes
labs=unique(trainLabels);
classMeans = zeros(length(labs), size(trainCounts,1));
classVars = zeros(length(labs), size(trainCounts,1));
classPriors = zeros(1,length(labs));
for i=1:length(labs)
    % Find indices corresponding to label i
    labinds_i=find(trainLabels==labs(i));
    
    % Find class means and variance for this label
    classMeans(i,:) = mean(trainCounts(:,labinds_i)')';
    classVars(i,:) = var(trainCounts(:,labinds_i)');
    
    classPriors(i)=length(labinds_i)/length(trainLabels);
end
end