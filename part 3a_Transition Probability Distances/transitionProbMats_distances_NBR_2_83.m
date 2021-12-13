% Transition probability distances NBR-2-83

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

%% Distances between prob matrices for each animal in each feed state

probVertComplete = [];
counter = 1;
header = [];
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
    

    %___________________________________________
    % STEP 3: Generate probability matrices for each subsequence and string
    % out vertically
    currAnimal = animalLabelRef(i);
    currFeed = feedLabelRef(i);
    
    for j = 1:size(subSequence,2)
        currSubSeq = j;
        [~, tmpProbMatrix] = transitionProbMatrix_NBR_2_81(subSequence{j});
        probMatrixLayers{counter} = tmpProbMatrix;
        probMatVert = tmpProbMatrix';
        probMatVert = probMatVert(:);
        counter = counter + 1;
        
        %make identifer vector
        tmpHeader = [currAnimal; currFeed; currSubSeq];
        header = [header, tmpHeader];
        
        %make final matrix of vertical prob matrices
        probVertComplete = [probVertComplete, probMatVert];
    end
    %clear tmpProbMatrix currAnimal currFeed currSubSeq tmpHeader
end
%clear counter i j 


%% Find distances between vertical prob vectors

transProbDistCompelete = [];
for i = 1:length(probVertComplete)
    header1 = header(:,i);
    for j = 1:length(probVertComplete)
        tmpDist = norm(probVertComplete(:,i) - probVertComplete(:,j));
        header2 = header(:,j);
        
        tmpMat = [header1', tmpDist, header2',];
        transProbDistCompelete = [transProbDistCompelete; tmpMat];
 
    end
end

clear i j tmpDist header1 header2



%% Generate prob Matrix heat map from reorganized prob matrix

%Reorganize prob matrix and then string out vertically
probMatReorg = [];
for i = 1:length(probMatrixLayers)
    currLayer = probMatrixLayers{i};
    
    %%%%%%%%%%%%%%%%% Specific - to - Specific Transitions
    specTOspec = currLayer(1:5,1:5)'; %isolate probs of spec-spec 
    specTOspec = specTOspec(:); %make vertical
    %spec2spec{i} = specTOspec(:);  %keep this 
    %specTOspec(1:5,:) = []; 
    
    
    
    %%%%%%%%%%%%%%%%% Specific - to - General Transitions
    specToGen = currLayer(1:5,6:12)'; %isolate probs of spec-gen 
    specToGen = specToGen(:); %make vertical
    %spec2gen{i} = specToGen(:);  %keep this 
    %specToGen([1:6, 14,21,28],:) = [];
    
    
    %%%%%%%%%%%%%%%%% General - to - Specific Transitions
    genTOspec = currLayer(6:12,1:5)'; %isolate probs of gen-spec 
    genTOspec = genTOspec(:); %make vertical
    %gen2spec{i} = genTOspec(:); %keep this 
    %genTOspec(31:35,:) = [];
    
    
     %%%%%%%%%%%%%%%%% General - to - General Transitions
    genTOgen = currLayer(6:12,6:12)';
    genTOgen = genTOgen(:);
    %gen2gen{i} = genTOgen(:); %keep this 
    %genTOgen(43:49,:) = [];
    
    tmpReorg = [specTOspec; specToGen; genTOspec; genTOgen];
    probMatReorg = [probMatReorg, tmpReorg];
end


%% Sort by feed state
% Sort the reorganized prob matrices to be ordered by feed state


tmpInd = find(header(2,:)==0);
probMat0 = probMatReorg(:,tmpInd);

tmpInd = find(header(2,:)==1);
probMat1 = probMatReorg(:,tmpInd);

tmpInd = find(header(2,:)==2);
probMat2 = probMatReorg(:,tmpInd);

tmpInd = find(header(2,:)==3);
probMat3 = probMatReorg(:,tmpInd);

tmpInd = find(header(2,:)==4);
probMat4 = probMatReorg(:,tmpInd);

probMatReorgSort = [probMat0 probMat1  probMat2 probMat3 probMat4];

heatmap(log(probMatReorgSort), 'Colormap',jet)

%probMatReorgSort = log(probMatReorgSort);
%probMatReorgSort(isinf(probMatReorgSort)) = 0;
h = heatmap(db(probMatReorgSort), 'Colormap',jet);


%% Break up Matricies by transition type
colors = [1,0,0; 33/255, 188/255, 45/255; 0 0 1; 229/255,116/255,6/255; 
          171/255, 8/255, 252/255];
%%%%%%%%%%  Spec-Spec --> All feed states
spec2spec0 = probMat0(1:25, :);
spec2spec0_vert = spec2spec0(:);
histogram(spec2spec0(:))
pd_kernal0 = fitdist(spec2spec0_vert, 'Kernel');
pd_normal0 = fitdist(spec2spec0_vert, 'Normal');
x_values = 0:.001:1;
y0_kernal = pdf(pd_kernal0,x_values);
y0_normal = pdf(pd_normal0,x_values);
[y0_ksdensity,xi0] = ksdensity(spec2spec0_vert); 
histogram(spec2spec0_vert,'Normalization','probability')


spec2spec1 = probMat1(1:25, :);
spec2spec1_vert = spec2spec1(:);
histogram(spec2spec1(:))
pd_kernal1 = fitdist(spec2spec1_vert, 'Kernel');
pd_normal1 = fitdist(spec2spec1_vert, 'Normal');
x_values = 0:.001:1;
y1_kernal = pdf(pd_kernal1,x_values);
y1_normal = pdf(pd_normal1,x_values);
[y1_ksdensity,xi1] = ksdensity(spec2spec1_vert); 

spec2spec2 = probMat2(1:25, :);
spec2spec2_vert = spec2spec2(:);
histogram(spec2spec2(:))
pd_kernal2 = fitdist(spec2spec2_vert, 'Kernel');
pd_normal2 = fitdist(spec2spec2_vert, 'Normal');
x_values = 0:.001:1;
y2_kernal = pdf(pd_kernal2,x_values);
y2_normal = pdf(pd_normal2,x_values);
[y2_ksdensity,xi2] = ksdensity(spec2spec2_vert); 

spec2spec3 = probMat3(1:25, :);
spec2spec3_vert = spec2spec3(:);
histogram(spec2spec3(:))
pd_kernal3 = fitdist(spec2spec3_vert, 'Kernel');
pd_normal3 = fitdist(spec2spec3_vert, 'Normal');
x_values = 0:.001:1;
y3_kernal = pdf(pd_kernal3,x_values);
y3_normal = pdf(pd_normal3,x_values);
[y3_ksdensity,xi3] = ksdensity(spec2spec3_vert); 

spec2spec4 = probMat4(1:25, :);
spec2spec4_vert = spec2spec4(:);
histogram(spec2spec4(:))
pd_kernal4 = fitdist(spec2spec4_vert, 'Kernel');
pd_normal4 = fitdist(spec2spec4_vert, 'Normal');
x_values = 0:.001:1;
y4_kernal = pdf(pd_kernal4,x_values);
y4_normal = pdf(pd_normal4,x_values);
[y4_ksdensity,xi4] = ksdensity(spec2spec4_vert); 



%Data fit to normalized plot
figure
plot(x_values,y0_normal,'Color',colors(1,:), 'LineWidth', 4)
hold on
plot(x_values,y1_normal, 'Color',colors(2,:), 'LineWidth', 4)
hold on
plot(x_values,y2_normal,'Color',colors(3,:), 'LineWidth', 4)
hold on
plot(x_values,y3_normal, 'Color',colors(4,:), 'LineWidth', 4)
hold on
plot(x_values,y4_normal, 'Color',colors(5,:), 'LineWidth', 4)
grid on
ytickformat('%.1f')
ax = gca;
legend('0-fed','1-fed','2-fed','3-fed','4-fed')
ax.FontSize = 20;
%title(['Normalized Distribution Hunting to Hunting Transitions'])



%Data fit to normalized plot
figure
plot(x_values,y0_normal,'k', 'LineWidth', 4)
hold on
plot(x_values,y1_normal, 'r', 'LineWidth', 4)
hold on
plot(x_values,y2_normal,'b', 'LineWidth', 4)
hold on
plot(x_values,y3_normal, 'Color', [182/255, 76/255, 3/255],  'LineWidth', 4)
hold on
plot(x_values,y4_normal, 'Color', [135/255, 135/255, 135/255], 'LineWidth', 4)
grid on
ytickformat('%.1f')
ax = gca;
ax.FontSize = 20;
legend('0-fed','1-fed','2-fed','3-fed','4-fed')
%title(['Normalized Distribution Hunting to Hunting Transitions'])



%%%  Kernal histogram
figure
plot(x_values,y0_kernal)
hold on
plot(x_values,y1_kernal)
hold on
plot(x_values,y2_kernal)
hold on
plot(x_values,y3_kernal)
hold on
plot(x_values,y4_kernal)
title(['Kernal Hunting to Hunting Transitions'])
legend('0-fed','1-fed','2-fed','3-fed','4-fed')


%Percent histogram
figure
histogram(spec2spec0(:),'Normalization','probability')
hold on
histogram(spec2spec1(:),'Normalization','probability')
hold on
histogram(spec2spec2(:),'Normalization','probability')
hold on
histogram(spec2spec3(:),'Normalization','probability')
hold on
histogram(spec2spec4(:),'Normalization','probability')
legend('0-fed','1-fed','2-fed','3-fed','4-fed')

figure
cdfplot(y0_normal)
hold on
cdfplot(y1_normal)
hold on
cdfplot(y2_normal)
hold on
cdfplot(y3_normal)
hold on
cdfplot(y4_normal)
title(['Cumulative Distribution Function Hunting to Hunting Transitions'])
legend('0-fed','1-fed','2-fed','3-fed','4-fed')


figure
cdfplot(spec2spec0_vert)
hold on
cdfplot(spec2spec1_vert)
hold on
cdfplot(spec2spec2_vert)
hold on
cdfplot(spec2spec3_vert)
hold on
cdfplot(spec2spec4_vert)
title(['Cumulative Distribution Function Hunting to Hunting Transitions'])
legend('0-fed','1-fed','2-fed','3-fed','4-fed')


figure
plot(sort(spec2spec0_vert))
hold on
plot(sort(spec2spec1_vert))
hold on
plot(sort(spec2spec2_vert))
hold on
plot(sort(spec2spec3_vert))
hold on
plot(sort(spec2spec4_vert))
legend('0-fed','1-fed','2-fed','3-fed','4-fed')


figure
plot(xi0,y0_ksdensity);
hold on
plot(xi1,y1_ksdensity);
hold on
plot(xi2,y2_ksdensity);
hold on
plot(xi3,y3_ksdensity);
hold on
plot(xi4,y4_ksdensity);
legend('0-fed','1-fed','2-fed','3-fed','4-fed')

%% Spec-gen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
resetInd_s2g = [7 14 21 28 35];

spec2gen0 = probMat0(26:60, :);
spec2gen0(7,:) = [];
spec2gen0_vert = spec2gen0(:);
%spec2gen0_vert(resetInd_s2g) = [];
histogram(spec2gen0(:))
pd_s2g_kernal0 = fitdist(spec2gen0_vert, 'Kernel');
pd_s2g_normal0 = fitdist(spec2gen0_vert, 'Normal');
x_values = 0:.001:1;
y0_s2g_kernal = pdf(pd_s2g_kernal0,x_values);
y0_s2g_normal = pdf(pd_s2g_normal0,x_values);


spec2gen1 = probMat1(26:60, :);
spec2gen1(7,:) = [];
spec2gen1_vert = spec2gen1(:);
%spec2gen1_vert(resetInd_s2g) = [];
histogram(spec2gen1(:))
pd_s2g_kernal1 = fitdist(spec2gen1_vert, 'Kernel');
pd_s2g_normal1 = fitdist(spec2gen1_vert, 'Normal');
x_values = 0:.001:1;
y1_s2g_kernal = pdf(pd_s2g_kernal1,x_values);
y1_s2g_normal = pdf(pd_s2g_normal1,x_values);


spec2gen2 = probMat2(26:60, :);
spec2gen2(7,:) = [];
spec2gen2_vert = spec2gen2(:);
%spec2gen2_vert(resetInd_s2g) = [];
histogram(spec2gen2(:))
pd_s2g_kernal2 = fitdist(spec2gen2_vert, 'Kernel');
pd_s2g_normal2 = fitdist(spec2gen2_vert, 'Normal');
x_values = 0:.001:1;
y2_s2g_kernal = pdf(pd_s2g_kernal2,x_values);
y2_s2g_normal = pdf(pd_s2g_normal2,x_values);


spec2gen3 = probMat3(26:60, :);
spec2gen3(7,:) = [];
spec2gen3_vert = spec2gen3(:);
%spec2gen3_vert(resetInd_s2g) = [];
histogram(spec2gen3(:))
pd_s2g_kernal3 = fitdist(spec2gen3_vert, 'Kernel');
pd_s2g_normal3 = fitdist(spec2gen3_vert, 'Normal');
x_values = 0:.001:1;
y3_s2g_kernal = pdf(pd_s2g_kernal3,x_values);
y3_s2g_normal = pdf(pd_s2g_normal3,x_values);


spec2gen4 = probMat4(26:60, :);
spec2gen4(7,:) = [];
spec2gen4_vert = spec2gen4(:);
%spec2gen4_vert(resetInd_s2g) = [];
histogram(spec2gen4(:))
pd_s2g_kernal4 = fitdist(spec2gen4_vert, 'Kernel');
pd_s2g_normal4 = fitdist(spec2gen4_vert, 'Normal');
x_values = 0:.001:1;
y4_s2g_kernal = pdf(pd_s2g_kernal4,x_values);
y4_s2g_normal = pdf(pd_s2g_normal4,x_values);

figure
plot(x_values,y0_s2g_normal, 'k', 'LineWidth', 4)
hold on
plot(x_values,y1_s2g_normal, 'r', 'LineWidth', 4)
hold on
plot(x_values,y2_s2g_normal,'b', 'LineWidth', 4)
hold on
plot(x_values,y3_s2g_normal,'Color', [182/255, 76/255, 3/255], 'LineWidth', 4)
hold on
plot(x_values,y4_s2g_normal,'Color', [135/255, 135/255, 135/255], 'LineWidth', 4)
grid on
%ytickformat('%.1f')
ax = gca;
ax.FontSize = 20;
xlim([0 0.3])

figure
plot(x_values,y0_s2g_normal, 'k', 'LineWidth', 6)
hold on
plot(x_values,y1_s2g_normal, 'r', 'LineWidth', 6)
hold on
plot(x_values,y2_s2g_normal,'b', 'LineWidth', 6)
hold on
plot(x_values,y3_s2g_normal,'Color', [182/255, 76/255, 3/255], 'LineWidth', 6)
hold on
plot(x_values,y4_s2g_normal,'Color', [135/255, 135/255, 135/255], 'LineWidth', 6)
grid on
%ytickformat('%.1f')
ax = gca;
ax.FontSize = 30;
xlim([0 0.3])
%title(['Normalized Distribution Hunting to Non-hunting Transitions'])
%legend('0-fed','1-fed','2-fed','3-fed','4-fed')



figure
cdfplot(y0_s2g_normal, 'k', 'LineWidth', 2)
hold on
cdfplot(y1_s2g_normal, 'r', 'LineWidth', 2)
hold on
cdfplot(y2_s2g_normal,'b', 'LineWidth', 2)
hold on
cdfplot(y3_s2g_normal,'Color', [182/255, 76/255, 3/255], 'LineWidth', 2)
hold on
cdfplot(y4_s2g_normal,'Color', [135/255, 135/255, 135/255], 'LineWidth', 2)
title(['Cumulative Distribution Function Hunting to Hunting Transitions'])
legend('0-fed','1-fed','2-fed','3-fed','4-fed')



figure
[f0,x0] = cdfplot(y0_s2g_normal);
[f1,x1] = cdfplot(y1_s2g_normal);
[f2,x2] = cdfplot(y2_s2g_normal);
[f3,x3] = cdfplot(y3_s2g_normal);
[f4,x4] = cdfplot(y4_s2g_normal);

plot(x0,f0,'k','LineWidth',2)
plot(x1,f1,'r','LineWidth',2)
plot(x2,f2,'b','LineWidth',2)
plot(x3,f3,'Color', [182/255, 76/255, 3/255],'LineWidth',2)
plot(x4,f4,'Color', [135/255, 135/255, 135/255],'LineWidth',2)

figure
cdfplot(y0_s2g_normal, 'k', 'LineWidth', 2)
hold on
cdfplot(y1_s2g_normal, 'r', 'LineWidth', 2)
hold on
cdfplot(y2_s2g_normal,'b', 'LineWidth', 2)
hold on
cdfplot(y3_s2g_normal,'Color', [182/255, 76/255, 3/255], 'LineWidth', 2)
hold on
cdfplot(y4_s2g_normal,'Color', [135/255, 135/255, 135/255], 'LineWidth', 2)
title(['Cumulative Distribution Function Hunting to Hunting Transitions'])
%legend('0-fed','1-fed','2-fed','3-fed','4-fed')             
             
%title(['Cumulative Distribution Function Hunting to Hunting Transitions'])
%legend('0-fed','1-fed','2-fed','3-fed','4-fed')





heatmap(log([spec2gen0, spec2gen1, spec2gen2, spec2gen3, spec2gen4]),...
       'Colormap',jet)



%% gen-spec
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gen2spec0 = probMat0(61:95, :);
gen2spec0(31:35,:) = [];
gen2spec0_vert = gen2spec0(:);
histogram(gen2spec0(:))
pd_g2s_kernal0 = fitdist(gen2spec0_vert, 'Kernel');
pd_g2s_normal0 = fitdist(gen2spec0_vert, 'Normal');
x_values = 0:.001:1;
y0_g2s_kernal = pdf(pd_g2s_kernal0,x_values);
y0_g2s_normal = pdf(pd_g2s_normal0,x_values);


gen2spec1 = probMat1(61:95, :);
gen2spec1(31:35,:) = [];
gen2spec1_vert = gen2spec1(:);
histogram(gen2spec1(:))
pd_g2s_kernal1 = fitdist(gen2spec1_vert, 'Kernel');
pd_g2s_normal1 = fitdist(gen2spec1_vert, 'Normal');
x_values = 0:.001:1;
y1_g2s_kernal = pdf(pd_g2s_kernal1,x_values);
y1_g2s_normal = pdf(pd_g2s_normal1,x_values);


gen2spec2 = probMat2(61:95, :);
gen2spec2(31:35,:) = [];
gen2spec2_vert = gen2spec2(:);
histogram(gen2spec2(:))
pd_g2s_kernal2 = fitdist(gen2spec2_vert, 'Kernel');
pd_g2s_normal2 = fitdist(gen2spec2_vert, 'Normal');
x_values = 0:.001:1;
y2_g2s_kernal = pdf(pd_g2s_kernal2,x_values);
y2_g2s_normal = pdf(pd_g2s_normal2,x_values);


gen2spec3 = probMat3(61:95, :);
gen2spec3(31:35,:) = [];
gen2spec3_vert = gen2spec3(:);
histogram(gen2spec3(:))
pd_g2s_kernal3 = fitdist(gen2spec3_vert, 'Kernel');
pd_g2s_normal3 = fitdist(gen2spec3_vert, 'Normal');
x_values = 0:.001:1;
y3_g2s_kernal = pdf(pd_g2s_kernal3,x_values);
y3_g2s_normal = pdf(pd_g2s_normal3,x_values);


gen2spec4 = probMat4(61:95, :);
gen2spec4_vert = gen2spec4(:);
gen2spec4(31:35,:) = [];
histogram(gen2spec4(:))
pd_g2s_kernal4 = fitdist(gen2spec4_vert, 'Kernel');
pd_g2s_normal4 = fitdist(gen2spec4_vert, 'Normal');
x_values = 0:.001:1;
y4_g2s_kernal = pdf(pd_g2s_kernal4,x_values);
y4_g2s_normal = pdf(pd_g2s_normal4,x_values);


figure
plot(x_values,y0_g2s_normal,'k', 'LineWidth', 4)
hold on
plot(x_values,y1_g2s_normal, 'r', 'LineWidth', 4)
hold on
plot(x_values,y2_g2s_normal,'b', 'LineWidth', 4)
hold on
plot(x_values,y3_g2s_normal, 'Color', [182/255, 76/255, 3/255],  'LineWidth', 4)
hold on
plot(x_values,y4_g2s_normal, 'Color', [135/255, 135/255, 135/255], 'LineWidth', 4)
grid on
ax = gca;
ax.FontSize = 20;
ylim([0 150])
xlim([0 .05])

%title(['Normalized Distribution Hunting to Hunting Transitions'])
%legend('0-fed','1-fed','2-fed','3-fed','4-fed')



heatmap(log([gen2spec0, gen2spec1, gen2spec2, gen2spec3, gen2spec4]),...
       'Colormap',jet)
   
   
   
   

%% gen-gen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gen2gen0 = probMat0(96:144, :);
gen2gen0(43:49, :) = [];
gen2gen0_vert = gen2gen0(:);
histogram(gen2gen0(:))
pd_g2g_kernal0 = fitdist(gen2gen0_vert, 'Kernel');
pd_g2g_normal0 = fitdist(gen2gen0_vert, 'Normal');
x_values = 0:.001:1;
y0_g2g_kernal = pdf(pd_g2g_kernal0,x_values);
y0_g2g_normal = pdf(pd_g2g_normal0,x_values);


gen2gen1 = probMat1(96:144, :);
gen2gen1(43:49, :) = [];
gen2gen1_vert = gen2gen1(:);
histogram(gen2gen1(:))
pd_g2g_kernal1 = fitdist(gen2gen1_vert, 'Kernel');
pd_g2g_normal1 = fitdist(gen2gen1_vert, 'Normal');
x_values = 0:.001:1;
y1_g2g_kernal = pdf(pd_g2g_kernal1,x_values);
y1_g2g_normal = pdf(pd_g2g_normal1,x_values);


gen2gen2 = probMat2(96:144, :);
gen2gen2(43:49, :) = [];
gen2gen2_vert = gen2gen2(:);
histogram(gen2gen2(:))
pd_g2g_kernal2 = fitdist(gen2gen2_vert, 'Kernel');
pd_g2g_normal2 = fitdist(gen2gen2_vert, 'Normal');
x_values = 0:.001:1;
y2_g2g_kernal = pdf(pd_g2g_kernal2,x_values);
y2_g2g_normal = pdf(pd_g2g_normal2,x_values);


gen2gen3 = probMat3(96:144, :);
gen2gen3(43:49, :) = [];
gen2gen3_vert = gen2gen3(:);
histogram(gen2gen3(:))
pd_g2g_kernal3 = fitdist(gen2gen3_vert, 'Kernel');
pd_g2g_normal3 = fitdist(gen2gen3_vert, 'Normal');
x_values = 0:.001:1;
y3_g2g_kernal = pdf(pd_g2g_kernal3,x_values);
y3_g2g_normal = pdf(pd_g2g_normal3,x_values);


gen2gen4 = probMat4(96:144, :);
gen2gen4(43:49, :) = [];
gen2gen4_vert = gen2gen4(:);
histogram(gen2gen4(:))
pd_g2g_kernal4 = fitdist(gen2gen4_vert, 'Kernel');
pd_g2g_normal4 = fitdist(gen2gen4_vert, 'Normal');
x_values = 0:.001:1;
y4_g2g_kernal = pdf(pd_g2g_kernal4,x_values);
y4_g2g_normal = pdf(pd_g2g_normal4,x_values);


figure
plot(x_values,y0_g2g_normal,'k', 'LineWidth', 7)
hold on
plot(x_values,y1_g2g_normal, 'r', 'LineWidth', 4)
hold on
plot(x_values,y2_g2g_normal,'b', 'LineWidth', 4)
hold on
plot(x_values,y3_g2g_normal, 'Color', [182/255, 76/255, 3/255],  'LineWidth', 4)
hold on
plot(x_values,y4_g2g_normal, 'Color', [135/255, 135/255, 135/255], 'LineWidth', 4)
grid on
ytickformat('%.1f')
ax = gca;
ax.FontSize = 20;
% title(['Normalized Distribution Non-hunting to Non-hunting Transitions'])
% legend('0-fed','1-fed','2-fed','3-fed','4-fed')


heatmap(log([gen2gen0, gen2gen1, gen2gen2, gen2gen3, gen2gen4]),...
       'Colormap',jet)
   
%% Types of tranisitions across single feed state

figure
plot(x_values,y0_normal, 'LineWidth', 2)
hold on
plot(x_values,y0_s2g_normal, 'LineWidth', 2)
hold on
plot(x_values,y0_g2s_normal, 'LineWidth', 2)
hold on
plot(x_values,y0_g2g_normal, 'LineWidth', 2)
legend('hunting to hunting','hunting to nonhunting',...
       'nonhunting to hunting','nonhunting to nonhunting')
   

s2s = [spec2spec0, spec2spec1, spec2spec2, spec2spec3, spec2spec4];
s2g = [spec2gen0, spec2gen1, spec2gen2, spec2gen3, spec2gen4];
g2s = [gen2spec0, gen2spec1, gen2spec2, gen2spec3, gen2spec4];
g2g = [gen2gen0, gen2gen1, gen2gen2, gen2gen3, gen2gen4];


h = heatmap(log([spec2spec0, spec2spec1, spec2spec2, spec2spec3, spec2spec4;...
             spec2gen0, spec2gen1, spec2gen2, spec2gen3, spec2gen4;...
             gen2spec0, gen2spec1, gen2spec2, gen2spec3, gen2spec4;...
             gen2gen0, gen2gen1, gen2gen2, gen2gen3, gen2gen4]),...
             'Colormap',jet)   
Ax = gca;
Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
Ax.YDisplayLabels = nan(size(Ax.YDisplayData));



