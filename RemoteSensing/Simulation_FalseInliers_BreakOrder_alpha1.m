function [FeaturesCoordinatesA_ReOrdered,FeaturesCoordinatesB_ReOrdered,TrueInliers,TrueOutiers,indexPairs] = Simulation_FalseInliers_BreakOrder_alpha1(FeaturesCoordinatesA,FeaturesCoordinatesB,TrueInliersIndex,FalseInliersIndex)
%{
2017/05/04
Simulation_FalseInliers_BreakOrder_alpha1
1. Re-order the correcepondences randomly.

%}
NewNum = size(FeaturesCoordinatesA,1);
NewOrderA = randperm( NewNum );
NewOrderB = randperm( NewNum );
FeaturesCoordinatesA_ReOrdered = FeaturesCoordinatesA(NewOrderA,:);
FeaturesCoordinatesB_ReOrdered = FeaturesCoordinatesB(NewOrderB,:);
% FeaturesCoordinatesA_ReOrdered = zeros(size(ReOrderedFeaturesCoordinatesA));
% FeaturesCoordinatesB_ReOrdered = zeros(size(ReOrderedFeaturesCoordinatesB));

%% Generate indexPairs, TrueInliers and TrueOutliers
indexPairs = zeros(NewNum,2);

RandomTraverseOrder = randperm( NewNum );
TrueInliers = zeros(size(TrueInliersIndex));
TrueOutiers = zeros(size(FalseInliersIndex));
I_Index = 0;
O_Index = 0;
for j = 1:NewNum,
    Serial1 = find(NewOrderA == RandomTraverseOrder(j),1);
    Serial2 = find(NewOrderB == RandomTraverseOrder(j),1);
    indexPairs(j,:) = [Serial1 Serial2];
    if RandomTraverseOrder(j) < FalseInliersIndex(1),
        I_Index = I_Index+1;
        TrueInliers(I_Index) = j;
    else
        O_Index = O_Index+1;
        TrueOutiers(O_Index) = j;
    end
end