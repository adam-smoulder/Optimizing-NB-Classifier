% Team LAMP, Neural Data Analysis
% Last Updated: 11/28/17
% The purpose of the script is to wrap the decoder function and run it for every
% permutation of conditions (# of neurons, # of trials, # of folds, if time permits,
% # of bins).
tic

fileNameToSave = 'poisson_dataset_12stim';

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
binMax = 10;		% maximum number of bins
%binStep = 1;		% difference between input bins quantities
binStep = 5; % FAKE VAL FOR TEST

% establish vectors for differing conditions
neuronConds = neuronMin : neuronStep : neuronMax;
trialConds = trialMin : trialStep : trialMax;
binConds = binMin : binStep : binMax;
foldConds = [1 5];
nPerm = 10;

%% Perform decoding for each condition, output dims: #neurons x #trials x #folds
% poisson decoder, with and without cross-val
decoderOutputPoisson = nan(length(neuronConds), length(trialConds));
decoderOutputPoissonCV = nan(length(neuronConds), length(trialConds), foldConds(2));
decoderStdevPoisson = nan(length(neuronConds), length(trialConds));
decoderStdevPoissonCV = nan(length(neuronConds), length(trialConds), foldConds(2));

% gaussian decoder, with and without cross-val
decoderOutputGauss = nan(length(neuronConds), length(trialConds));
decoderOutputGaussCV = nan(length(neuronConds), length(trialConds), foldConds(2));
decoderStdevGauss = nan(length(neuronConds), length(trialConds));
decoderStdevGaussCV = nan(length(neuronConds), length(trialConds), foldConds(2));

% binned decoding, with and without cross-val
decoderOutputBins = nan(length(neuronConds), length(trialConds), length(binConds));
decoderOutputBinsCV = nan(length(neuronConds), length(trialConds), length(binConds), foldConds(2));
decoderStdevBins = nan(length(neuronConds), length(trialConds),length(binConds));
decoderStdevBinsCV = nan(length(neuronConds), length(trialConds), length(binConds), foldConds(2));

for ii = 1:length(neuronConds)
    for jj = 1:length(trialConds)
        clear pAccur nNeuron nTrial nFold dataToUse accuracy set_size ...
            test_data train_data testLabels trainLabels classMeans classPriors ...
            estTestLabels trainCounts testCounts data_logical_vector permutationResult
        
        % get current loops # neurons and trials
        nNeuron = neuronConds(ii);
        nTrial = trialConds(jj);
        
        %if floor(nTrial/nFold) < 2 % not enough test trials!
        %WE ARE ASSUMING THAT THE MINIMUM TRIAL#/FOLD# is 1!!
        
        
         % run each type of decoder
         
         % poisson
         decoderType = 'poisson';
         nFold = 1; % don't cross validate
         decodeScript % perform decoding!
         decoderOutputPoisson(ii,jj) = decoderResult;
         decoderStdevPoisson(ii,jj) = decoderStdev;
         
         nFold = foldConds(2); % cross validate
         decodeScript % perform decoding!
         decoderOutputPoissonCV(ii,jj,:) = decoderResult;
         decoderStdevPoissonCV(ii,jj,:) = decoderStdev;
         
         % comment this out for long runs...
         disp(['poisson n=' num2str(nNeuron), ' t=' num2str(nTrial) ' f=' ...
             num2str(nFold) ' - accuracy: ' num2str(decoderResult) '%'...
             ', stdev: ' num2str(decoderStdev)]);
         
         % gaussian
         decoderType = 'gaussian';
         nFold = 1; % don't cross validate
         decodeScript % perform decoding!
         decoderOutputGauss(ii,jj) = decoderResult;
         decoderStdevGauss(ii,jj) = decoderStdev;
         
         nFold = foldConds(2); % cross validate
         decodeScript % perform decoding!
         decoderOutputGaussCV(ii,jj,:) = decoderResult;
         decoderStdevGaussCV(ii,jj,:) = decoderStdev;

         % comment this out for long runs...
         disp(['gauss n=' num2str(nNeuron), ' t=' num2str(nTrial) ' f=' ...
             num2str(nFold) ' - accuracy: ' num2str(decoderResult) '%'...
             ', stdev: ' num2str(decoderStdev)]);
         
         decoderType = 'bins';
         for ll = 1:length(binConds)
             nBins = binConds(ll); % for a given number of bins
             nFold = 1; % don't cross validate
             decodeScript % perform decoding!
             decoderOutputBins(ii,jj,ll) = decoderResult;
             decoderStdevBins(ii,jj,ll) = decoderStdev;
             nFold = foldConds(2); % cross validate
             decodeScript % perform decoding!
             decoderOutputBinsCV(ii,jj,ll,:) = decoderResult;
             decoderStdevBinsCV(ii,jj,ll,:) = decoderStdev;
         end
         
         % comment this out for long runs...
         disp(['bins n=' num2str(nNeuron), ' t=' num2str(nTrial) ' f=' ...
             num2str(nFold) ' - accuracy: ' num2str(decoderResult) '%'...
             ', stdev: ' num2str(decoderStdev)]);
    end
end

toc

% check how the folds improved accuracy!
averagePoissonFoldOutput = mean(decoderOutputPoissonCV,3);
averageGaussFoldOutput = mean(decoderOutputGaussCV,3);
diffPoisson = averagePoissonFoldOutput-decoderOutputPoisson;
diffGauss = averageGaussFoldOutput - decoderOutputGauss;

avgDiffPoisson = mean(mean(diffPoisson));
avgDiffGauss = mean(mean(diffGauss));

disp('Average improvements from folding:')
disp(['Poisson: ' num2str(avgDiffPoisson) '%'])
disp(['Gauss: ' num2str(avgDiffGauss) '%'])

%% if desired, save the output
save(fileNameToSave,'neuronConds','trialConds','foldConds','binConds',...
    'decoderOutputPoisson','decoderOutputPoissonCV','decoderStdevPoisson',...
    'decoderStdevPoissonCV', 'decoderOutputGauss','decoderOutputGaussCV',...
    'decoderStdevGauss','decoderStdevGaussCV','decoderOutputBins',...
    'decoderOutputBinsCV','decoderStdevBins','decoderStdevBinsCV');

% %% old bs testing stuff
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