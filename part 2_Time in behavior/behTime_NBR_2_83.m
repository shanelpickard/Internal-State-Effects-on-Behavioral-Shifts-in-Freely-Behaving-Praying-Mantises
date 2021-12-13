% Time in behavior NBR-2-83


dataFiles = {'F0528B2_0 Fed_Complete_2.mat',...% animal 1
             'F0528B2_1 Fed_Complete_2.mat'...
             'F0528B2_2 Fed_Complete_2.mat'...
             'F0528B2_3 Fed_Complete_2.mat'...
             'F0528B2_4 Fed_Complete_2.mat'...
             'F0609A_0 Fed_Complete_2.mat',...% animal 2
             'F0609A_1 Fed_Complete_2.mat',...
             'F0609A_2 Fed_Complete_2.mat',...
             'F0609A_3 Fed_Complete_2.mat',...
             'F0609A_4 Fed_Complete_2.mat',...
             'F0821A_0 Fed_Complete_2.mat',...% animal 3
             'F0821A_1 Fed_Complete_2.mat',...
             'F0821A_2 Fed_Complete_2.mat',...
             'F0821A_3 Fed_Complete_2.mat',...
             'F0821A_4 Fed_Complete_2.mat',...
             'F0904A_0 Fed_Complete_2.mat',...% animal 4
             'F0904A_1 Fed_Complete_2.mat',...
             'F0904A_2 Fed_Complete_2.mat',...
             'F0904A_3 Fed_Complete_2.mat',...
             'F0904A_4 Fed_Complete_2.mat',...
             'F0904B_0 Fed_Complete_2.mat',...% animal 5
             'F0904B_1 Fed_Complete_2.mat',...
             'F0904B_2 Fed_Complete_2.mat',...
             'F0904B_3 Fed_Complete_2.mat',...
             'F0904B_4 Fed_Complete_2.mat',...
             'F0911A_0 Fed_Complete_2.mat',...% animal 6
             'F0911A_1 Fed_Complete_2.mat'...
             'F0911A_2 Fed_Complete_2.mat'...
             'F0911A_3 Fed_Complete_2.mat'...
             'F0911A_4 Fed_Complete_2.mat'...
             };


         
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
         
feedLabelRef = [0 1 2 3 4 0 1 2 3 4 0 1 2 3 4 0 1 2 3 4 0 1 2 3 4 0 1 2 3 4];
animalLabelRef = [1 1 1 1 1 2 2 2 2 2 3 3 3 3 3 4 4 4 4 4 5 5 5 5 5 6 6 6 6 6];
behRef = [1:12];
behSize = length(behRef);

%% Create data matrices
counter = 1;
identifiers = [];
subSeqComplete = [];
for i =1:length(dataFiles)
    %___________________________________________
    % SETUP: Extract behavior coding vectors    
    %Open and load current data matrix .mat file
    currFile = load(dataFiles{i});  %saves to a data strucutre
    datCell = currFile.datCell; %extract whole matrix from structure
    clear currFile
    
    %___________________________________________
    % STEP 1: Extract behavior coding vectors
    [beh, beh_noResets] = behCoding_NBR_2_81(datCell);
    clear beh_noResets
    
    %___________________________________________
    % STEP 2: Generate subsequences behaviors
    [subSequence, subSeqInd] = subSequenceGenerator_NBR_2_81(beh, (1:length(beh))');
    subSeq{i} = subSequence;
    %___________________________________________
    % STEP 3: Concatenate all the subsequences into one variable
    
    currAnimal = animalLabelRef(i);
    currFeed = feedLabelRef(i);

    tmpAnimalArray = (currAnimal * ones([length(subSequence),1]))';
    tmpFeedArray = (currFeed * ones([length(subSequence),1]))';
    tmpSeqNum = [1:length(subSequence)];
    tmpID = [tmpAnimalArray; tmpFeedArray; tmpSeqNum];
    identifiers = [identifiers, tmpID];
    subSeqComplete = [subSeqComplete subSequence];

    
    
    clear tmpAnimalArray tmpFeedArray tmpSeqNum tmpID currAnimal currFeed...
    
    counter = counter + 1;
end
clear currSeq totNum numCurrBeh i j counter

%% Count missed and successful strikes

for i = 1:length(subSeqComplete)
    currsubSeq =  subSeqComplete{i};
    tmpMiss = numel(find(currsubSeq == 2));
    numMiss(i) = tmpMiss;
    
    tmpSuccess = numel(find(currsubSeq == 1));
    numSuccess(i) = tmpSuccess;
    
    %Count number of escape attempts
    tmpEscape = find(currsubSeq == 11);  %find indices of escape
    if ~isempty(tmpEscape)
        tmpDiff = diff(tmpEscape);
        tmpNumEscape = numel(find(tmpDiff > 1)) + 1; %Find how many ranges of escape
        numEscape(i) = tmpNumEscape;
    else
        numEscape(i) = 0;
    end
    clear tmpEscape tmpDiff tmpNumEscape
    
    %Count numer of deimatic instances
    tmpDeimatic = find(currsubSeq == 10);  %find indices of deimatic
    if ~isempty(tmpDeimatic)
        tmpDiff = diff(tmpDeimatic);
        tmpNumDeimatic = numel(find(tmpDiff > 1)) + 1; %Find how many ranges of escape
        numDeimatic(i) = tmpNumDeimatic;
    else 
        numDeimatic(i) = 0;
    end
    clear tmpDiff tmpNumDeimatic tmpDiff
    
    
   %Get subsequence length 
    subSeqLength(i) = length(currsubSeq); % Get the overall length
   %Find skew of subsequence (hunting vs non-hunting)
        currSeq = currsubSeq;
        currSeq(currSeq < 6) = -1;
        currSeq(currSeq > 6 & currSeq < 12) = 1;
        currSeq(currSeq == 6) = 0;
        currSeq(currSeq == 12) = [];
        skew(i) = sum(currSeq);
   
end
clear currsubSeq tmpMiss tmpSuccess i tmpEscape tmpDiff tmpNumEscape tmpDeimatic

%% Number of frames for each each behavior in each subsequence
%For each of the 11 binned behaviors
numBeh = 11;

for i = 1:size(subSeqComplete,2)
    
    %Current subsequence
    currSubSeq = subSeqComplete{i};
    numFrame = size(currSubSeq,1); %total number of frames in this subseq
    
    %Interate through each behavior designation in current subseq
    for j = 1:numBeh
        %Find the relative proportion of time in each state for each subSeq
        rawBehTime = sum(currSubSeq(:) == j); %total number of curr beh frames
        proportionBehTime(j,i)= rawBehTime/numFrame;

        %Find the number of beh frames in each chunk in this sequence
        %only do for behaviors that have ranges
        if j > 2 %if this is a beh that can have ranges
            tmpBehInd = find(currSubSeq == j); %find inds for curr beh
            diffVec = diff(tmpBehInd); %find where ranges of beh end (not 1)
            diffInd = find(diffVec > 1); %find where these range jumps occur
            
            %Find the # frame ranges for the current behavior in this beh
            %subseq
            if ~isempty(diffInd)
                for m = 1:(length(diffInd) + 1)
                    if m==1  %if the first ind
                        tmpBehLen(m) = diffInd(1);
                    elseif m == (length(diffInd) + 1) %if the last ind
                        tmpBehLen(m) = length(tmpBehInd) - diffInd(m-1);
                    else
                        tmpBehLen(m) = diffInd(m) - diffInd(m-1);
                    end 
                end
                tmpFrameRange{j} = tmpBehLen;
                clear tmpBehLen
            else
                tmpFrameRange{j} = length(tmpBehInd);
            end
        else
           tmpFrameRange{j} = rawBehTime;
        end
    end
    behFrameRange{i} = tmpFrameRange;
end
clear currSubSeq i j m numBeh numFrame tmpBehLen diffInd diffVec tmpBehInd rawBehTime tmpFrameRange


%% Assemble final data matrix

behTimeComplete = [identifiers', proportionBehTime', numMiss',...
                  numSuccess', numEscape', numDeimatic'];

              
%% Assemble final matrix for beh time ranges

behTimeRangeComplete = [];
for i = 1:length(behFrameRange)
    currRanges = behFrameRange{i};
    currID = identifiers(:,i);
    for j = 1:length(currRanges)
        tmpBehBin = currRanges{j};
        currBehBin = j * ones([length(tmpBehBin) ,1]);
        tmpID = repmat(currID', [length(tmpBehBin),1]);
        
        
        tmpMat = [tmpID, currBehBin, tmpBehBin'];
        behTimeRangeComplete = [behTimeRangeComplete; tmpMat];
    end
end

clear currRanges tmpBehBin i j tmpID tmpMat currBehBin currID



%% Starting behavior
%Find the starting behavior bin for each subsequence

for i = 1: length(subSeqComplete)
    currSeq = subSeqComplete{i};
    firstBeh(i) = currSeq(1);
end


% Sort prob matrices by feed state
tmpInd = find(identifiers(2,:)==0);
firstBeh0 = firstBeh(1,tmpInd);

tmpInd = find(identifiers(2,:)==1);
firstBeh1 = firstBeh(1,tmpInd);

tmpInd = find(identifiers(2,:)==2);
firstBeh2 = firstBeh(1,tmpInd);

tmpInd = find(identifiers(2,:)==3);
firstBeh3 = firstBeh(1,tmpInd);

tmpInd = find(identifiers(2,:)==4);
firstBeh4 = firstBeh(1,tmpInd);


%% Length of subsequences by feed state

%record subsequence lengths into a single vector
for i = 1:length(subSeqComplete)
    subLength(i) = length(subSeqComplete{i});
end


seqLengthComplete = [identifiers; subLength];



% % Sort prob matrices by feed state
% tmpInd = find(identifiers(2,:)==0);
% behLength0 = subLength(1,tmpInd);
% 
% tmpInd = find(identifiers(2,:)==1);
% behLength1 = subLength(1,tmpInd);
% 
% tmpInd = find(identifiers(2,:)==2);
% behLength2 = subLength(1,tmpInd);
% 
% tmpInd = find(identifiers(2,:)==3);
% behLength3 = subLength(1,tmpInd);
% 
% tmpInd = find(identifiers(2,:)==4);
% behLength4 = subLength(1,tmpInd);
% 
% subSeqLength = [behLength0 behLength1 behLength2 behLength3 behLength4];





