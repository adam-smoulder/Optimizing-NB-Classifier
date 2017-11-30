% Team LAMP, Neural Data Analysis
% Last Updated: 11/29/17
% The purpose of the script is to wrap the decoder function and run it for every
% permutation of conditions (# of neurons, # of trials, # of folds, if time permits,
% # of bins).

fileNameToSave = 'poisson_dataset_12stim_asdf';

% ENSURE THAT OUTPUT DIRECTORY IS PREPARED FOR SAVING DATA IF NEEDED
%% Variable declaration
% declare conditions the decoder will be used for

neuronMin = 1;		% minimum number of neurons
%neuronMax = 100;     % maximum number of neurons
neuronMax = 31; % FAKE VAL FOR TEST
%neuronStep = 1;     % difference between input neuron quantities
neuronStep = 5; % FAKE VAL FOR TEST

trialMin = 5;		% minimum number of trials (per stimulus)
trialMax = 50;		% maximum number of trials
%trialStep = 1;		% difference between input trial quantities
trialStep = 10; % FAKE VAL FOR TEST

binMin = 2;         % minimum number of bins
binMax = 22;		% maximum number of bins
%binStep = 1;		% difference between input bins quantities
binStep = 4; % FAKE VAL FOR TEST

% establish vectors for differing conditions
neuronConds = neuronMin : neuronStep : neuronMax;
trialConds = trialMin : trialStep : trialMax;
binConds = binMin : binStep : binMax;
nPerm = 1;
nFold = 5;

%% Perform decoding for each condition, output dims: #neurons x #trials x #folds
tic

% poisson decoder, with and without cross-val
decoderOutputPoisson = nan(length(neuronConds), length(trialConds), nFold);
decoderStdevPoisson = nan(length(neuronConds), length(trialConds));

% gaussian decoder, with and without cross-val
decoderOutputGauss = nan(length(neuronConds), length(trialConds), nFold);
decoderStdevGauss = nan(length(neuronConds), length(trialConds));

% binned decoding, with and without cross-val
decoderOutputBins = nan(length(neuronConds), length(trialConds), length(binConds), nFold);
decoderStdevBins = nan(length(neuronConds), length(trialConds), length(binConds));

for ii = 1:length(neuronConds)
    for jj = 1:length(trialConds)
        clear pAccur nNeuron nTrial nFold dataToUse accuracy set_size ...
            test_data train_data testLabels trainLabels classMeans classPriors ...
            estTestLabels trainCounts testCounts data_logical_vector permutationResult
        
        % get current loops # neurons and trials
        nNeuron = neuronConds(ii);
        nTrial = trialConds(jj);
        
        %WE ARE ASSUMING THAT THE MINIMUM TRIAL#/FOLD# is 1!!
        
         % run each type of decoder
         
         % poisson
         decoderType = 'poisson';
         decodeScript % perform decoding!
         decoderOutputPoisson(ii,jj,:) = decoderResult;
         decoderStdevPoisson(ii,jj) = decoderStdev;
         
         % comment this out for long runs...
         disp(['poisson n=' num2str(nNeuron), ' t=' num2str(nTrial) ' f=' ...
             num2str(nFold) ' - accuracy: ' num2str(decoderResult) '%'...
             ', stdev: ' num2str(decoderStdev)]);
         
         % gaussian
         decoderType = 'gaussian';
         decodeScript % perform decoding!
         decoderOutputGauss(ii,jj,:) = decoderResult;
         decoderStdevGauss(ii,jj) = decoderStdev;

         % comment this out for long runs...
         disp(['gauss n=' num2str(nNeuron), ' t=' num2str(nTrial) ' f=' ...
             num2str(nFold) ' - accuracy: ' num2str(decoderResult) '%'...
             ', stdev: ' num2str(decoderStdev)]);
         
         decoderType = 'bins';
         for ll = 1:length(binConds)
             nBins = binConds(ll); % for a given number of bins
             decodeScript % perform decoding!
             decoderOutputBins(ii,jj,ll,:) = decoderResult;
             decoderStdevBins(ii,jj,ll) = decoderStdev;
             % comment this out for long runs...
             disp(['bins n=' num2str(nNeuron), ' t=' num2str(nTrial) ' f=' ...
                 num2str(nFold) ' - accuracy: ' num2str(decoderResult) '%'...
                 ', stdev: ' num2str(decoderStdev)]);
         end
         
         disp(['completed n = ' num2str(neuronConds(ii)) ' t = ' num2str(trialConds(jj))])
    end
end

toc

% check how the folds improved accuracy!
averagePoissonFoldOutput = mean(decoderOutputPoisson,3);
averageGaussFoldOutput = mean(decoderOutputGauss,3);
diffPoisson = averagePoissonFoldOutput-squeeze(decoderOutputPoisson(:,:,1));
diffGauss = averageGaussFoldOutput - squeeze(decoderOutputGauss(:,:,1));

avgDiffPoisson = mean(mean(diffPoisson));
avgDiffGauss = mean(mean(diffGauss));

disp('Average improvements from folding:')
disp(['Poisson: ' num2str(avgDiffPoisson) '%'])
disp(['Gauss: ' num2str(avgDiffGauss) '%'])

%% if desired, save the output
save(fileNameToSave,'neuronConds','trialConds','binConds','nFold',...
    'decoderOutputPoisson','decoderStdevPoisson','decoderOutputGauss',...
    'decoderStdevGauss','decoderOutputBins','decoderStdevBins');

%% old bs testing stuff
% figure
% trialNum = 5;
% foldNum = 1;
% vals = [3 6 9];
% 
% title(['neuron x-axis, trials = ', num2str(trialConds(vals)),' folds = ' num2str(foldConds(foldNum))])
% hold on
% for i = vals
%     plot(neuronConds,squeeze(decoderOutput(:,i,foldNum)),'LineWidth',2);
% end
% legend(num2str(trialConds(vals(1))), num2str(trialConds(vals(2))), ...
%     num2str(trialConds(vals(3))))

% title(['fold x-axis, trials = ' num2str(trialNum)])
% hold on
% for i = [3 6 7]
%     plot(foldConds,squeeze(decoderOutput(i,trialNum,:)),'LineWidth',2);
% end
%legend('5', '17', '29')


%plot(neuronConds,squeeze(decoderOutput(:,trialNum,foldNum)),'LineWidth',2)
