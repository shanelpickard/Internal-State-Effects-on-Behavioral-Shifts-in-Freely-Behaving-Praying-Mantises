% NBR-2-86

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

%% Extract behavior and plot subsequences         
subSequence_noReset = [];
header = [];
subSeqLength = [];
for i = 1:length(dataFiles)
    %___________________________________________
    % SETUP: Extract behavior coding vectors    
    %Open and load current data matrix .mat file
    currFile = load(dataFiles{i});  %saves to a data strucutre
    datCell = currFile.datCell; %extract whole matrix from structure
    clear currFile
    
    %___________________________________________
    % STEP 1: Extract behavior coding vectors
    [beh, beh_noResets] = behCoding_NBR_2_81(datCell);
    
    %___________________________________________
    % STEP 2: Generate subsequences behaviors
    [tmpSubSequence, tmpSubSequence_noReset] = subSequenceGenerator_NBR_2_81(beh, (1:length(beh))');
    

    %___________________________________________
    % STEP 3: Generate probability matrices for each subsequence and string
    % out vertically
    currAnimal = animalLabelRef(i);
    currFeed = feedLabelRef(i);
    
    for j = 1:size(tmpSubSequence,2)
        currSubSeq = j;
        
        %make identifer vector
        tmpHeader = [currAnimal; currFeed; currSubSeq];
        header = [header, tmpHeader];
        subSeqLength = [subSeqLength, length(tmpSubSequence_noReset{j})];
    end
    clear currAnimal currFeed currSubSeq tmpHeader
    
    subSequence_noReset = [subSequence_noReset, tmpSubSequence_noReset];
end
clear counter i j 

%% Heatmap of raw behaviors of subsequences

maxLength = max(subSeqLength,2);
seqPadded = [];
for i = 1:size(subSequence_noReset,2)
    currVec = subSequence_noReset{i};
    
    %Add current vector with tmpVec to get max length 
    tmpVecMax = [currVec; zeros(maxLength-length(currVec), 1)];
    seqPadded = [seqPadded, tmpVecMax];
end
clear tmpVecMax currVec

% Sort the reorganized prob matrices to be ordered by feed state
tmpInd = find(header(2,:)==0);
probMat0 = seqPadded(:,tmpInd);

tmpInd = find(header(2,:)==1);
probMat1 = seqPadded(:,tmpInd);

tmpInd = find(header(2,:)==2);
probMat2 = seqPadded(:,tmpInd);

tmpInd = find(header(2,:)==3);
probMat3 = seqPadded(:,tmpInd);

tmpInd = find(header(2,:)==4);
probMat4 = seqPadded(:,tmpInd);

SeqOrdered = [probMat0 probMat1  probMat2 probMat3 probMat4];

%clear probMat0 probMat1  probMat2 probMat3 probMat4 maxLength



%h = heatmap(SeqOrdered, 'Colormap',jet);
h = heatmap(SeqOrdered, 'ColorLimits',[0 1], [0 0 1], 'GridVisible','off')
hold on


color= generatecolormapthreshold([0 1 5 6 12],[1 1 1; 1 0 0; 0 0 0; 0 0 1]);
h = heatmap(SeqOrdered,'Colormap',color,'ColorLimits',[0 12], 'GridVisible','off');
Ax = gca;
Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
Ax.YDisplayLabels = nan(size(Ax.YDisplayData));