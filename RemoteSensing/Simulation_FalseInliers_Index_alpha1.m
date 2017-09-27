function [FeaturesCoordinatesA_New,FeaturesCoordinatesB_New,TrueInliersIndex,FalseInliersIndex] = Simulation_FalseInliers_Index_alpha1(FeaturesCoordinatesA,FeaturesCoordinatesB,SamplingNumbers,FalseInlierNumber)
%{
2017/04/27
Simulation_FalseInliers_Index_alpha1
1. Arrange the index of FeaturesCoordinatesA and FeaturesCoordinatesB in new mapping

%}

FeaturesNum = size(FeaturesCoordinatesA,1);

RecordTrueInliers = true(1,FeaturesNum);
RecordTrueInliers(SamplingNumbers) = false;
RecordTrueInliers(FalseInlierNumber) = false;
RecordFeaturesNum = 1:1:FeaturesNum;
TrueInliersNumbers = RecordFeaturesNum(RecordTrueInliers);

%% Outputs
FeaturesCoordinatesA_New = [FeaturesCoordinatesA(TrueInliersNumbers,:) ; FeaturesCoordinatesA(SamplingNumbers,:)];
FeaturesCoordinatesB_New = [FeaturesCoordinatesB(TrueInliersNumbers,:) ; FeaturesCoordinatesB(FalseInlierNumber,:)];
TrueInliersIndex = 1:1:length(TrueInliersNumbers);
FalseInliersIndex = (length(TrueInliersNumbers) + 1):1:size(FeaturesCoordinatesA_New,1);