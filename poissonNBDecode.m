% Lavanya Krishna, Michael Shetyn, Adam Smoulder, Pati Stan
% Neural Data Analysis
% Last Updated: 12/12/17

% Adapted from function written by Lindsay Bahureksa and Dr. Steve Chase

% This is a function to estimate class labels based only on count data
% using a Poisson Naive Bayes decoder. 
%
% Usage: estLabels = poissonNBDecode(testCounts, classMeans, classPriors)
%
% Inputs: 
%
%   testCounts - a matrix of spike counts, where each column is a trial
%   and each row is a neuron. 
%
%   classMeans - a matrix representing the means firing rates for each
%   neuron to the different stimuli (dims = stimuli x neurons, meaning an
%   individual column would show one neuron's mean response to all stimuli)
%
%   classPriors - a vector where each entry represents the prior
%   probability of one of the given stimuli
%
% Outputs: 
%
%   estLabels - a vector, where estLabels(i) gives the estimated label for
%   trial i in testCounts. 
%

function estLabels = poissonNBDecode(testCounts, classMeans, classPriors)
% dimensions: 
% classMeans = stim x neurons
% classPriors = 1 x stim
% testCounts = neurons x trials

if min(min(classMeans <= 0))
    classMeans = classMeans-min(min(classMeans))+.001; % hack to avoid log(<=0) -> fail
end

ntrials=size(testCounts,2);
PPC = zeros(size(classMeans,1), ntrials); % stim x trials
for i = 1:size(classMeans,1) % for each stimulus
    cM = classMeans(i,:)'; % mean firing rates for each neuron
    CM = repmat(cM,[1,ntrials]); % ^repeated so cM is neuron x trial
    LLC = sum(testCounts.*log(CM)-CM); % log likelihood
    PPC(i,:) = LLC + log(classPriors(i)); % incorporate AP info
end

[~, estLabels] = max(PPC); % set estimated test labels

end