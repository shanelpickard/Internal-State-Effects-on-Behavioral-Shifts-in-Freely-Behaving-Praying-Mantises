function [subSeq, subSeq_noReset] = subSequenceGenerator_NBR_2_81(colVec, indVec)

% Break up full behavior subsequence into subsequences
% Each subsequence of behavior will end on an arena reset
% Save each subsequence to a layer
% Plots timestepped behaviors for each layer/subsequence

% Inputs:
%
%   colVec = column vector of behavior codes
%
%
% Outputs:
%
%   layeredBeh = multidimensional array with each layer
%                being the subsequence of behaviors


%Designate how many subsequences/layers there will be
endPoints = find(colVec == 12); %Indices that correspond to resets
numSubSeq = length(endPoints);

%initialize subsequence multidimensional array.
subSeq = {};
subSeq_noReset = {};
currStart = 1;
for i = 1:numSubSeq
    currEndPt = endPoints(i);
    tmpSubSeq = colVec(currStart:currEndPt);
    
    subSeq{i} = tmpSubSeq;
    subSeq_noReset{i} = tmpSubSeq(1:end-1);
    subSeqInd{i} = indVec(currStart:currEndPt);
    
    %Define new start index for next subsequence
    currStart = currEndPt + 1;
    lenSeq(i) = length(tmpSubSeq); %record the lengths of each subseq.
end

% Plot timestep behavior of subsequence behaviors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%keyboard
 

% maxLength = max(lenSeq); %used max length seq to normalize x-axis of subplots
% 
% 
% for i = 1:numSubSeq
%     figure(i)
%     %subplot(ceil(numSubSeq/2),2,i);
%     %subplot(3,2,i-3);  % When Manually Set
%     %subplot(2,3,i);  % When Manually Set
%     %subplot(4,2,i);
%     %subplot(2,3,i);
%     beh_noResets = subSeq{i}; %vector of subseq beh numerical labels
%     beh_noResets = beh_noResets(1:end-1); %remove the arena reset timestep
%     x = (1:size(beh_noResets,1));
%     missedX = find(beh_noResets==2); %x indices for missed strikes
%     successX = find(beh_noResets==1); %x indices for success strikes
%     beh_noRes = beh_noResets';
%     endPt = x(end);
% 
%     %Break up behavior vector into the three regimes: hunting codes;
%     %transition; non-hunting 
%     %__Hunting
%     huntInd = [];
%     huntCode = [];
%     for j=1:5
%         tmpInd = find(beh_noResets == j);
%         tmpCode = j * ones([length(tmpInd),1]);
%         huntInd = [huntInd; tmpInd];
%         huntCode = [huntCode; tmpCode];
%     end
% 
%     %__Transition --> general monitoring
%     transInd = find(beh_noResets == 6);
%     transCode = 6 * ones([length(transInd),1]);
% 
%     %__Non-hunting behavior
%     noHuntInd = [];
%     noHuntCode = [];
%     for j=7:11
%         tmpInd = find(beh_noResets == j);
%         tmpCode = j * ones([length(tmpInd),1]);
%         noHuntInd = [noHuntInd; tmpInd];
%         noHuntCode = [noHuntCode; tmpCode];
%     end
%     
%     %_______ Shaded Regimes _____________________
%     %Shade transition area
%     patch('vertices', [1, 5.5; endPt, 5.5; endPt, 6.5; 1, 6.5], ...
%           'faces', [1, 2, 3, 4], ...
%           'FaceColor', [0 0 0], ...
%           'EdgeColor','none',...
%           'FaceAlpha', 0.25)
%     hold on
% 
%     %Shade non-hunting regime - blue
%     patch('vertices', [1, 6.5; endPt, 6.5; endPt, 11; 1, 11], ...
%           'faces', [1, 2, 3, 4], ...
%           'FaceColor', [0 0.4470 0.7410], ...
%           'EdgeColor','none',...
%           'FaceAlpha', 0.12)
%     hold on
%     
%     %Shade hunting regime - red
%     patch('vertices', [1, 1; endPt, 1; endPt, 5.5; 1, 5.5], ...
%           'faces', [1, 2, 3, 4], ...
%           'FaceColor', [1 0 0], ...
%           'EdgeColor','none',...
%           'FaceAlpha', 0.2) 
%       
%     %_______ Plot scatter plots ____________________
%     %plot continuous line and color coded scatter points
%         p1 = plot(x, beh_noRes, 'k', 'LineWidth', .1);
%         p1.Color(4) = 0.3;
%         hold on
%         scatter(huntInd, huntCode,40,...
%                 'MarkerFaceColor', 'r', 'MarkerEdgeColor','none')
%         hold on
%         scatter(transInd, transCode,40,...
%                 'MarkerFaceColor', 'k', 'MarkerEdgeColor','none')
%         hold on
%         scatter(noHuntInd, noHuntCode,40,...
%                 'MarkerFaceColor', 'b', 'MarkerEdgeColor','none')
%         hold on
% 
% 
%     
%       
%     %_______ Plot strikes ____________________
%     % Plot missed/successful strikes if they exist
%     if ~isempty(successX)
%         scatter(successX, 1*ones(size(successX,1),1),200,...
%                 'MarkerFaceColor', 'c',...
%                 'MarkerEdgeColor','k',...
%                 'LineWidth',2)
%     end
%     
%     if ~isempty(missedX)
%         scatter(missedX, 2*ones(size(missedX,1),1),200,...
%                 'MarkerFaceColor', 'y',...
%                 'MarkerEdgeColor','k',...
%                 'LineWidth',1.5)
%     end
%     
%     
%     %_______ Plot properties ____________________
%     %set(graph1,'LineWidth',2);
%     %xlim([1 size(beh_noResets,1)])
%     %spPos = get(sp,'position')
%     %set(sp,'position',spPos .* [1 1 (length(subSeq{i})/maxLength) 1])
%     title(['' num2str(i)])
%     set(gca, 'FontSize', 45)
%     box on
%     ax = gca;
%     ax.YGrid = 'on';
%     ax.GridLineStyle = '-';
%     ax.LabelFontSizeMultiplier  = 3;
%     set(gca,'YTickLabel',[]);
%     set(gca,'XTickLabel',[]);
%     set(gca,'color','none')
% 
%     xlim([1 size(x,2)])
%     %set(gca,'Xtick',0:200:length(subSeq{i}))
%     %xlim([1 maxLength]) %using max length subseq for all subplots
%     ylim([1 11])
%    yticks([1 2 3 4 5 6 7 8 9 10 11])
%     yticklabels({'1','2','3','4','5','6','7','8',...
%                  '9','10','11'})
% %     yticklabels({'Successful Strike','Missed Strike','Specfic Translation','Specific Rotation',...
% %              'Specific Monitor','General Monitor','General Translation',...
% %              'General Rotation','Groom','Deimatic','Escape'})
% 
% end
% 
% 
% 
