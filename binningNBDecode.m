% Lavanya Krishna, Michael Shetyn, Adam Smoulder, Pati Stan
% Neural Data Analysis
% Last Updated: 12/12/17

%Naive Bayes decoder using binning thresholds 

function estLabels = binningNBDecode(testCounts, classPriors, probDist, binThresh)


ntrials=size(testCounts,2); %total number of trials
PPC = zeros(length(probDist), ntrials); % stim x trials
for trial = 1:ntrials %for each test trial
    trial_responses = testCounts(:,trial); %get all cell responses for that trial
    %first need to convert raw responses to what bin that response was
    N_bin_all = zeros(length(trial_responses),1);
    for n = 1:size(testCounts,1)                        %for each neuron
        N_resp = trial_responses(n);                    %get the neuron's response
        N_thresh = binThresh(n,:);                      %get the neuron's thresholds
        N_thresh_resp_sort = sort([N_thresh N_resp]);   %add the response to the list of thresholds and sort
        N_bin = find(N_thresh_resp_sort==N_resp,1);     %find location of that response within thresholds, which gives the bin
        N_bin_all(n,1)= N_bin;                          %store bin 
    end
    %
    for stim = 1:length(probDist)
        probabilities = probDist{stim};                                       %get probabilities for this stim
        bin_probabilities = diag(cell2mat(probabilities(:,N_bin_all)))+0.001; %get probabilities for each bin, add .001 to avoid log(0)
        LLC = sum(log(bin_probabilities));                                    %log likelihood
        PPC(stim,trial) = LLC+log(classPriors(stim));                         %add prior
    end
end
[maxes, estLabels] = max(PPC); %get estimate labels

end
