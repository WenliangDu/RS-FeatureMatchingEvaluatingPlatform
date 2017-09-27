function [FeaturesCoordinates,Interpolation,xm,ym,hm] = Simulation_FeaturesGeneration_alpha1(FeaturesNum,Initial_Elevation,Initial_Roughness,Initial_RoughRoughness,WorldPlane_LeftTopL,WorldPlane_RightTopL,WorldPlane_LeftTopR,WorldPlane_RightTopR,...
    WorldPlane_LeftBottomL,WorldPlane_RightBottomL,WorldPlane_LeftBottomR,WorldPlane_RightBottomR)
%{
2017/04/22
Simulation_FeaturesGeneration_alpha1
1. Generate features based on FeaturesNum for LROC-NAC and HiRISE

    
% Initial_Elevation        - Initial elevation
% Initial_Roughness        - Initial roughness (how much terrain can vary in a step)
% Initial_RoughRoughness   - Roughness roughness (how much roughness can vary in a step)
%}


%% Calculate overlapping
OverlappingTop = min([WorldPlane_LeftTopL(2) WorldPlane_RightTopL(2) WorldPlane_LeftTopR(2) WorldPlane_RightTopR(2)]);
OverlappingBottom = max([WorldPlane_LeftBottomL(2) WorldPlane_RightBottomL(2) WorldPlane_LeftBottomR(2) WorldPlane_RightBottomR(2)]);
OverlappingLeft = max([WorldPlane_LeftTopL(1) WorldPlane_LeftTopR(1)]);
OverlappingRight = min([WorldPlane_RightTopL(1) WorldPlane_RightTopR(1)]);

%% Calculate TotalCoverage
TotalCoverageTop = max([WorldPlane_LeftTopL(2) WorldPlane_RightTopL(2) WorldPlane_LeftTopR(2) WorldPlane_RightTopR(2)]);
TotalCoverageBottom = min([WorldPlane_LeftBottomL(2) WorldPlane_RightBottomL(2) WorldPlane_LeftBottomR(2) WorldPlane_RightBottomR(2)]);
TotalCoverageLeft = min([WorldPlane_LeftTopL(1) WorldPlane_LeftTopR(1)]);
TotalCoverageRight = max([WorldPlane_RightTopL(1) WorldPlane_RightTopR(1)]);

%% Random feature points
FeaturesCoordinates = zeros(FeaturesNum,3);
FeaturesCoordinates(:,1:2) = rand(FeaturesNum,2);
CoordinatesFactors1 = repmat([(OverlappingRight - OverlappingLeft) (OverlappingTop - OverlappingBottom)],[FeaturesNum 1]);
CoordinatesFactors2 = repmat([OverlappingLeft OverlappingBottom],[FeaturesNum 1]);
FeaturesCoordinates(:,1:2) = (FeaturesCoordinates(:,1:2).*CoordinatesFactors1) + CoordinatesFactors2;
% % Plot
% figure,
% % WorldPlane_L /magenta
% line([WorldPlane_LeftTopL(1) WorldPlane_LeftBottomL(1)],[WorldPlane_LeftTopL(2) WorldPlane_LeftBottomL(2)],'Color','m','LineWidth',2);hold on
% line([WorldPlane_LeftTopL(1) WorldPlane_RightTopL(1)],[WorldPlane_LeftTopL(2) WorldPlane_RightTopL(2)],'Color','m','LineWidth',2);
% line([WorldPlane_RightTopL(1) WorldPlane_RightBottomL(1)],[WorldPlane_RightTopL(2) WorldPlane_RightBottomL(2)],'Color','m','LineWidth',2);
% line([WorldPlane_RightBottomL(1) WorldPlane_LeftBottomL(1)],[WorldPlane_RightBottomL(2) WorldPlane_LeftBottomL(2)],'Color','m','LineWidth',2);
% % WorldPlane_R /green
% line([WorldPlane_LeftTopR(1) WorldPlane_LeftBottomR(1)],[WorldPlane_LeftTopR(2) WorldPlane_LeftBottomR(2)],'Color','g','LineWidth',2);hold on
% line([WorldPlane_LeftTopR(1) WorldPlane_RightTopR(1)],[WorldPlane_LeftTopR(2) WorldPlane_RightTopR(2)],'Color','g','LineWidth',2);
% line([WorldPlane_RightTopR(1) WorldPlane_RightBottomR(1)],[WorldPlane_RightTopR(2) WorldPlane_RightBottomR(2)],'Color','g','LineWidth',2);
% line([WorldPlane_RightBottomR(1) WorldPlane_LeftBottomR(1)],[WorldPlane_RightBottomR(2) WorldPlane_LeftBottomR(2)],'Color','g','LineWidth',2);
% % Overlapping /blue
% line([OverlappingLeft OverlappingRight],[OverlappingTop OverlappingTop],'Color','b','LineWidth',2);hold on
% line([OverlappingRight OverlappingRight],[OverlappingTop OverlappingBottom],'Color','b','LineWidth',2);
% line([OverlappingRight OverlappingLeft],[OverlappingBottom OverlappingBottom],'Color','b','LineWidth',2);
% line([OverlappingLeft OverlappingLeft],[OverlappingBottom OverlappingTop],'Color','b','LineWidth',2);
% 
% % TotalCoverage /black
% line([TotalCoverageLeft TotalCoverageRight],[TotalCoverageTop TotalCoverageTop],'Color','k','LineWidth',2);hold on
% line([TotalCoverageRight TotalCoverageRight],[TotalCoverageTop TotalCoverageBottom],'Color','k','LineWidth',2);
% line([TotalCoverageRight TotalCoverageLeft],[TotalCoverageBottom TotalCoverageBottom],'Color','k','LineWidth',2);
% line([TotalCoverageLeft TotalCoverageLeft],[TotalCoverageBottom TotalCoverageTop],'Color','k','LineWidth',2);
% % Random features /red stars
% plot(FeaturesCoordinates(:,1),FeaturesCoordinates(:,2),'r*');

% % convergence angle, L:magenta, R: green
% figure,
% line([ImagePlane_FocalL(1) WorldPlane_OriginL(1)],[ImagePlane_FocalL(3) WorldPlane_OriginL(3)],'Color','m','LineWidth',2);hold on
% line([WorldPlane_LeftMostL(1) WorldPlane_RightMostL(1)],[0 0],'Color','m','LineWidth',2);
% line([ImagePlane_FocalR(1) WorldPlane_OriginR(1)],[ImagePlane_FocalR(3) WorldPlane_OriginR(3)],'Color','g','LineWidth',2);
% line([WorldPlane_LeftMostR(1) WorldPlane_RightMostR(1)],[0 0],'Color','g','LineWidth',2);
% %% Convergence angle
% ImagePlane_FocalRE = ImagePlane_FocalR;
% ImagePlane_FocalRE(2) = ImagePlane_FocalRE(2) + tand(EmissionAngleR)*Offset(1) + Offset(2);
% 
% OLWOL = ImagePlane_OriginL - WorldPlane_OriginL;
% FRWOL = ImagePlane_FocalRE - WorldPlane_OriginL;
% ConvergenceAngle = CalculateCosAngle_alpha1(OLWOL,FRWOL);

%% Cover range
HorizontalRange = TotalCoverageRight - TotalCoverageLeft;
VerticalRange = TotalCoverageTop - TotalCoverageBottom;

%% Terrain generation
[~, ~, ~, xm, ym, hm] = generate_terrain2(7, 100, Initial_Elevation, Initial_Roughness, Initial_RoughRoughness);%2000,2000,500 %500, 500, 100
xm = xm .* (HorizontalRange/2);
xm = xm + (TotalCoverageLeft - min(xm(:,1)));
ym = ym .* (VerticalRange/2);
ym = ym + (TotalCoverageBottom - min(ym(:,1)));
% figure,
% surf(xm, ym, hm);
%% Interpolation
Interpolation = scatteredInterpolant(reshape(xm,[100*100 1]),reshape(ym,[100*100 1]),reshape(hm,[100*100 1]), 'linear');
% Perform the actual interpolation.
FeaturesCoordinates(:,3) = Interpolation(FeaturesCoordinates(:,1), FeaturesCoordinates(:,2));