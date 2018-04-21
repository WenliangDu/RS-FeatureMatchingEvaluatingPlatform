function [FeaturesImagePlaneCoordinatesL_Qualified,FeaturesImagePlaneCoordinatesR_Qualified,SlewAngleL,SlewAngleR,EmissionAngleL,EmissionAngleR,Offset,FeaturesCoordinates_Qualified,Interpolation,xm,ym,hm] = Simulation_all_sub_alpha1_3_1(Target,DeltaSlewAngle,DeltaEmissionAngle,SlewAngleRange,EmissionAngleRange,OffsetRadius,FeaturesNum,Initial_Elevation,Initial_Roughness,Initial_RoughRoughness)
%{
2017/04/23
Simulation_all_sub_alpha1
1. Generate FeaturesImagePlaneCoordinatesL_Qualified and
FeaturesImagePlaneCoordinatesR_Qualified by Target,DeltaSlewAngle,DeltaEmissionAngle,FeaturesNum,Initial_Elevation,Initial_Roughness,Initial_RoughRoughness

2017/05/01
Simulation_all_sub_alpha1
1. Output add WrongFeaturesRecord

2017/07/06
Simulation_all_sub_alpha1_2
New stereo system
1. Simulation_Initialization_alpha2=>Simulation_Initialization_alpha3 (initialize FOV instead of SpacialResolution)
2. PushBroom_Simulation_alpha1_7 => PushBroom_Simulation_alpha1_8 (1. Calculate UnitDistance with FOV
2. Nadir distance equal to camera distance)


2017/09/26
Simulation_all_sub_alpha1_3
1. For uploading to Github => plot

2018/04/21
Simulation_all_sub_alpha1_3_1
1. Add SpacialResolution in y axis
PushBroom_Simulation_alpha1_8=>PushBroom_Simulation_alpha1_9
Simulation_ProjectToImagePlane_alpha2=>Simulation_ProjectToImagePlane_alpha2_1

In Simulation_ProjectToImagePlane_alpha2_1
Projection_WorldtoImage_alpha5=>Projection_WorldtoImage_alpha5_1

%}
%% Generate CameraDetail, SlewAngleL, EmissionAngle and Offset
[CameraDetail,SlewAngleL,SlewAngleR,EmissionAngleL,EmissionAngleR,Offset] = Simulation_Initialization_alpha3(DeltaSlewAngle,DeltaEmissionAngle,SlewAngleRange,EmissionAngleRange,OffsetRadius);
%% Generate ImagePlane_Origin, ImagePlane_Focal, WorldPlane_Origin, WorldPlane_LeftMost, WorldPlane_RightMost, WorldPlane_LeftTop...
[ImagePlane_OriginL,ImagePlane_FocalL,WorldPlane_OriginL,WorldPlane_LeftMostL,WorldPlane_RightMostL,...
    WorldPlane_LeftTopL,WorldPlane_LeftBottomL,WorldPlane_RightTopL,WorldPlane_RightBottomL,FocalLengthL,UnitDistanceL,ImagePlane_LeftMostL,ImagePlane_RightMostL,SpacialResolution] =...
    PushBroom_Simulation_alpha1_9(SlewAngleL,EmissionAngleL,Target,CameraDetail);

[ImagePlane_OriginR,ImagePlane_FocalR,WorldPlane_OriginR,WorldPlane_LeftMostR,WorldPlane_RightMostR,...
    WorldPlane_LeftTopR,WorldPlane_LeftBottomR,WorldPlane_RightTopR,WorldPlane_RightBottomR,FocalLengthR,UnitDistanceR,ImagePlane_LeftMostR,ImagePlane_RightMostR,SpacialResolution] =...
    PushBroom_Simulation_alpha1_9(SlewAngleR,EmissionAngleR,Target,CameraDetail,Offset);
%% Generate FeaturesCoordinates
[FeaturesCoordinates,Interpolation,xm,ym,hm] = Simulation_FeaturesGeneration_alpha1(FeaturesNum,Initial_Elevation,Initial_Roughness,Initial_RoughRoughness,WorldPlane_LeftTopL,WorldPlane_RightTopL,WorldPlane_LeftTopR,WorldPlane_RightTopR,...
    WorldPlane_LeftBottomL,WorldPlane_RightBottomL,WorldPlane_LeftBottomR,WorldPlane_RightBottomR);

%% Project features from world plane to image plane
% [FeaturesImagePlaneCoordinatesL_Qualified2,FeaturesImagePlaneCoordinatesR_Qualified2,FeaturesImagePlaneCoordinatesL2,FeaturesImagePlaneCoordinatesR2,WrongFeaturesRecord2] = Simulation_ProjectToImagePlane_alpha2(hm,FeaturesCoordinates,WorldPlane_OriginL,WorldPlane_LeftMostL,WorldPlane_RightMostL,ImagePlane_FocalL,...
%     WorldPlane_OriginR,WorldPlane_LeftMostR,WorldPlane_RightMostR,ImagePlane_FocalR,Interpolation,FocalLengthL,UnitDistanceL,FocalLengthR,UnitDistanceR,CameraDetail,Target);

[FeaturesImagePlaneCoordinatesL_Qualified,FeaturesImagePlaneCoordinatesR_Qualified,FeaturesImagePlaneCoordinatesL,FeaturesImagePlaneCoordinatesR,WrongFeaturesRecord] = Simulation_ProjectToImagePlane_alpha2_1(hm,FeaturesCoordinates,WorldPlane_OriginL,WorldPlane_LeftMostL,WorldPlane_RightMostL,ImagePlane_FocalL,...
    WorldPlane_OriginR,WorldPlane_LeftMostR,WorldPlane_RightMostR,ImagePlane_FocalR,Interpolation,FocalLengthL,UnitDistanceL,FocalLengthR,UnitDistanceR,CameraDetail,Target,SpacialResolution);
FeaturesCoordinates_Qualified = FeaturesCoordinates(~WrongFeaturesRecord,:);
%

% 
%% Plot
% figure,
% plot(FeaturesImagePlaneCoordinatesL_Qualified(:,1),FeaturesImagePlaneCoordinatesL_Qualified(:,2),'m*');hold on
% plot(FeaturesImagePlaneCoordinatesR_Qualified(:,1),FeaturesImagePlaneCoordinatesR_Qualified(:,2),'g*');
% for i = 1:size(FeaturesImagePlaneCoordinatesL_Qualified,1),
%     line([FeaturesImagePlaneCoordinatesL_Qualified(i,1) FeaturesImagePlaneCoordinatesR_Qualified(i,1)],[FeaturesImagePlaneCoordinatesL_Qualified(i,2) FeaturesImagePlaneCoordinatesR_Qualified(i,2)],'Color','y');
% end
% figure,
% FeaturesImagePlaneCoordinatesLWrong = FeaturesImagePlaneCoordinatesL(WrongFeaturesRecord,:);
% FeaturesImagePlaneCoordinatesRWrong = FeaturesImagePlaneCoordinatesR(WrongFeaturesRecord,:);
% plot(FeaturesImagePlaneCoordinatesLWrong(:,1),FeaturesImagePlaneCoordinatesLWrong(:,2),'m*');hold on
% plot(FeaturesImagePlaneCoordinatesRWrong(:,1),FeaturesImagePlaneCoordinatesRWrong(:,2),'g*');
% for i = 1:size(FeaturesImagePlaneCoordinatesLWrong,1),
%     line([FeaturesImagePlaneCoordinatesLWrong(i,1) FeaturesImagePlaneCoordinatesRWrong(i,1)],[FeaturesImagePlaneCoordinatesLWrong(i,2) FeaturesImagePlaneCoordinatesRWrong(i,2)],'Color','k');
% end

% figure,
% plot(FeaturesImagePlaneCoordinatesL_Qualified2(:,1),FeaturesImagePlaneCoordinatesL_Qualified2(:,2),'m*');hold on
% plot(FeaturesImagePlaneCoordinatesR_Qualified2(:,1),FeaturesImagePlaneCoordinatesR_Qualified2(:,2),'g*');
% for i = 1:size(FeaturesImagePlaneCoordinatesL_Qualified2,1),
%     line([FeaturesImagePlaneCoordinatesL_Qualified2(i,1) FeaturesImagePlaneCoordinatesR_Qualified2(i,1)],[FeaturesImagePlaneCoordinatesL_Qualified2(i,2) FeaturesImagePlaneCoordinatesR_Qualified2(i,2)],'Color','y');
% end
% FeaturesImagePlaneCoordinatesLWrong2 = FeaturesImagePlaneCoordinatesL2(WrongFeaturesRecord2,:);
% FeaturesImagePlaneCoordinatesRWrong2 = FeaturesImagePlaneCoordinatesR2(WrongFeaturesRecord2,:);
% for i = 1:size(FeaturesImagePlaneCoordinatesLWrong2,1),
%     line([FeaturesImagePlaneCoordinatesLWrong2(i,1) FeaturesImagePlaneCoordinatesRWrong2(i,1)],[FeaturesImagePlaneCoordinatesLWrong2(i,2) FeaturesImagePlaneCoordinatesRWrong2(i,2)],'Color','k');
% end



% figure,
% plot(FeaturesImagePlaneCoordinatesL(:,1),FeaturesImagePlaneCoordinatesL(:,2),'m*');hold on
% plot(FeaturesImagePlaneCoordinatesR(:,1),FeaturesImagePlaneCoordinatesR(:,2),'g*');
% 
% for i = 1:size(FeaturesImagePlaneCoordinatesL,1),
%     line([FeaturesImagePlaneCoordinatesL(i,1) FeaturesImagePlaneCoordinatesR(i,1)],[FeaturesImagePlaneCoordinatesL(i,2) FeaturesImagePlaneCoordinatesR(i,2)],'Color','y');
% end
% for i = 1:size(FeaturesImagePlaneCoordinatesLWrong,1),
%     line([FeaturesImagePlaneCoordinatesLWrong(i,1) FeaturesImagePlaneCoordinatesRWrong(i,1)],[FeaturesImagePlaneCoordinatesLWrong(i,2) FeaturesImagePlaneCoordinatesRWrong(i,2)],'Color','k');
% end
% 
% FeaturesImagePlaneCoordinatesLW = FeaturesImagePlaneCoordinatesL(WrongFeaturesRecord,:);
% FeaturesImagePlaneCoordinatesRW = FeaturesImagePlaneCoordinatesR(WrongFeaturesRecord,:);
% plot(FeaturesImagePlaneCoordinatesLW(:,1),FeaturesImagePlaneCoordinatesLW(:,2),'r*');
% plot(FeaturesImagePlaneCoordinatesRW(:,1),FeaturesImagePlaneCoordinatesRW(:,2),'b*');
% for j = 1:sum(WrongFeaturesRecord),
%     line([FeaturesImagePlaneCoordinatesLW(j,1) FeaturesImagePlaneCoordinatesRW(j,1)],[FeaturesImagePlaneCoordinatesLW(j,2) FeaturesImagePlaneCoordinatesRW(j,2)],'Color','k');
% end
% 
% FeaturesImagePlaneCoordinatesRightL = FeaturesImagePlaneCoordinatesL(~WrongFeaturesRecord,:);
% FeaturesImagePlaneCoordinatesRightR = FeaturesImagePlaneCoordinatesR(~WrongFeaturesRecord,:);
% figure,
% plot(FeaturesImagePlaneCoordinatesRightL(:,1),FeaturesImagePlaneCoordinatesRightL(:,2),'m*');hold on
% plot(FeaturesImagePlaneCoordinatesRightR(:,1),FeaturesImagePlaneCoordinatesRightR(:,2),'g*');
% for i = 1:size(FeaturesImagePlaneCoordinatesRightL,1),
%     line([FeaturesImagePlaneCoordinatesRightL(i,1) FeaturesImagePlaneCoordinatesRightR(i,1)],[FeaturesImagePlaneCoordinatesRightL(i,2) FeaturesImagePlaneCoordinatesRightR(i,2)],'Color','y');
% end



% %% For drawing part 1
% figure,
% plot3([ImagePlane_LeftMostL(1) ImagePlane_RightMostL(1)],[ImagePlane_LeftMostL(2) ImagePlane_RightMostL(2)],[ImagePlane_LeftMostL(3) ImagePlane_RightMostL(3)],'k-','LineWidth',2);hold on
% plot3([WorldPlane_LeftMostL(1) WorldPlane_RightMostL(1)],[WorldPlane_LeftMostL(2) WorldPlane_RightMostL(2)],[WorldPlane_LeftMostL(3) WorldPlane_RightMostL(3)],'k-','LineWidth',2);
% plot3([ImagePlane_LeftMostL(1) WorldPlane_RightMostL(1)],[ImagePlane_LeftMostL(2) WorldPlane_RightMostL(2)],[ImagePlane_LeftMostL(3) WorldPlane_RightMostL(3)],'k-');
% plot3([ImagePlane_RightMostL(1) WorldPlane_LeftMostL(1)],[ImagePlane_RightMostL(2) WorldPlane_LeftMostL(2)],[ImagePlane_RightMostL(3) WorldPlane_LeftMostL(3)],'k-');
% plot3([ImagePlane_OriginL(1) WorldPlane_OriginL(1)],[ImagePlane_OriginL(2) WorldPlane_OriginL(2)],[ImagePlane_OriginL(3) WorldPlane_OriginL(3)],'r-','LineWidth',2);
% %plot3([ImagePlane_FocalL(1) WorldPlane_OriginL(1)],[ImagePlane_FocalL(2) WorldPlane_OriginL(2)],[ImagePlane_FocalL(3) WorldPlane_OriginL(3)],'r-');
% 
% plot3([ImagePlane_LeftMostR(1) ImagePlane_RightMostR(1)],[ImagePlane_LeftMostR(2) ImagePlane_RightMostR(2)],[ImagePlane_LeftMostR(3) ImagePlane_RightMostR(3)],'k-','LineWidth',2);
% plot3([WorldPlane_LeftMostR(1) WorldPlane_RightMostR(1)],[WorldPlane_LeftMostR(2) WorldPlane_RightMostR(2)],[WorldPlane_LeftMostR(3) WorldPlane_RightMostR(3)],'k-','LineWidth',2);
% plot3([ImagePlane_LeftMostR(1) WorldPlane_RightMostR(1)],[ImagePlane_LeftMostR(2) WorldPlane_RightMostR(2)],[ImagePlane_LeftMostR(3) WorldPlane_RightMostR(3)],'k-');
% plot3([ImagePlane_RightMostR(1) WorldPlane_LeftMostR(1)],[ImagePlane_RightMostR(2) WorldPlane_LeftMostR(2)],[ImagePlane_RightMostR(3) WorldPlane_LeftMostR(3)],'k-');
% plot3([ImagePlane_OriginR(1) WorldPlane_OriginR(1)],[ImagePlane_OriginR(2) WorldPlane_OriginR(2)],[ImagePlane_OriginR(3) WorldPlane_OriginR(3)],'r-','LineWidth',2);
% %plot3([ImagePlane_FocalR(1) WorldPlane_OriginR(1)],[ImagePlane_FocalR(2) WorldPlane_OriginR(2)],[ImagePlane_FocalR(3) WorldPlane_OriginR(3)],'r-');
% 
% line([WorldPlane_OriginL(1) WorldPlane_OriginR(1)],[WorldPlane_OriginL(2) WorldPlane_OriginR(2)],'Color','k','LineStyle','--');
% %% For drawing part 2
%     %% Calculate overlapping
% OverlappingTop = min([WorldPlane_LeftTopL(2) WorldPlane_RightTopL(2) WorldPlane_LeftTopR(2) WorldPlane_RightTopR(2)]);
% OverlappingBottom = max([WorldPlane_LeftBottomL(2) WorldPlane_RightBottomL(2) WorldPlane_LeftBottomR(2) WorldPlane_RightBottomR(2)]);
% OverlappingLeft = max([WorldPlane_LeftTopL(1) WorldPlane_LeftTopR(1)]);
% OverlappingRight = min([WorldPlane_RightTopL(1) WorldPlane_RightTopR(1)]);
% 
%     %% Calculate TotalCoverage
% TotalCoverageTop = max([WorldPlane_LeftTopL(2) WorldPlane_RightTopL(2) WorldPlane_LeftTopR(2) WorldPlane_RightTopR(2)]);
% TotalCoverageBottom = min([WorldPlane_LeftBottomL(2) WorldPlane_RightBottomL(2) WorldPlane_LeftBottomR(2) WorldPlane_RightBottomR(2)]);
% TotalCoverageLeft = min([WorldPlane_LeftTopL(1) WorldPlane_LeftTopR(1)]);
% TotalCoverageRight = max([WorldPlane_RightTopL(1) WorldPlane_RightTopR(1)]);
% 
%  %% orbit
% OrbitTopL = ImagePlane_FocalL;
% OrbitTopL(2) = TotalCoverageTop;
% OrbitBottomL = ImagePlane_FocalL;
% OrbitBottomL(2) = TotalCoverageBottom;
% 
% OrbitTopR = ImagePlane_FocalR;
% OrbitTopR(2) = TotalCoverageTop;
% OrbitBottomR = ImagePlane_FocalR;
% OrbitBottomR(2) = TotalCoverageBottom;
% 
%     %% Draw imageplane
% ImagePlaneLength = (CameraDetail(4,Target)*UnitDistanceL)/2;
% ImagePlane_LeftTopL = ImagePlane_LeftMostL;
% ImagePlane_LeftBottomL = ImagePlane_LeftMostL;
% ImagePlane_LeftTopL(2) = ImagePlane_LeftTopL(2) + ImagePlaneLength;
% ImagePlane_LeftBottomL(2) = ImagePlane_LeftBottomL(2) - ImagePlaneLength;
% 
% ImagePlane_RightTopL = ImagePlane_RightMostL;
% ImagePlane_RightBottomL = ImagePlane_RightMostL;
% ImagePlane_RightTopL(2) = ImagePlane_RightTopL(2) + ImagePlaneLength;
% ImagePlane_RightBottomL(2) = ImagePlane_RightBottomL(2) - ImagePlaneLength;
% 
% ImagePlane_LeftTopR = ImagePlane_LeftMostR;
% ImagePlane_LeftBottomR = ImagePlane_LeftMostR;
% ImagePlane_LeftTopR(2) = ImagePlane_LeftTopR(2) + ImagePlaneLength;
% ImagePlane_LeftBottomR(2) = ImagePlane_LeftBottomR(2) - ImagePlaneLength;
% 
% ImagePlane_RightTopR = ImagePlane_RightMostR;
% ImagePlane_RightBottomR = ImagePlane_RightMostR;
% ImagePlane_RightTopR(2) = ImagePlane_RightTopR(2) + ImagePlaneLength;
% ImagePlane_RightBottomR(2) = ImagePlane_RightBottomR(2) - ImagePlaneLength;
% % line([TotalCoverageLeft TotalCoverageRight],[TotalCoverageTop TotalCoverageTop],'Color','k','LineWidth',2);
% % line([TotalCoverageRight TotalCoverageRight],[TotalCoverageTop TotalCoverageBottom],'Color','k','LineWidth',2);
% % line([TotalCoverageRight TotalCoverageLeft],[TotalCoverageBottom TotalCoverageBottom],'Color','k','LineWidth',2);
% % line([TotalCoverageLeft TotalCoverageLeft],[TotalCoverageBottom TotalCoverageTop],'Color','k','LineWidth',2);
% 
% % WorldPlane_L /magenta
% line([WorldPlane_LeftTopL(1) WorldPlane_LeftBottomL(1)],[WorldPlane_LeftTopL(2) WorldPlane_LeftBottomL(2)],'Color','m','LineWidth',2);hold on
% line([WorldPlane_LeftTopL(1) WorldPlane_RightTopL(1)],[WorldPlane_LeftTopL(2) WorldPlane_RightTopL(2)],'Color','m','LineWidth',2);
% line([WorldPlane_RightTopL(1) WorldPlane_RightBottomL(1)],[WorldPlane_RightTopL(2) WorldPlane_RightBottomL(2)],'Color','m','LineWidth',2);
% line([WorldPlane_RightBottomL(1) WorldPlane_LeftBottomL(1)],[WorldPlane_RightBottomL(2) WorldPlane_LeftBottomL(2)],'Color','m','LineWidth',2);
% % WorldPlane_R /blue
% line([WorldPlane_LeftTopR(1) WorldPlane_LeftBottomR(1)],[WorldPlane_LeftTopR(2) WorldPlane_LeftBottomR(2)],'Color','b','LineWidth',2);hold on
% line([WorldPlane_LeftTopR(1) WorldPlane_RightTopR(1)],[WorldPlane_LeftTopR(2) WorldPlane_RightTopR(2)],'Color','b','LineWidth',2);
% line([WorldPlane_RightTopR(1) WorldPlane_RightBottomR(1)],[WorldPlane_RightTopR(2) WorldPlane_RightBottomR(2)],'Color','b','LineWidth',2);
% line([WorldPlane_RightBottomR(1) WorldPlane_LeftBottomR(1)],[WorldPlane_RightBottomR(2) WorldPlane_LeftBottomR(2)],'Color','b','LineWidth',2);
% 
% 
% % ImagePlane_L /magenta
% plot3([ImagePlane_LeftTopL(1) ImagePlane_LeftBottomL(1)],[ImagePlane_LeftTopL(2) ImagePlane_LeftBottomL(2)],[ImagePlane_LeftTopL(3) ImagePlane_LeftBottomL(3)],'m-','LineWidth',2);
% plot3([ImagePlane_LeftTopL(1) ImagePlane_RightTopL(1)],[ImagePlane_LeftTopL(2) ImagePlane_RightTopL(2)],[ImagePlane_LeftTopL(3) ImagePlane_RightTopL(3)],'m-','LineWidth',2);
% plot3([ImagePlane_RightTopL(1) ImagePlane_RightBottomL(1)],[ImagePlane_RightTopL(2) ImagePlane_RightBottomL(2)],[ImagePlane_RightTopL(3) ImagePlane_RightBottomL(3)],'m-','LineWidth',2);
% plot3([ImagePlane_RightBottomL(1) ImagePlane_LeftBottomL(1)],[ImagePlane_RightBottomL(2) ImagePlane_LeftBottomL(2)],[ImagePlane_RightBottomL(3) ImagePlane_LeftBottomL(3)],'m-','LineWidth',2);
% % ImagePlane_R /blue
% plot3([ImagePlane_LeftTopR(1) ImagePlane_LeftBottomR(1)],[ImagePlane_LeftTopR(2) ImagePlane_LeftBottomR(2)],[ImagePlane_LeftTopR(3) ImagePlane_LeftBottomR(3)],'b-','LineWidth',2);
% plot3([ImagePlane_LeftTopR(1) ImagePlane_RightTopR(1)],[ImagePlane_LeftTopR(2) ImagePlane_RightTopR(2)],[ImagePlane_LeftTopR(3) ImagePlane_RightTopR(3)],'b-','LineWidth',2);
% plot3([ImagePlane_RightTopR(1) ImagePlane_RightBottomR(1)],[ImagePlane_RightTopR(2) ImagePlane_RightBottomR(2)],[ImagePlane_RightTopR(3) ImagePlane_RightBottomR(3)],'b-','LineWidth',2);
% plot3([ImagePlane_RightBottomR(1) ImagePlane_LeftBottomR(1)],[ImagePlane_RightBottomR(2) ImagePlane_LeftBottomR(2)],[ImagePlane_RightBottomR(3) ImagePlane_LeftBottomR(3)],'b-','LineWidth',2);
% 
% 
% plot3([OrbitTopL(1) OrbitBottomL(1)],[OrbitTopL(2) OrbitBottomL(2)],[OrbitTopL(3) OrbitBottomL(3)],'k--');
% plot3([OrbitTopR(1) OrbitBottomR(1)],[OrbitTopR(2) OrbitBottomR(2)],[OrbitTopR(3) OrbitBottomR(3)],'k--');
% axis equal
% x = 1;