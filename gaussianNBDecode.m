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
% testCounts = neurons x trialsTotal (so nTrial * 12)

ntrials=size(testCounts,2);
PPC = zeros(size(classMeans,1), ntrials); % stim x trials
for i = 1:size(classMeans,1) % for each stimulus
    cM = classMeans(i,:)'; % mean firing rates for each neuron
    CM = repmat(cM,[1,ntrials]); % ^repeated so it's neuron x trial
    cV = classVars(:,i); % variance of FR for each neuron
    CV = repmat(cV,[1,ntrials]);
    %LLC = sum(testCounts.*log(CM)-CM); % log likelihood
    LLC = sum(-log(sqrt(CV)*sqrt(2*pi))...
        -0.5*((testCounts-CM).^2)./(CV)); % log likelihood
    PPC(i,:) = LLC + log(classPriors(i)); % incorporate AP info
end

[~, estLabels] = max(PPC);

end