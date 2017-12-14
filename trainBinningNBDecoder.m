% Lavanya Krishna, Michael Shteyn, Adam Smoulder, Pati Stan
% Neural Data Analysis
% Last Updated: 12/12/17

% This is a function to train the binning Naive Bayes decoder. 

function [classPriors, probDist, binThresh] = trainBinningNBDecoder(trainCounts, trainLabels, nBin)

labs=unique(trainLabels); %get number of stimuli
classPriors = zeros(1,length(labs)); %create matrix to store priors for each stimulus

%first need to get thresholds
binThresh = [];
for n = 1:size(trainCounts,1) %loop through each neuron

    %get all responses for specific neuron
    cell_n_resps = trainCounts(n,:);
    cell_n_resps_sorted = sort(cell_n_resps); %sort all responses from training data 

    %get bin thresholds for this cell
    cell_n_bin_thresh = zeros(1,nBin-1);                    %will have bins-1 thresholds
    for b = 1:nBin-1                                        %for each threshold
        bin = round((length(cell_n_resps_sorted)/nBin)*b);  %get what that that threshold will be based on keeping the total number 
        cell_n_bin_thresh(b) = cell_n_resps_sorted(bin);    %of responses from all training data even between the bins
    end
    binThresh = [binThresh ; cell_n_bin_thresh];
end

%fill in matrix of probabilities of response for each bin

%start looping through each stim
for stim = 1:length(labs)
    for n = 1:size(trainCounts,1) %for each cell
        % Find indices corresponding to label i
        labinds_i=find(trainLabels==labs(stim));
        cell_n_stim_resp = trainCounts(n,labinds_i);
        cell_n_stim_resp_sorted = sort(cell_n_stim_resp);

        %get probability for each bin
        for i = 1:nBin
            if i == 1
                numbers = find(cell_n_stim_resp_sorted<=binThresh(n,i));%for the first bin, just find everything below the first bin thresh
            elseif i == nBin
                numbers = find(cell_n_stim_resp_sorted>binThresh(n,i-1));%for the last bin, just find everything after the last bin tresh
            else
                numbers = find(cell_n_stim_resp_sorted>binThresh(n,i-1) & cell_n_stim_resp_sorted<=binThresh(n,i));%for the rest of nBin, find between that bin thresh and the next
            end
            cell_N_prob = length(numbers)/length(cell_n_stim_resp);%calc probability for that bin
            probDist{1,stim}{n,i} = cell_N_prob;
        end
    end
    %get class priors
    classPriors(stim)=length(labinds_i)/length(trainLabels);
end       
    
end
