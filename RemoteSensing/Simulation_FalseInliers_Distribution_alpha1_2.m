function [SamplingNumbers,FalseInlierNumber] = Simulation_FalseInliers_Distribution_alpha1_2(Ratio,A_xy_array,DistributionFactor)
%{
2017/01/10
TestWarping_FalseInliers_alpha1
1. Simulate FalseInliers as Additive white Gaussian noise.


2017/01/21
TestWarping_FalseInliers_alpha2
1. Remove: Ratio = Ratio/10;

2017/04/27
Simulation_FalseInliers_Distribution_alpha1
1. Fit for Simulation_all_SAVE_alpha1.m
2. Use the distance between projected features in imageB and features in
imageA.

2017/05/01
Simulation_FalseInliers_Distribution_alpha1_1
1. Use the coordinates of features in world plane to generate false inliers.
2. Reduce the time complexity
2017/05/02
1. Add DistributionFactor

2017/05/06
Simulation_FalseInliers_Distribution_alpha1_2
1. Reduce the time complexity
    1.1 Use randperm instead of unidrnd for generating unique sampling
    number in one time.
    1.2 Remove some for loops
2. Use Gaussian Distribution instead of bionomial distribution => Simulation_GaussianDistribution_alpha1
%}
if Ratio == 0,
    SamplingNumbers = [];
    FalseInlierNumber = [];
	return 
end
if isempty(Ratio),
    SamplingNumbers = [];
    FalseInlierNumber = [];
	return 
end
%% Generate False inliers in reference image by normal distribution (SamplingNumbers);
ToltalL = size(A_xy_array,1);
SamplingL = round(ToltalL*Ratio);
SamplingNumbers = randperm(ToltalL,SamplingL); % Discrete uniform random

%% PercentageTraverse (Columns of generating FalseInlierNumber)
[PDistriF,PercentageArray] = Simulation_GaussianDistribution_alpha1;
SelectNumber = round(PDistriF.*SamplingL);
if sum(SelectNumber) ~= SamplingL,
    SelectNumber(6) = SelectNumber(6) + (SamplingL - sum(SelectNumber));
end
PercentageArray = PercentageArray.*DistributionFactor;
PercentageTraverse = PercentageArray.*round( (ToltalL/100) );
PercentageTraverse(1,1) = 1;

%% TraveralNum (Rows of generating FalseInlierNumber)
SelectNumberL = length(SelectNumber);
LastNum = 0;
TraveralNum = zeros(SelectNumberL,2);
for i = 1:SelectNumberL, % TraveralNum
    if SelectNumber(i) ~= 0,
        TraveralNum(i,1) = LastNum + 1;
        TraveralNum(i,2) = TraveralNum(i,1) + SelectNumber(i) - 1;
        LastNum = TraveralNum(i,2);
    end
end
%%
SelectedRecord = true(1,ToltalL);
SelectedRecordRef = 1:1:ToltalL;
FalseInlierNumber = zeros(size(SamplingNumbers));

%% Generate false inliers in template images (FalseInlierNumber)
%
MdlKDTA_xy_array = KDTreeSearcher(A_xy_array);
[SamplingNeighbours,~] = knnsearch(MdlKDTA_xy_array,A_xy_array(SamplingNumbers,:),'K',ToltalL);
k = 1;
for i = 1:SelectNumberL,
    if SelectNumber(i) ~= 0,
        CurrentSamplingNeighbours = SamplingNeighbours(TraveralNum(i,1):TraveralNum(i,2),:);
        for j = 1:size(CurrentSamplingNeighbours,1),
            CurrentSelectedRecord = SelectedRecord;
            CurrentSelectedRecord(SamplingNumbers(k)) = false;
            
            CurrentTravereLeft = PercentageTraverse(i,1);
            CurrentTravereRight = PercentageTraverse(i,2);
            CurrentSelectOrderSub = CurrentSamplingNeighbours(j,CurrentTravereLeft:CurrentTravereRight);
            CurrentSelectOrder = CurrentSelectOrderSub(CurrentSelectedRecord(CurrentSelectOrderSub));
            if ~isempty(CurrentSelectOrder),
                if length(CurrentSelectOrder) > 1,
                    CurrentSelectOrderSub2 = randi([1,length(CurrentSelectOrder)],1);
                else
                    CurrentSelectOrderSub2 = 1;
                end
            else
                CurrentSelectOrder = SelectedRecordRef(CurrentSelectedRecord);
                CurrentSelectOrderSub2 = randi([1,length(CurrentSelectOrder)],1);
            end
            FalseInlierNumber(k) = CurrentSelectOrder(CurrentSelectOrderSub2);
            SelectedRecord(CurrentSelectOrder(CurrentSelectOrderSub2)) = false;
            k = k + 1;
        end
    end
end
