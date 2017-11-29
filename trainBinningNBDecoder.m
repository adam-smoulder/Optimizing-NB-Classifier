% This is a function to learn the needed parameters for a two class 
% Naive Bayes decoder. 
%
% Usage: [classMeans, classPriors] = trainPoissonNBDecoder(trainCounts, trainLabels)
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
%   classPriors - a vector where the first entry gives the prior
%   probability for class 1 and the second entry gives the prior
%   probability for class 2. 
%
function [classPriors, ProbDist, BinThresh] = trainBinningNBDecoder(trainCounts, trainLabels, nBin)


% Works for any number of classes
labs=unique(trainLabels);
classPriors = zeros(1,length(labs));

%first need to get thresholds
BinThresh = [];
for n = 1:size(trainCounts,1) %loop through each neuron

    %get all responses for specific neuron
    cell_n_resps = trainCounts(n,:);
    cell_n_resps_sorted = sort(cell_n_resps); %sort all responses from training data 

    %get bin thresholds for this cell
    cell_n_bin_thresh = zeros(1,nBin-1);
    for b = 1:nBin-1
        bin = round((length(cell_n_resps_sorted)/nBin)*b);
        cell_n_bin_thresh(b) = cell_n_resps_sorted(bin);
    end
    BinThresh = [BinThresh ; cell_n_bin_thresh];
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
                numbers = cell_n_stim_resp_sorted(cell_n_stim_resp_sorted<=BinThresh(n,i));%for the first bin, just find everything below the first bin thresh
            elseif i == nBin
                numbers = cell_n_stim_resp_sorted(cell_n_stim_resp_sorted>BinThresh(n,i-1));%for the last bin, just find everything after the last bin tresh
            else
                numbers = cell_n_stim_resp_sorted([cell_n_stim_resp_sorted>BinThresh(n,i-1) & cell_n_stim_resp_sorted<=BinThresh(n,i)]);%for the rest of nBin, find between that bin thresh and the next
            end
        end
    end
    %get class priors
    classPriors(stim)=length(labinds_i)/length(trainLabels);
end       
    
    


end
