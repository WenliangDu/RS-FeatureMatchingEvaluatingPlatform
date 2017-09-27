function [FeaturesImagePlaneCoordinatesL_Qualified,FeaturesImagePlaneCoordinatesR_Qualified,FeaturesImagePlaneCoordinatesL,FeaturesImagePlaneCoordinatesR,WrongFeaturesRecord] = Simulation_ProjectToImagePlane_alpha2(hm,FeaturesCoordinates,WorldPlane_OriginL,WorldPlane_LeftMostL,WorldPlane_RightMostL,ImagePlane_FocalL,...
    WorldPlane_OriginR,WorldPlane_LeftMostR,WorldPlane_RightMostR,ImagePlane_FocalR,Interpolation,FocalLengthL,UnitDistanceL,FocalLengthR,UnitDistanceR,CameraDetail,Target)
%{
2017/04/22
Simulation_ProjectToImagePlane_alpha1
1. Project features from world plane to image plane
2. Qualify the projected features.

2017/04/23
Simulation_ProjectToImagePlane_alpha2
1. IdentifyWrongFeatures_alpha2=>3
2. Qualify features firstly
%}
%% 
HighestZ = max(hm(:));
[WorldPlane_OriginCoordinatesL,WorldPlane_OriginCoCoordinatesL,ImagePlane_FocalCoordinatesL,WorldPlane_LeftMostOriginCoCoordinatesL,WorldPlane_RightMostCoCoordinatesL] = ObtainInfoInFeaturePlane_alpha1(FeaturesCoordinates,WorldPlane_OriginL,WorldPlane_LeftMostL,WorldPlane_RightMostL,ImagePlane_FocalL);
[WorldPlane_OriginCoordinatesR,WorldPlane_OriginCoCoordinatesR,ImagePlane_FocalCoordinatesR,WorldPlane_LeftMostOriginCoCoordinatesR,WorldPlane_RightMostCoCoordinatesR] = ObtainInfoInFeaturePlane_alpha1(FeaturesCoordinates,WorldPlane_OriginR,WorldPlane_LeftMostR,WorldPlane_RightMostR,ImagePlane_FocalR);
% %% test
% FeaturesCoordinatesOld = FeaturesCoordinates;
% WorldPlane_OriginCoordinatesLOld = WorldPlane_OriginCoordinatesL;
% WorldPlane_OriginCoCoordinatesLOld = WorldPlane_OriginCoCoordinatesL;
% ImagePlane_FocalCoordinatesLOld = ImagePlane_FocalCoordinatesL;
%% Qualify the features
[WrongFeaturesRecord,FeaturesCoordinates,WorldPlane_OriginCoordinatesL,WorldPlane_OriginCoCoordinatesL,ImagePlane_FocalCoordinatesL,...
    WorldPlane_OriginCoordinatesR,WorldPlane_OriginCoCoordinatesR,ImagePlane_FocalCoordinatesR] = IdentifyWrongFeatures_alpha3(FeaturesCoordinates,ImagePlane_FocalCoordinatesL,WorldPlane_LeftMostOriginCoCoordinatesL,WorldPlane_RightMostCoCoordinatesL,ImagePlane_FocalCoordinatesR,WorldPlane_LeftMostOriginCoCoordinatesR,WorldPlane_RightMostCoCoordinatesR,Interpolation,HighestZ,...
    WorldPlane_OriginL,WorldPlane_LeftMostL,WorldPlane_RightMostL,ImagePlane_FocalL,WorldPlane_OriginR,WorldPlane_LeftMostR,WorldPlane_RightMostR,ImagePlane_FocalR,...
    WorldPlane_OriginCoordinatesL,WorldPlane_OriginCoCoordinatesL,WorldPlane_OriginCoordinatesR,WorldPlane_OriginCoCoordinatesR);

% FeaturesCoordinatesDiff = sum(FeaturesCoordinatesOld - FeaturesCoordinates,2);
% WorldPlane_OriginCoordinatesLDiff = sum(WorldPlane_OriginCoordinatesLOld - WorldPlane_OriginCoordinatesL,2);
% WorldPlane_OriginCoCoordinatesLDiff = sum(WorldPlane_OriginCoCoordinatesLOld - WorldPlane_OriginCoCoordinatesL,2);
% ImagePlane_FocalCoordinatesLDiff = sum(ImagePlane_FocalCoordinatesLOld - ImagePlane_FocalCoordinatesL,2);

% FeaturesCoordinatesDiff2 = find(FeaturesCoordinatesDiff~=0);
% WorldPlane_OriginCoordinatesLDiff2 = find(WorldPlane_OriginCoordinatesLDiff~=0);
% WorldPlane_OriginCoCoordinatesLDiff2 = find(WorldPlane_OriginCoCoordinatesLDiff~=0);
% ImagePlane_FocalCoordinatesLDiff2 = find(ImagePlane_FocalCoordinatesLDiff~=0);

%% Project features from world plane to image plane
FeaturesImagePlaneCoordinatesL = Projection_WorldtoImage_alpha5(FeaturesCoordinates,WorldPlane_OriginCoordinatesL,WorldPlane_OriginCoCoordinatesL,ImagePlane_FocalCoordinatesL,FocalLengthL,UnitDistanceL);
FeaturesImagePlaneCoordinatesR = Projection_WorldtoImage_alpha5(FeaturesCoordinates,WorldPlane_OriginCoordinatesR,WorldPlane_OriginCoCoordinatesR,ImagePlane_FocalCoordinatesR,FocalLengthR,UnitDistanceR);

%% Qualify the features
WrongFeaturesRecordLX = (FeaturesImagePlaneCoordinatesL(:,1) < (-CameraDetail(3,Target))/2) | (FeaturesImagePlaneCoordinatesL(:,1) > (CameraDetail(3,Target))/2);
WrongFeaturesRecordLY = (FeaturesImagePlaneCoordinatesL(:,2) < (-floor((CameraDetail(4,Target)-1)/2))) | (FeaturesImagePlaneCoordinatesL(:,2) > (floor((CameraDetail(4,Target)-1)/2)+1));

WrongFeaturesRecordRX = (FeaturesImagePlaneCoordinatesR(:,1) < (-CameraDetail(3,Target))/2) | (FeaturesImagePlaneCoordinatesR(:,1) > (CameraDetail(3,Target))/2);
WrongFeaturesRecordRY = (FeaturesImagePlaneCoordinatesR(:,2) < (-floor((CameraDetail(4,Target)-1)/2))) | (FeaturesImagePlaneCoordinatesR(:,2) > (floor((CameraDetail(4,Target)-1)/2)+1));

WrongFeaturesRecord = WrongFeaturesRecord | WrongFeaturesRecordLX | WrongFeaturesRecordLY | WrongFeaturesRecordRX | WrongFeaturesRecordRY;

FeaturesImagePlaneCoordinatesL_Qualified = FeaturesImagePlaneCoordinatesL(~WrongFeaturesRecord,:);
FeaturesImagePlaneCoordinatesR_Qualified = FeaturesImagePlaneCoordinatesR(~WrongFeaturesRecord,:);