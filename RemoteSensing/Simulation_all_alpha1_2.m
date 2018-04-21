%{
2017/04/15
1. Add offset in y direction.

2017/04/17
PushBroom_Simulation_alpha1_4 => 1_5

2017/04/19
test_alpha4
Update:
1. PushBroom_Simulation_alpha1_5 => 1_6
2. Projection_WorldtoImage_alpha4 => 5
Add: 
1. IdentifyWrongFeatures_alpha2

2017/04/22
Simulation_all_alpha1
1. Arrange the program

2017/09/26
Simulation_all_alpha1_1
1. For uploading to Github

2017/11/23
Simulation_all_alpha1_2
1. Add MeanFactor
2. Simulation_FalseInliers_alpha1_3 => Simulation_FalseInliers_alpha1_4

2018/04/21
Simulation_all_alpha1_2
1. Add SpacialResolution in y axis
Simulation_all_sub_alpha1_3 = >Simulation_all_sub_alpha1_3_1


Copyright (c) 2017 by Wenliang Du (du_wenliang@qq.com), 
Faculty of Information and Technolgy, Macau University of Science and Technology
Last Modified 2017/04/21
%}
clear
close all;
%% Outputs: FeaturesCoordinatesA_NewReOrdered, FeaturesCoordinatesB_NewReOrdered, TrueInliers, TrueOutiers, indexPairs
% FeaturesCoordinatesA_NewReOrdered: feature-points from left frame
% FeaturesCoordinatesB_NewReOrdered: feature-points from right frame
% indexPairs: correspondence map
% TrueInliers: index of inliers at indexPairs
% TrueOutiers: index of outliers at indexPairs

%% Initial specification and extrinsic parameters of remoters
Target = 2; % 1: LROC; 2. HiRISE
DeltaSlewAngle = 15; % difference of slewing angles of two remoters
DeltaEmissionAngle = 30; % difference of emission angles of two remoters
FeaturesNum = 1100; % initial number of feature-points in the coverage of world plane
OffsetRadius = 1000; % offset of central nadir points of two remoters. (meters)
SlewAngleRange = 30; % maximum slewing angle
EmissionAngleRange = 30; % maximum emission angle
Ratio = 0.2; % outliers ratio
DistributionFactor = 1; % ratio of the distance to farthest neigbour (0~1)
MeanFactor = -4; % Shift factor of mean value of Gaussian distribution. (-5:1:0)
%% Initial parameters of simulating terrain
Initial_Elevation = 2000;
Initial_Roughness = 2000;
Initial_RoughRoughness = 500;

%% Simulate correspondences
[FeaturesImagePlaneCoordinatesL_Qualified,FeaturesImagePlaneCoordinatesR_Qualified,SlewAngleL,SlewAngleR,EmissionAngleL,EmissionAngleR,Offset,FeaturesCoordinates_Qualified,Interpolation,xm,ym,hm] = Simulation_all_sub_alpha1_3_1(Target,DeltaSlewAngle,DeltaEmissionAngle,SlewAngleRange,EmissionAngleRange,OffsetRadius,FeaturesNum,Initial_Elevation,Initial_Roughness,Initial_RoughRoughness);
SamplingNum = size(FeaturesImagePlaneCoordinatesL_Qualified,1); % actual number of simulated correspondences.
% Some correspondences are removed because they are occluded by some
% "mountains" or not captured by both remoters. If you want to get a
% specific number of simulated correspondences, you can scale up the number
% of FeaturesNum, then sample the specific number correspondences from
% them.

figure,
plot(FeaturesImagePlaneCoordinatesL_Qualified(:,1),FeaturesImagePlaneCoordinatesL_Qualified(:,2),'ro');hold on
plot(FeaturesImagePlaneCoordinatesR_Qualified(:,1),FeaturesImagePlaneCoordinatesR_Qualified(:,2),'b*');
for i = 1:size(FeaturesImagePlaneCoordinatesL_Qualified,1),
    line([FeaturesImagePlaneCoordinatesL_Qualified(i,1) FeaturesImagePlaneCoordinatesR_Qualified(i,1)],[FeaturesImagePlaneCoordinatesL_Qualified(i,2) FeaturesImagePlaneCoordinatesR_Qualified(i,2)],'Color','g');
end
title(strcat('',num2str(SamplingNum),' simulated correspondences'));
legend('feature-points from left image frame','feature-points from right image frame');

figure,
surf(xm, ym, hm);
title('Simulated terrain');
%% Simulate outliers (false correspondences)
[FeaturesCoordinatesA_S,FeaturesCoordinatesB_S,FeaturesCoordinatesA_R,FeaturesCoordinatesB_R,SamplingOrder_S] = Simulation_RandomSampling_alpha1(FeaturesImagePlaneCoordinatesL_Qualified,FeaturesImagePlaneCoordinatesR_Qualified,SamplingNum);
FeaturesCoordinates_Qualified_S = FeaturesCoordinates_Qualified(SamplingOrder_S,1:2); % Re-order the feature-points randomly to avoid the influence of order
[FeaturesCoordinatesA_NewReOrdered,FeaturesCoordinatesB_NewReOrdered,TrueInliers,TrueOutiers,indexPairs,SamplingOrder_R] = Simulation_FalseInliers_alpha1_4(FeaturesCoordinates_Qualified_S,FeaturesCoordinatesA_S,FeaturesCoordinatesB_S,Ratio,FeaturesCoordinatesA_R,FeaturesCoordinatesB_R,DistributionFactor,MeanFactor);

figure,
plot(FeaturesCoordinatesA_NewReOrdered(:,1),FeaturesCoordinatesA_NewReOrdered(:,2),'ro');hold on
plot(FeaturesCoordinatesB_NewReOrdered(:,1),FeaturesCoordinatesB_NewReOrdered(:,2),'b*');
for i = 1:length(TrueInliers),
    line([FeaturesCoordinatesA_NewReOrdered(indexPairs(TrueInliers(i),1),1) FeaturesCoordinatesB_NewReOrdered(indexPairs(TrueInliers(i),2),1)],[FeaturesCoordinatesA_NewReOrdered(indexPairs(TrueInliers(i),1),2) FeaturesCoordinatesB_NewReOrdered(indexPairs(TrueInliers(i),2),2)],'Color','g');
end
for i = 1:length(TrueOutiers),
    line([FeaturesCoordinatesA_NewReOrdered(indexPairs(TrueOutiers(i),1),1) FeaturesCoordinatesB_NewReOrdered(indexPairs(TrueOutiers(i),2),1)],[FeaturesCoordinatesA_NewReOrdered(indexPairs(TrueOutiers(i),1),2) FeaturesCoordinatesB_NewReOrdered(indexPairs(TrueOutiers(i),2),2)],'Color','m');
end
title(strcat('',num2str(SamplingNum),' simulated correspondences with ',num2str(Ratio*100),' outliers'));
legend('feature-points from left image frame','feature-points from right image frame');