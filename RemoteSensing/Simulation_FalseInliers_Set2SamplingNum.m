function [FeaturesCoordinatesA_New,FeaturesCoordinatesB_New,TrueInliersIndex,FalseInliersIndex,SamplingOrder] = Simulation_FalseInliers_Set2SamplingNum(FeaturesCoordinatesA_New,FeaturesCoordinatesB_New,TrueInliersIndex,FalseInliersIndex,FeaturesCoordinatesA_R,FeaturesCoordinatesB_R,SamplingNum)
%{
2017/04/27
Simulation_FalseInliers_Set2SamplingNum
2. Output add SamplingOrder_R (2017/05/06)

%}
RestSamplingNum = size(FeaturesCoordinatesA_R,1);
NewSamplingNum = SamplingNum - size(FeaturesCoordinatesA_New,1);
if NewSamplingNum > RestSamplingNum,
    NewSamplingNum = RestSamplingNum;
end


%RecordNum = true(1,RestSamplingNum);
SamplingOrder = randperm(RestSamplingNum,NewSamplingNum);
%RecordNum(SamplingOrder) = false;

FeaturesCoordinatesA_S = FeaturesCoordinatesA_R(SamplingOrder,:);
FeaturesCoordinatesB_S = FeaturesCoordinatesB_R(SamplingOrder,:);

FeaturesCoordinatesA_New = [FeaturesCoordinatesA_New(TrueInliersIndex,:);FeaturesCoordinatesA_S;FeaturesCoordinatesA_New(FalseInliersIndex,:)];
FeaturesCoordinatesB_New = [FeaturesCoordinatesB_New(TrueInliersIndex,:);FeaturesCoordinatesB_S;FeaturesCoordinatesB_New(FalseInliersIndex,:)];

TrueInliersIndexMore = length(TrueInliersIndex)+1:1:length(TrueInliersIndex)+NewSamplingNum;
TrueInliersIndex = [TrueInliersIndex TrueInliersIndexMore];
FalseInliersIndex = (length(TrueInliersIndex) + 1):1:size(FeaturesCoordinatesA_New,1);