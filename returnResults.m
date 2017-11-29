% NOTE this is probably very out of date - @michael let me know what you
% need


% Team LAMP, Neural Data Analysis
% Last Updated: 11/22/17
% returnResults causes the variable "vals2Display" to be set to a vector of
% decoder accuracy values based on the conditions "nNeuron", "nTrial", and
% "nFold" (if time permits, "nBin" as well), and "xAxisParam", referring to
% the x-axis parameter against which the decoder output will be plotted

% xAxisParam should equal "N", "T", or "F" (if time permits, or "B"),
% corresponding to Neurons, Trials, or Folds (or Bins), respectively.

% This script is meant to be implemented with the GUI mainframe and assumes
% that 1.) The total decoded matrix has been loaded and is present in the
% workspace as the variable "decoderOutput", and 2.) an x-axis parameter
% has been selected by the user in the GUI

%% defaulting variables and setting constrainsts
% note, the value associated with the x-axis parameter will be ignored
if exist('nNeuron', 'var') == 0 || nNeuron == 0  
    nNeuron = 50;
end
if exist('nTrial', 'var') == 0 || nTrial == 0  
    nTrial = 25;
end
if exist('nFold', 'var') == 0 || nFold == 0  
    nFold = 5;
end
% if exist('nBin', 'var') == 0 || nNeuron == 0  
%     nBin = 5;
% end
if exist('xAxisParam', 'var') == 0 || nFold == 0  
    xAxisParam = 'N';
end

% These conditions should be synced with what was run thru the decoder!
neuronMin = 10;		% minimum number of neurons
neuronMax = 100;	% maximum number of neurons
neuronStep = 10;	% difference between input neuron quantities 

trialMin = 5;		% minimum number of trials (per stimulus)
trialMax = 50;		% maximum number of trials
trialStep = 5;		% difference between input trial quantities 

foldMin = 2;		% minimum number of folds
foldMax = 20;		% maximum number of folds
foldStep = 1;		% difference between input fold quantities 

% binMin = 2;		% minimum number of bins
% binMax = 20;		% maximum number of bins
% binStep = 2;		% difference between input bins quantities 

% establish vectors for differing conditions
neuronConds = neuronMin : neuronStep : neuronMax;
trialConds = trialMin : trialStep : trialMax;
foldConds = foldMin : foldStep: foldMax;
% binConds = binMin : binStep : binMax;

%% Isolate required decoder output
% this will need adjusted if Bins are added!

neuronIndex = find(neuronConds >= nNeuron, 1,'first');
trialIndex = find(trialConds >= nTrial, 1,'first');
foldIndex = find(foldConds >= nFold, 1,'first');

switch xAxisParam
    case 'N'
        vals2Display = squeeze(decoderOutput(:,trialIndex,foldIndex))';
    case 'T'
        vals2Display = squeeze(decoderOutput(neuronIndex,:,foldIndex))';
    case 'F'
        vals2Display = squeeze(decoderOutput(neuronIndex,trialIndex,:))';
%   case 'B'
%       vals2Display = squeeze all but last dim
    otherwise
        squeezeDim = 1; % default
end


