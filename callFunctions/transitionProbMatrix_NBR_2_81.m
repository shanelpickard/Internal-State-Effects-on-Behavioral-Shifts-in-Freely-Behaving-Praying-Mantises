function [rawNum, probs] = transitionProbMatrix_NBR_2_81(str)

% Inputs:
%
%   str = input a subsequence of symbols representing behaviors for each time
%   step within that subsequence
%
%
%
% Outputs:
%
%   rawNum = N x N matrix with the transition probabilities from each
%            state to every other state
%
%   probs = N x N matrix of transition probabilities 

%keyboard
strLength = length(str);
reset = 12;
behVec = [1 2 3 4 5 6 7 8 9 10 11 12];
rawNum = zeros(length(behVec),length(behVec));
for i = 1:length(behVec)
     
    ind = find(str == i);
    indNext = ind + 1;
    
    if isempty(ind)
        continue
    end
    
    %Resets are absorbing states
    if i==reset
        break
    end
   
    for j = 1:length(ind)
        
        %If the next index goes beyond the last index
        if indNext(j) > strLength
            break
        end
            
        row = str(ind(j));
        col = str(indNext(j));
        rawNum(row,col) = rawNum(row,col) + 1;      
    end
end


%% Calculate probability matrix
divVec = sum(rawNum,2); %summed transitions


probs = rawNum ./ divVec;
probs(isnan(probs))=0;


