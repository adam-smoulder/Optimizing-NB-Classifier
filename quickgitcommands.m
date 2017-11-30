% Getting your git repo set up in MATLAB, by Adam :)

%% SETUP
% Step 1: on the MATLAB Home tab, go to Add-Ons, search "git", and select
% the one called "A thin MATLAB wrapper for the Git source control system" 
% 
% Install this, and add it to your filepath - I think once you've done this
% once it runs like that forever. This add-on lets you use MATLAB's command
% line instead of a terminal or separate git command line.

% Step 2: Follow these instructions:
% https://www.mathworks.com/help/matlab/matlab_prog/set-up-git-source-control.html
% Make sure you're located in the directory where you'll be adding your git
% repo - so essentially, the folder that contains your folder with all of
% our project stuff. Do everything there until the Add Git Submodules part 
% - idk what that is, lol.  If you get stuck let me know.

% Step 3: go to github.com and make an account if you don't already have
% one. Record your username and password!

% Step 4: go to this link
% https://services.github.com/on-demand/downloads/github-git-cheat-sheet.pdf
% and run the following through MATLAB's command line (based on the doc):
% 
git config --global user.name "insertYourUsername-here"
git config --global user.email "whateverIsYourEmailForGithub@hell.com"
git clone https://github.com/adam-smoulder/Optimizing-NB-Classifier.git
% 
% This should have you setup for the project, with the most recent stuff
% from the remote repo cloned down! This also setup your computer's stuff
% with your github username and email to track commits. You're now set to
% go!

%% Using your newfound power
% 1. Getting the latest:
% Whenever somebody has updated the remote repo, you need to pull the
% latest changes to your local repo. To do this, simply use:
git pull
% ^when you're in the directory for the repo on your local
%
% 2. Preparing to push - adding and committing:
% As you make changes, you can create "commits" which are essentially
% groups of changes that you're grouping together. First, for whatever
% files you've changed, you need to add it to your repo cache using:
git add fileName.m otherFileName.m myDataset.mat
% simply putting a space between each file you want to update. You can add
% in separate commands or whatever. To check what you currently have saved,
% 

% for terminal:
% cd Documents/MATLAB/classes/NeuralDataAnalysis/~proj/Optimizing-NB-Classifier
% git push

% for adding
% git add decodeWrapper.m decodeScript.m gaussianNBDecode.m generate_data_PS.m
% git commit