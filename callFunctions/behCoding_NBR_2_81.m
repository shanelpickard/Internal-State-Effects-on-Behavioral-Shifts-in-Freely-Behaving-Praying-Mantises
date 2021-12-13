function [behCol, behCol_noReset,...
          roachPos, mantisEyePos, mantisHead] = behCoding_NBR_2_81(datCell)
%
% For notebook entry, reference: NBR-2-81
%
%
%Extract the column of data corresponding to behavior designation
% and recode

% Inputs:
%
%   datCell = matrix of raw data; each timestep is a row
%
%
% Outputs:
%
%   behCol = column vector of recoded behaviors for
%            for each timestep
%
%   behCol_noReset = column vector of recoded behaviors for
%            for each timestep with arena reset timesteps
%            removed
%
%   roachPos = Row vectors with x:y coordinates of each roach for each
%           times step that has identified behavior
%
%   mantisEyePos = Row vectors with x:y coordinates of each mantis
%           eye at each time step that has identified behavior
%       --> LeyeX LeyeY ReyeX ReyeY
%
%   mantisHead = Row vectors with x:y coordinates of each mantis mid head


%%%%%%%%%%%%%%%%%% BehaviorSequence NBR-2-77 %%%%%%%%%%%%%%%%

%Input data matrix is organized with each column being an attribute
% 1     Frame
% 2     Attention
% 3     Head Turn
% 4     Prothorax Turn
% 5     Translate
% 6     Body Turn
% 7     Body Lean
% 8     Strike
% 9     Cleaning
% 10	Peering
% 11	Strike Success
% 12	Steps
% 13	Reset
% 14	Left antennae_X
% 15	Left antennae_Y
% 16	Right antennae_X
% 17	Right antennae_Y
% 18	L_eye_X
% 19	L_eye_Y
% 20	R_eye_X
% 21	R_eye_Y
% 22	Prothorax Proximal_X
% 23	Prothorax Proximal_Y
% 24	Prothorax Distal_X
% 25	Prothorax Distal_Y
% 26	Abdomen distal_X
% 27	Abdomen distal_Y
% 28	Abdomen proximal_X
% 29	Abdomen proximal_Y
% 30	Roach 1 X
% 31	Roach 1 Y
% 32	Roach 2 X
% 33	Roach 2 Y
% 34	Roach 3 X
% 35	Roach 3 Y
% 36	Roach 4 X
% 37	Roach 4 Y
% 38	Lower Left Corner_X
% 39	Lower Left Corner_Y
% 40	Upper Left Corner_X
% 41	Upper Left Corner_Y
% 42	Upper Right Corner_X
% 43	Upper Right Corner_Y
% 44	Lower Right Corner_X
% 45	Lower Right Corner_Y
% 46	Escape
% 47	Combat
% 48	Attention at Roach 1
% 49	Attention at Roach 2
% 50	Attention at Roach 3
% 51	Attention at Roach 4
% 52	General Attention
% 53    Diematic


%% Behavior Determination

% Behavior Key
%%%%%%%%%%%%%%%%%%%%%%% Hunting Specific %%%%%%%%%%%%%%%%%%%%%%%%%%
% 1     Successful Strike
%           --> col 11
%
%
% 2     Missed Strike
%           --> col 8
%
%
% 3     Specific Translate: translation towards any food item
%           --> (col 5 = 1)   AND   (col 48 OR 49 OR 50 OR 51 OR 52 = 1)
%
%
% 4     Specific Rotation: Head Turn + Prothorax Turn + Body Turn towards 
%       any food item and no translation
%           --> ((cols 3 OR 4 OR 6 = 1)    AND   (col 5 = 0)) 
%           --> AND (col 48 OR 49 OR 50 OR 51 OR 52 = 1)
%
%
% 5     Specific Monitoring: specific monitor + lean in + peering...
%           --> (cols 2 OR 7 OR 10)       AND   (col 52==0)
%
%%%%%%%%%%%%%%%%%%%%%%%%     Transition   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 6     General Monitoring 
%           --> col 2 = 1 AND col 52 == 1


%%%%%%%%%%%%%%%%%%%%%%% Non - Hunting Specific %%%%%%%%%%%%%%%%%%%%%%%%%%
% 7     General Translation: translation towards no food items
%           --> (col 5 = 1) AND (col 48 AND 49 AND 50 AND 51 AND 52 = 0)
%
%
% 8     General Rotation: rotation towards no food items
%           --> (col 3 OR col 4 OR col 6 = 1) AND (col 48 AND 49 AND 50 AND 51 AND 52 = 0)
%
%
% 9     Cleaning
%           --> col 9 = 1
%
%
% 10     Deimetic
%           --> col 47 OR col 53 = 1
% 
%
% 11     Escape
%           --> col 46
%
%
% 12    Arena Reset
%           --> col 13 = 1

%For each time step, assign a behavior designation
%Save behaviors as a column vector

% Initialize behavior column
behCol = zeros(size(datCell,1), 1);
indHasBeh = []; %tracks all indices that have corresponding beh identified
for i = 1:size(datCell,1)
    
    %Current row index
    currRow = i;
    
    %For this index, isolate row values = 1 and save corresponding col
    %values
    currCol = find(datCell(currRow,:)==1);
 
    
    %%%%%%%%% Behavior Bin 1: Successful Strike %%%%%%%%%
    %If this index is successful strike
    if (ismember(11,currCol))
        behCol(i) = 1;
        
        %roach x/y coordinates for each roach 
        roachPos(i,:) = datCell(i,30:37);
                       
        %Mantis eye coordinates
        mantisEyePos(i,:) = datCell(i,18:21);
        mantisHead(i,1) = (datCell(i,18) + datCell(i,20))/2;
        mantisHead(i,2) = (datCell(i,19) + datCell(i,21))/2; 
        
    %%%%%%%%% Behavior Bin 2: Missed Strike %%%%%%%%%    
    %If this index is a missed strike   
    elseif (ismember(8,currCol))
        behCol(i) = 2;
        
        %roach x/y coordinates for each roach
        roachPos(i,:) = datCell(i,30:37);
                       
        %Mantis eye coordinates
        mantisEyePos(i,:) = datCell(i,18:21);
        mantisHead(i,1) = (datCell(i,18) + datCell(i,20))/2;
        mantisHead(i,2) = (datCell(i,19) + datCell(i,21))/2;
        
    %%%%%%%%% Behavior Bin 3: Specific Translation %%%%%%%%%    
    %If this index is a translation towards any food item 
    elseif (ismember(5,currCol)) & (true(sum(ismember([48,49,50,51,52],currCol)) > 0))
        behCol(i) = 3;
        
        %roach x/y coordinates for each roach
        roachPos(i,:) = datCell(i,30:37);
                       
        %Mantis eye coordinates
        mantisEyePos(i,:) = datCell(i,18:21);        
        mantisHead(i,1) = (datCell(i,18) + datCell(i,20))/2;
        mantisHead(i,2) = (datCell(i,19) + datCell(i,21))/2;
        
    %%%%%%%%% Behavior Bin 4: Specific Rotation %%%%%%%%%     
    %If this index has a head,prothorax &/or body turn, does not include
    %translation, and is towards any food item
    elseif (true(sum(ismember([3,4,6],currCol)) > 0))...
            & (~ismember(5,currCol))...
            & (true(sum(ismember([48,49,50,51,52],currCol)) > 0))       
        behCol(i) = 4;
        
        %roach x/y coordinates for each roach
        roachPos(i,:) = datCell(i,30:37);
                       
        %Mantis eye coordinates
        mantisEyePos(i,:) = datCell(i,18:21);        
        mantisHead(i,1) = (datCell(i,18) + datCell(i,20))/2;
        mantisHead(i,2) = (datCell(i,19) + datCell(i,21))/2;       
        
    %%%%%%%%% Behavior Bin 5: Specific Monitoring %%%%%%%%%     
    %If this index has (either col 2,7,5=1) AND (col 48,49,50,51 = 1) AND (col 52=0), 
    elseif (true(sum(ismember([2,7,10],currCol)) > 0))...
            & (true(sum(ismember([48,49,50,51],currCol)) > 0))...
            & (~ismember(52,currCol))
        behCol(i) = 5;
        
        %roach x/y coordinates for each roach
        roachPos(i,:) = datCell(i,30:37);
                       
        %Mantis eye coordinates
        mantisEyePos(i,:) = datCell(i,18:21);        
        mantisHead(i,1) = (datCell(i,18) + datCell(i,20))/2;
        mantisHead(i,2) = (datCell(i,19) + datCell(i,21))/2;
        
    %%%%%%%%% Behavior Bin 6: General Monitoring %%%%%%%%%
    %If this index has monitoring (col2) and col 52=1, then bin
    %as general monitoring
    elseif (ismember(2,currCol)) & (ismember(52,currCol))
        behCol(i) = 6;
        
        %roach x/y coordinates for each roach
        roachPos(i,:) = datCell(i,30:37);
                       
        %Mantis eye coordinates
        mantisEyePos(i,:) = datCell(i,18:21);
        mantisHead(i,1) = (datCell(i,18) + datCell(i,20))/2;
        mantisHead(i,2) = (datCell(i,19) + datCell(i,21))/2;
        
    %%%%%%%%% Behavior Bin 7: General Translation %%%%%%%%%    
    %If this index is a translation towards no food items and is not an escape 
    elseif (ismember(5,currCol)) & (~ismember([9,46,47,48,49,50,51,52,53],currCol))
        behCol(i) = 7;
        
        %roach x/y coordinates for each roach
        roachPos(i,:) = datCell(i,30:37);
                       
        %Mantis eye coordinates
        mantisEyePos(i,:) = datCell(i,18:21);
        mantisHead(i,1) = (datCell(i,18) + datCell(i,20))/2;
        mantisHead(i,2) = (datCell(i,19) + datCell(i,21))/2;
        
    %%%%%%%%% Behavior Bin 8: General Rotation %%%%%%%%%     
    %If this index has a head,prothorax &/or body turn, without translation
    %towards no food items
    elseif (true(sum(ismember([3,4,6],currCol)) > 0))...
            & (~ismember([5,48,49,50,51,52],currCol))
        behCol(i) = 8; 
        
        %roach x/y coordinates for each roach
        roachPos(i,:) = datCell(i,30:37);
                       
        %Mantis eye coordinates
        mantisEyePos(i,:) = datCell(i,18:21);
        mantisHead(i,1) = (datCell(i,18) + datCell(i,20))/2;
        mantisHead(i,2) = (datCell(i,19) + datCell(i,21))/2;
        
    %%%%%%%%% Behavior Bin 9: Cleaning %%%%%%%%%
    %If this index is cleaning    
    elseif (ismember(9,currCol))
        behCol(i) = 9;
        
        %roach x/y coordinates for each roach
        roachPos(i,:) = datCell(i,30:37);
                       
        %Mantis eye coordinates
        mantisEyePos(i,:) = datCell(i,18:21);    
        mantisHead(i,1) = (datCell(i,18) + datCell(i,20))/2;
        mantisHead(i,2) = (datCell(i,19) + datCell(i,21))/2;
        
    %%%%%%%%% Behavior Bin 10: Diematic/Combat %%%%%%%%%
    %If this index is an escape or , bin as escape/diematic    
    elseif true(sum(ismember([47,53],currCol)) > 0)
        behCol(i) = 10;
        
        %roach x/y coordinates for each roach
        roachPos(i,:) = datCell(i,30:37);
                       
        %Mantis eye coordinates
        mantisEyePos(i,:) = datCell(i,18:21);    
        mantisHead(i,1) = (datCell(i,18) + datCell(i,20))/2;
        mantisHead(i,2) = (datCell(i,19) + datCell(i,21))/2;
        
    %%%%%%%%% Behavior Bin 11: Escape %%%%%%%%%
    %If this index is an escape or , bin as escape/diematic    
    elseif true(sum(ismember([46],currCol)) > 0)
        behCol(i) = 11;    
        
        %roach x/y coordinates for each roach
        roachPos(i,:) = datCell(i,30:37);
                       
        %Mantis eye coordinates
        mantisEyePos(i,:) = datCell(i,18:21);
        mantisHead(i,1) = (datCell(i,18) + datCell(i,20))/2;
        mantisHead(i,2) = (datCell(i,19) + datCell(i,21))/2;
        
    %%%%%%%%% Behavior Bin 12: Arena Reset %%%%%%%%%    
    %If this index is arena reset    
    elseif (ismember(13,currCol))
        behCol(i) = 12;     
        
        %roach x/y coordinates for each roach
        roachPos(i,:) = datCell(i,30:37);
                       
        %Mantis eye coordinates
        mantisEyePos(i,:) = datCell(i,18:21);       
        mantisHead(i,1) = (datCell(i,18) + datCell(i,20))/2;
        mantisHead(i,2) = (datCell(i,19) + datCell(i,21))/2;
        
    else %If the current frame cannot be binned with current logic
        behCol(i) = NaN;
        noLabel(i) = i;
    end
%     figure
%     scatter([mantisEyePos(i,1), mantisEyePos(i,3)],...
%             [mantisEyePos(i,2), mantisEyePos(i,4)])
%     hold on
%     scatter(mantisHead(i,1), mantisHead(i,2))
end


%Track what the indices are for each behavior
%Count how many frames are in each behavior bin
behCount = zeros(12, 1);
for i = 1:size(behCount)
    behInd{i} = find(behCol==i);
    behCount(i) = size(behInd{i},1);
end

%keyboard

%% Generate Full Behavior Sequence to save
%For the full sequence, remove the arena resets
behCol_noReset = behCol;
resetInd = find(behCol == 12);
behCol_noReset(resetInd) = [];
