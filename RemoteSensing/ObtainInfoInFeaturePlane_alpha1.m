function [WorldPlane_OriginCoordinates,WorldPlane_OriginCoCoordinates,ImagePlane_FocalCoordinates,WorldPlane_LeftMostOriginCoCoordinates,WorldPlane_RightMostCoCoordinates] = ObtainInfoInFeaturePlane_alpha1(FeaturesCoordinates,WorldPlane_Origin,WorldPlane_LeftMost,WorldPlane_RightMost,ImagePlane_Focal)
%{
2017/04/21
ObtainInfoInFeaturePlane_alpha1
1. Obtain information(origion, focal, left most, right most points)
according to the height of features.
2. Fit for CE-2

%}
%% WorldPlane_OriginCoordinates
WorldPlane_OriginCoordinates = zeros(size(FeaturesCoordinates));
WorldPlane_OriginCoordinates(:,1) = ((ImagePlane_Focal(3) - FeaturesCoordinates(:,3))./ImagePlane_Focal(3)).*(WorldPlane_Origin(1) - ImagePlane_Focal(1)) + ImagePlane_Focal(1);
% WorldPlane_OriginCoordinates(:,2) = WorldPlane_Origin(2);
WorldPlane_OriginCoordinates(:,2) = ((ImagePlane_Focal(3) - FeaturesCoordinates(:,3))./ImagePlane_Focal(3)).*(WorldPlane_Origin(2) - ImagePlane_Focal(2)) + ImagePlane_Focal(2);
WorldPlane_OriginCoordinates(:,3) = FeaturesCoordinates(:,3);

%% WorldPlane_LeftMostOriginCoordinates
WorldPlane_LeftMostOriginCoordinates = zeros(size(FeaturesCoordinates));
WorldPlane_LeftMostOriginCoordinates(:,1) = ((ImagePlane_Focal(3) - FeaturesCoordinates(:,3))./ImagePlane_Focal(3)).*(WorldPlane_LeftMost(1) - ImagePlane_Focal(1)) + ImagePlane_Focal(1);
WorldPlane_LeftMostOriginCoordinates(:,2) = ((ImagePlane_Focal(3) - FeaturesCoordinates(:,3))./ImagePlane_Focal(3)).*(WorldPlane_LeftMost(2) - ImagePlane_Focal(2)) + ImagePlane_Focal(2);
WorldPlane_LeftMostOriginCoordinates(:,3) = FeaturesCoordinates(:,3);

%% WorldPlane_RightMostOriginCoordinates
WorldPlane_RightMostOriginCoordinates = zeros(size(FeaturesCoordinates));
WorldPlane_RightMostOriginCoordinates(:,1) = ((ImagePlane_Focal(3) - FeaturesCoordinates(:,3))./ImagePlane_Focal(3)).*(WorldPlane_RightMost(1) - ImagePlane_Focal(1)) + ImagePlane_Focal(1);
WorldPlane_RightMostOriginCoordinates(:,2) = ((ImagePlane_Focal(3) - FeaturesCoordinates(:,3))./ImagePlane_Focal(3)).*(WorldPlane_RightMost(2) - ImagePlane_Focal(2)) + ImagePlane_Focal(2);
WorldPlane_RightMostOriginCoordinates(:,3) = FeaturesCoordinates(:,3);

%% WorldPlane_OriginCoCoordinates
WorldPlane_OriginCoCoordinates = WorldPlane_OriginCoordinates;
WorldPlane_OriginCoCoordinates(:,2) = ((WorldPlane_RightMostOriginCoordinates(:,2)-WorldPlane_OriginCoordinates(:,2))./(WorldPlane_RightMostOriginCoordinates(:,1)-WorldPlane_OriginCoordinates(:,1))).*...
    (WorldPlane_OriginCoordinates(:,1) - FeaturesCoordinates(:,1)) + FeaturesCoordinates(:,2);

%% ImagePlane_FocalCoordinates
ImagePlane_FocalCoordinates = zeros(size(FeaturesCoordinates));
ImagePlane_FocalCoordinates(:,1) = ImagePlane_Focal(1);
% ImagePlane_FocalCoordinates(:,2) = WorldPlane_OriginCoCoordinates(:,2);
ImagePlane_FocalCoordinates(:,2) = ImagePlane_Focal(2) + WorldPlane_OriginCoCoordinates(:,2);
ImagePlane_FocalCoordinates(:,3) = ImagePlane_Focal(3);

%% WorldPlane_RightMostCoCoordinates
WorldPlane_LeftMostOriginCoCoordinates = WorldPlane_LeftMostOriginCoordinates;
% WorldPlane_LeftMostOriginCoCoordinates(:,2) = WorldPlane_LeftMostOriginCoCoordinates(:,2) + WorldPlane_OriginCoCoordinates(:,2) - WorldPlane_Origin(2);
WorldPlane_LeftMostOriginCoCoordinates(:,2) = WorldPlane_OriginCoCoordinates(:,2) + (WorldPlane_LeftMostOriginCoCoordinates(:,2) - WorldPlane_OriginCoordinates(:,2));
%% WorldPlane_RightMostCoCoordinates
WorldPlane_RightMostCoCoordinates = WorldPlane_RightMostOriginCoordinates;
% WorldPlane_RightMostCoCoordinates(:,2) = WorldPlane_RightMostCoCoordinates(:,2) + WorldPlane_OriginCoCoordinates(:,2) - WorldPlane_Origin(2);
WorldPlane_RightMostCoCoordinates(:,2) = WorldPlane_OriginCoCoordinates(:,2) + (WorldPlane_RightMostCoCoordinates(:,2) - WorldPlane_OriginCoordinates(:,2));

% [~,ShowColumn] = min(FeaturesCoordinates(:,3));
% figure,
% plot3([ImagePlane_Focal(1) WorldPlane_Origin(1)],[ImagePlane_Focal(2) WorldPlane_Origin(2)],[ImagePlane_Focal(3) WorldPlane_Origin(3)],'r-');hold on
% plot3([WorldPlane_RightMost(1) WorldPlane_Origin(1)],[WorldPlane_RightMost(2) WorldPlane_Origin(2)],[WorldPlane_RightMost(3) WorldPlane_Origin(3)],'g-');
% plot3([WorldPlane_RightMost(1) ImagePlane_Focal(1)],[WorldPlane_RightMost(2) ImagePlane_Focal(2)],[WorldPlane_RightMost(3) ImagePlane_Focal(3)],'b-');
% 
% plot3([WorldPlane_OriginCoordinates(ShowColumn,1) ImagePlane_Focal(1)],[WorldPlane_OriginCoordinates(ShowColumn,2) ImagePlane_Focal(2)],[WorldPlane_OriginCoordinates(ShowColumn,3) ImagePlane_Focal(3)],'c-');
% plot3([WorldPlane_OriginCoordinates(ShowColumn,1) WorldPlane_RightMostOriginCoordinates(ShowColumn,1)],[WorldPlane_OriginCoordinates(ShowColumn,2) WorldPlane_RightMostOriginCoordinates(ShowColumn,2)],[WorldPlane_OriginCoordinates(ShowColumn,3) WorldPlane_RightMostOriginCoordinates(ShowColumn,3)],'g-');
% plot3([WorldPlane_RightMostOriginCoordinates(ShowColumn,1) ImagePlane_Focal(1)],[WorldPlane_RightMostOriginCoordinates(ShowColumn,2) ImagePlane_Focal(2)],[WorldPlane_RightMostOriginCoordinates(ShowColumn,3) ImagePlane_Focal(3)],'m-');
% 
% 
% plot3([WorldPlane_OriginCoCoordinates(ShowColumn,1) ImagePlane_FocalCoordinates(ShowColumn,1)],[WorldPlane_OriginCoCoordinates(ShowColumn,2) ImagePlane_FocalCoordinates(ShowColumn,2)],[WorldPlane_OriginCoCoordinates(ShowColumn,3) ImagePlane_FocalCoordinates(ShowColumn,3)],'c-');
% plot3([WorldPlane_RightMostCoCoordinates(ShowColumn,1) ImagePlane_FocalCoordinates(ShowColumn,1)],[WorldPlane_RightMostCoCoordinates(ShowColumn,2) ImagePlane_FocalCoordinates(ShowColumn,2)],[WorldPlane_RightMostCoCoordinates(ShowColumn,3) ImagePlane_FocalCoordinates(ShowColumn,3)],'m-');
% plot3([FeaturesCoordinates(ShowColumn,1) WorldPlane_RightMostCoCoordinates(ShowColumn,1)],[FeaturesCoordinates(ShowColumn,2) WorldPlane_RightMostCoCoordinates(ShowColumn,2)],[FeaturesCoordinates(ShowColumn,3) WorldPlane_RightMostCoCoordinates(ShowColumn,3)],'b-');
% 
% plot3([WorldPlane_OriginCoCoordinates(ShowColumn,1) WorldPlane_RightMostCoCoordinates(ShowColumn,1)],[WorldPlane_OriginCoCoordinates(ShowColumn,2) WorldPlane_RightMostCoCoordinates(ShowColumn,2)],[WorldPlane_OriginCoCoordinates(ShowColumn,3) WorldPlane_RightMostCoCoordinates(ShowColumn,3)],'g-');
% x = 1;