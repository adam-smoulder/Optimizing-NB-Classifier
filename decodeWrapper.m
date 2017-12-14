% Lavanya Krishna, Michael Shteyn, Adam Smoulder, Pati Stan
% Neural Data Analysis
% Last Updated: 12/12/17

% The purpose of the script is to wrap the decoder function and run it for
% every permutation of conditions (# of neurons, # of trials, # of folds,
% # of bins). The output datasets from this will be used with the GUI.

fileNameToSave = 'gauss_dataset2_12stim'; % change name based on dataset

%% Variable declaration
% declare conditions the decoder will be used for

neuronMin = 1;		% minimum number of neurons
neuronMax = 100;    % maximum number of neurons
neuronStep = 1;     % difference between input neuron quantities

trialMin = 5;		% minimum number of trials (per stimulus)
trialMax = 50;		% maximum number of trials
trialStep = 1;		% difference between input trial quantities

binMin = 2;         % minimum number of bins
binMax = 10;		% maximum number of bins
binStep = 1;		% difference between input bins quantities

% establish vectors for differing conditions
neuronConds = neuronMin : neuronStep : neuronMax;
trialConds = trialMin : trialStep : trialMax;
binConds = binMin : binStep : binMax;

nPerm = 1; % number of repetitions of each condition to run then average
nFold = 5; % number of folds to use for cross validation

%% Perform decoding for each condition, output dims: #neurons x #trials x #folds
tic

% preallocate variables
% poisson decoder, with and without cross-val
decoderOutputPoisson = nan(length(neuronConds), length(trialConds), nFold);
decoderStdevPoisson = nan(length(neuronConds), length(trialConds));

% gaussian decoder, with and without cross-val
decoderOutputGauss = nan(length(neuronConds), length(trialConds), nFold);
decoderStdevGauss = nan(length(neuronConds), length(trialConds));

% binned decoding, with and without cross-val
decoderOutputBins = nan(length(neuronConds), length(trialConds), length(binConds), nFold);
decoderStdevBins = nan(length(neuronConds), length(trialConds), length(binConds));

for ii = neuronMin:neuronStep:neuronMax
    for jj = trialMin:trialStep:trialMax
        % clean the slate for the last run
        clear pAccur nNeuron nTrial nFold dataToUse accuracy set_size ...
            test_data train_data testLabels trainLabels classMeans classPriors ...
            estTestLabels trainCounts testCounts data_logical_vector permutationResult
        
        % get current loops # neurons and trials
        nNeuron = ii;
        nTrial = jj;
        
        
        % run poisson decoder
        decoderType = 'poisson'; % used by decodeScript
        decodeScript % perform decoding!
        decoderOutputPoisson(ii,jj,:) = decoderResult;
        decoderStdevPoisson(ii,jj) = decoderStdev;
        
        disp(['poisson n=' num2str(nNeuron), ' t=' num2str(nTrial) ' f=' ...
            num2str(nFold) ' - accuracy: ' num2str(round(decoderResult)) '%'...
            ', stdev: ' num2str(round(decoderStdev))]);
        
        % run gaussian decoder
        decoderType = 'gaussian'; % used by decodeScript
        decodeScript % perform decoding!
        decoderOutputGauss(ii,jj,:) = decoderResult;
        decoderStdevGauss(ii,jj) = decoderStdev;
        
        disp(['gauss n=' num2str(nNeuron), ' t=' round(num2str(nTrial)) ' f=' ...
            num2str(nFold) ' - accuracy: ' num2str(round(decoderResult)) '%'...
            ', stdev: ' num2str(round(decoderStdev))]);
        
        % run binning decoder
        decoderType = 'bins'; % used by decodeScript
        for ll = 1:length(binConds)
            nBin = binConds(ll); % for a given number of bins
            decodeScript % perform decoding!
            decoderOutputBins(ii,jj,ll,:) = decoderResult;
            decoderStdevBins(ii,jj,ll) = decoderStdev;

            disp(['bins n=' round(num2str(nNeuron)), ' t=' round(num2str(nTrial)) ' f=' ...
                round(num2str(nFold)) ' - accuracy: ' num2str(round(decoderResult)) '%'...
                ', stdev: ' num2str(round(decoderStdev))]);
        end
        
        disp(['completed n = ' num2str(ii) ' t = ' num2str(jj)])
    end
end

toc

%% if desired, save the output
save(fileNameToSave,'neuronConds','trialConds','binConds','nFold',...
    'decoderOutputPoisson','decoderStdevPoisson','decoderOutputGauss',...
    'decoderStdevGauss','decoderOutputBins','decoderStdevBins');
