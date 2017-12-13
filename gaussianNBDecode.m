% Lavanya Krishna, Michael Shetyn, Adam Smoulder, Pati Stan
% Neural Data Analysis
% Last Updated: 12/12/17

% Adapted from function written by Lindsay Bahureksa and Dr. Steve Chase

% This is a function to estimate class labels based only on count data
% using a Gaussian Naive Bayes decoder. 
%
% Usage: estLabels = gaussianNBDecode(testCounts, classMeans, classPriors)
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

function estLabels = gaussianNBDecode(testCounts, classMeans, classVars, classPriors)
% dimensions: 
% classMeans = stim x neurons
% classVars = stim x neurons
% classPriors = 1 x stim
% testCounts = neurons x trialsTotal (so nTrial * 12)

ntrials=size(testCounts,2);
PPC = zeros(size(classMeans,1), ntrials); % stim x trials
for i = 1:size(classMeans,1) % for each stimulus
    cM = classMeans(i,:)'; % mean firing rates for each neuron
    CM = repmat(cM,[1,ntrials]); % cM repeated so it's neuron x trial
    cV = classVars(:,i); % variance of FR for each neuron
    CV = repmat(cV,[1,ntrials]); % cV repeated so it's neuron x trial
    LLC = sum(-log(sqrt(CV)*sqrt(2*pi))...
        -0.5*((testCounts-CM).^2)./(CV)); % log likelihood
    PPC(i,:) = LLC + log(classPriors(i)); % incorporate AP info
end

[~, estLabels] = max(PPC); % assign estimated labels

end