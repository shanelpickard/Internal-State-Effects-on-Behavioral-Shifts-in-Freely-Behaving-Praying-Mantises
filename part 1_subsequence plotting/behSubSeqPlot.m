% Results part 1: plot behavior subsequences
% For each subsequence, find the behavior regime skew


%_____Load .mat data files
%animal 1
dataFiles = {'F0528B2_0 Fed_Complete_2.mat',...
             'F0528B2_1 Fed_Complete_2.mat'...
             'F0528B2_3 Fed_Complete_2.mat'...
             'F0528B2_4 Fed_Complete_2.mat'};
         
%animal 2        
dataFiles = {'F0609A_0 Fed_Complete_2.mat',...
             'F0609A_1 Fed_Complete_2.mat',...
             'F0609A_3 Fed_Complete_2.mat',...
             'F0609A_4 Fed_Complete_2.mat'};
%animal 3         
dataFiles = {'F0821A_0 Fed_Complete_2.mat',...
             'F0821A_1 Fed_Complete_2.mat',...
             'F0821A_3 Fed_Complete_2.mat',...
             'F0821A_4 Fed_Complete_2.mat'};         
         
%animal 4
dataFiles = {'F0904A_0 Fed_Complete_2.mat',...
             'F0904A_1 Fed_Complete_2.mat',...
             'F0904A_3 Fed_Complete_2.mat',...
             'F0904A_4 Fed_Complete_2.mat',...
             'F0904B_0 Fed_Complete_2.mat'};         

%animal 5         
dataFiles = {'F0904B_0 Fed_Complete_2.mat',...
             'F0904B_1 Fed_Complete_2.mat',...
             'F0904B_3 Fed_Complete_2.mat',...
             'F0904B_4 Fed_Complete_2.mat'}; 
         
%animal 6         
dataFiles = {'F0911A_0 Fed_Complete_2.mat',...
             'F0911A_1 Fed_Complete_2.mat'...
             'F0911A_2 Fed_Complete_2.mat'...
             'F0911A_3 Fed_Complete_2.mat'...
             'F0911A_4 Fed_Complete_2.mat'};       
         
%% Extract behavior and plot subsequences         
subSequence = [];
for i = 1%1:length(dataFiles)
    %_____Load data file
    currFile = load(dataFiles{i});  %saves to a data strucutre
    datCell = currFile.datCell; %extract whole matrix from s                                                                                                                                                                                                                                                                                                tructure
    clear currFile

    %_____Extract behavior
    [tmpbeh, tmpbeh_noResets] = behCoding_NBR_2_81(datCell);
    
    %_____Generate behavior subsequences
    %Generate plot of subsequence behaviors
    [tmpsubSeq, subSeqInd] = subSequenceGenerator_NBR_2_81(tmpbeh, (1:length(tmpbeh))');
    
    subSequence = [subSequence, tmpsubSeq];
end
clear tmpbeh tmpbeh_noResets tmpsubSeq i



%% Show skew of behavior subsequences


%Simple recode key: 
% 1-5  --> -1
% 6    -->  0
% 7-11 -->  1

for i = 1:length(subSequence)
    currSeq = subSequence{i};
    currSeq(currSeq < 6) = -1;
    currSeq(currSeq > 6 & currSeq < 12) = 1;
    currSeq(currSeq == 6) = 0;
    currSeq(currSeq == 12) = [];
    subSeqSimpleRecode{i} = currSeq;
    seqSimpleSkew(i) = sum(currSeq);
end
clear currSeq



% 
% %To show the skew, recode the behaviors with the following more complicated key
% % Behavior Key
% %%%%%%%%%%%%%%%%%%%%%%% Hunting Specific %%%%%%%%%%%%%%%%%%%%%%%%%%
% % 1     Successful Strike    --> -5
% % 2     Missed Strike        --> -4
% % 3     Specific Translate   --> -3
% % 4     Specific Rotation    --> -2
% % 5     Specific Monitoring  --> -1
% % 6     General Monitoring   -->  0 
% % 7     General Translation  -->  1
% % 8     General Rotation     -->  2
% % 9     Cleaning             -->  3
% % 10    Deimetic             -->  4
% % 11    Escape               -->  5
% % 12    Arena Reset          -->  6
% 
% 
% for i = 1:length(subSequence)
%     currSeq = subSequence{i};
%     currSeq(currSeq == 1) = -5;
%     currSeq(currSeq == 2) = -4;
%     currSeq(currSeq == 3) = -3;
%     currSeq(currSeq == 4) = -2;
%     currSeq(currSeq == 5) = -1;
%     currSeq(currSeq == 6) = 0;
%     currSeq(currSeq == 7) = 1;
%     currSeq(currSeq == 8) = 2;
%     currSeq(currSeq == 9) = 3;
%     currSeq(currSeq == 10) = 4;
%     currSeq(currSeq == 11) = 5;
%     currSeq(currSeq == 12) = [];
%     subSeqComplexRecode{i} = currSeq;
%     seqSComplexSkew(i) = sum(currSeq);            
% end
% clear currSeq

