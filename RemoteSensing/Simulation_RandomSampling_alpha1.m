function [FeaturesCoordinatesA_S,FeaturesCoordinatesB_S,FeaturesCoordinatesA_R,FeaturesCoordinatesB_R,SamplingOrder] = Simulation_RandomSampling_alpha1(FeaturesCoordinatesA,FeaturesCoordinatesB,SamplingNum)
%{
2017/04/27
Simulation_RandomSampling_alpha1
1. Random Sampling FeaturesCoordinatesA and FeaturesCoordinatesB in
SamplingNum.
FeaturesCoordinatesA_S: Sampled FeaturesCoordinatesA;
FeaturesCoordinatesB_S: Sampled FeaturesCoordinatesB;
FeaturesCoordinatesA_R: Rest FeaturesCoordinatesA;
FeaturesCoordinatesB_R: Rest FeaturesCoordinatesB;

2017/05/01
1. Output add SamplingOrder
%}
FeaturesCoordinatesNum = size(FeaturesCoordinatesA,1);
RecordNum = true(1,FeaturesCoordinatesNum);
SamplingOrder = randperm(FeaturesCoordinatesNum,SamplingNum);
RecordNum(SamplingOrder) = false;

FeaturesCoordinatesA_S = FeaturesCoordinatesA(SamplingOrder,:);
FeaturesCoordinatesB_S = FeaturesCoordinatesB(SamplingOrder,:);
FeaturesCoordinatesA_R = FeaturesCoordinatesA(RecordNum,:);
FeaturesCoordinatesB_R = FeaturesCoordinatesB(RecordNum,:);