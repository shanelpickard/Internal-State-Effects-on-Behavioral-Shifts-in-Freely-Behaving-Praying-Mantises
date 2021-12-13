%Levenshtein distance NBR-2-83
% Globally align two sequences 


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

              
feedLabelRef = [0 1 2 3 4 0 1 2 3 4 0 1 2 3 4 0 1 2 3 4 0 1 2 3 4 0 1 2 3 4];
animalLabelRef = [1 1 1 1 1 2 2 2 2 2 3 3 3 3 3 4 4 4 4 4 5 5 5 5 5 6 6 6 6 6];
behRef = [1:12];
behSize = length(behRef);

%% Create data matrices

subSeqComplete = [];
identifiers = [];
probVertComplete = [];
counter = 1;
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
    behDoc{i} = beh;
    clear beh_noResets
    
    %___________________________________________
    % STEP 2: Generate subsequences behaviors
    [subSequence, subSeqInd] = subSequenceGenerator_NBR_2_81(beh, (1:length(beh))');

    %___________________________________________
    % STEP 3: Concatenate all the subsequences into one variable
    
    currAnimal = animalLabelRef(i);
    currFeed = feedLabelRef(i);

    tmpAnimalArray = (currAnimal * ones([length(subSequence),1]))';
    tmpFeedArray = (currFeed * ones([length(subSequence),1]))';
    tmpSeqNum = [1:length(subSequence)];
    tmpID = [tmpAnimalArray; tmpFeedArray; tmpSeqNum];
    identifiers = [identifiers, tmpID];
    subSeqComplete = [subSeqComplete, subSequence];
    
    clear tmpAnimalArray tmpFeedArray tmpSeqNum tmpID
    
    
    %___________________________________________
    % STEP 4: Generate probability matrices for each subsequence
    probMatrix = [];
    for j = 1:size(subSequence,2)
        [~, tmpProbMatrix] = transitionProbMatrix_NBR_2_81(subSequence{j});
        %rawMatrix(:,:,j) = tmpRawMatrix;
        probMatrix(:,:,j) = tmpProbMatrix;
        probMatrixLayers{counter} = tmpProbMatrix;
        counter = counter + 1;
    end
    clear tmpRawMatrix tmpProbMatrix 

    
    %___________________________________________
    % STEP 5: String out Vertically each subsequence prob matrix
    % Stack each row into a column vector

    probVert = [];
    for j = 1:size(probMatrix,3)

       %tmpRaw = rawMatrix(:,:,j)';
       %rawVert = [rawVert, tmpRaw(:)]; %each row stacks vertically

       tmpProb = probMatrix(:,:,j)';
       probVert = [probVert, tmpProb(:)]; %each row stacks vertically
     
    end
    clear tmpRaw tmpProb  tmpSeqNum
  
    probVertComplete = [probVertComplete, probVert];
end

for i = 1:length(subSeqComplete)
    currSeq = subSeqComplete{i};
    totNum = length(currSeq);
    
    %Find stationary probability of each behavior --> Ni/Ntot
    for j = 1:length(behRef)
        %num of instances of current behavior
        numCurrBeh = numel(find(currSeq == j));
        stationaryProb(j,i) = numCurrBeh/totNum;
    end
    
end
clear currSeq totNum numCurrBeh i j counter


%% Turn behavior subsequences into strings of letters
%Turn each subsequence into a string of letters that works with matlab
%function

%______Behavior subsequence --> subsequence
for i = 1:length(subSeqComplete)
    
    %current subsequence behavior string
    currBehSeq = subSeqComplete{i}; %raw beh sequence

    currBehStr = categorical(currBehSeq,[1 2 3 4 5 6 7 8 9 10 11 12],...
                     {'A' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'K' 'L' 'M' 'N'})';

    currBehStr = char(currBehStr)';

    subSeqStr{i} = currBehStr;
                                              
end
clear currBehSeq currBehStr




%% Alignment score metric
%Needleman–Wunsch string alignment
%nwalign score uses a built in scoring to assess alignment score

%_______Compare subsequence to subsequence
counter = 1;
for i = 1:length(subSeqStr)
    for j = 1:length(subSeqStr)
        [tmpScore, tmpAlign] = nwalign(subSeqStr{i},subSeqStr{j});
        alignStrScore(counter,1) = tmpScore;
        alignmentStr{counter} = tmpAlign;
        compareStr1(counter,:) = identifiers(:,i)';
        compareStr2(counter,:) = identifiers(:,j)';
        counter = counter + 1;
    end 
end
clear counter tmpScore tmpAlign


% %_______Compare doc to doc
% counter = 1;
% for i = 1:length(behDocStr)
%     for j = 1:length(behDocStr)
%         [tmpScore, tmpAlign] = nwalign(subSeqStr{i},subSeqStr{j});
%         alignDocScore(counter,1) = tmpScore;
%         alignmentDoc{counter} = tmpAlign;
%         
%         %generate the identifiers of the animal and feed state
%         compareDoc1(:, counter) = [animalLabelRef(i); feedLabelRef(i)];
%         compareDoc2(:, counter) = [animalLabelRef(j); feedLabelRef(j)];
%         counter = counter + 1;
%     end 
% end
% clear counter tmpScore tmpAlign


%Generate final matrices for the seq-seq comparisons and doc-doc
%comparisons

%alignScoreComplete_subSeq = [compareStr1 alignStrScore compareStr2];

%alignScoreComplete_Doc = [compareDoc1' alignDocScore compareDoc2'];

%% Levenshtein distance (LD) distance
% Used Needleman–Wunsch string alignment from previous step to optimize
% alignment
%for each alignment cell array; the middle row of symbols denotes matched and
%unmatched behaviors

for i = 1:length(alignmentStr)
    currStrCompare  = alignmentStr{i};
    currSymRow =  currStrCompare(2,:);
    numStrMatched(i) = numel(find(currSymRow == '|'));
    numStrMissed(i) = numel(find(currSymRow == ':'));
    numStrMisAlign(i) = numel(find(currSymRow == ' '));
    strLD(i) = numStrMissed(i) + numStrMisAlign(i);
    alignStrRatio(i) = strLD(i)/numStrMatched(i);
end
clear currStrCompare currSymRow


LD_StrComplete = [compareStr1, numStrMatched', numStrMissed',...
                  numStrMisAlign', strLD', alignStrRatio', compareStr2];


