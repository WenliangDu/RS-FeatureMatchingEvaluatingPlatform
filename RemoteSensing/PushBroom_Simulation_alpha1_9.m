function [ImagePlane_Origin,ImagePlane_Focal,WorldPlane_Origin,WorldPlane_LeftMost,...
    WorldPlane_RightMost,WorldPlane_LeftMostTop,WorldPlane_LeftMostBottom,WorldPlane_RightTop,...
    WorldPlane_RightBottom,FocalLength,UnitDistance,ImagePlane_LeftMost,ImagePlane_RightMost,SpacialResolution] = PushBroom_Simulation_alpha1_9(SlewAngle,...
    EmissionAngle,Target,CameraDetail,Offset)
%%
%{
2017/04/06
PushBroom_Simulation_alpha1

SlewAngle=+ => turn right
SlewAngle=- => turn left

2017/04/12
PushBroom_Simulation_alpha1_4
1. Refine the camera distance of LROC
2017/04/15
1. Add offset in y direction.
2017/04/16
2. Removed(Add transmitting ImagePlane_Focal(1:2) by emission angle)

2017/04/17
PushBroom_Simulation_alpha1_5
1. Output add ImagePlane_LeftMost and ImagePlane_RightMost
2. Add +ImagePlane_RightMost(1:2) and + ImagePlane_LeftMost(1:2) to calculate WorldPlane_LeftMost, WorldPlane_RightMost
3. Remove + ImagePlane_Focal(3)

2017/04/19
PushBroom_Simulation_alpha1_5
1. Use Rotation3D_alpha2 to do Slew Rotation and  Emission Rotation

2017/04/22
PushBroom_Simulation_alpha1_7
1. Remove output: ImagePlane_LeftMost,ImagePlane_RightMost; Useless comments.

2017/06/23
PushBroom_Simulation_alpha1_7
1. Add %% Set to ImagePlane_Origin zero

2017/07/06
PushBroom_Simulation_alpha1_8
1. Calculate UnitDistance with FOV
2. Nadir distance equal to camera distance

2018/04/21
PushBroom_Simulation_alpha1_9
1. Output SpacialResolution
%}
%%
%SpacialResolution = CameraDetail(1,Target);
FOV = CameraDetail(1,Target);
CameraDistance = CameraDetail(2,Target);
LinePixels = CameraDetail(3,Target);
MaximumLines = CameraDetail(4,Target);
FocalLength = CameraDetail(5,Target);

%% Image plane initialization
%UnitDistance = (FocalLength/CameraDistance)*((LinePixels*SpacialResolution)/LinePixels);%LinePixels*SpacialResolution=swath
UnitDistance = ((FocalLength*tand(FOV/2))*2)/LinePixels;%LinePixels*SpacialResolution=swath
SpacialResolution = ((CameraDistance*tand(FOV/2))*2)/LinePixels;

ImagePlane_Focal = [0 0 -FocalLength];
ImagePlane_RightMost = [(LinePixels/2)*UnitDistance 0 0];
ImagePlane_LeftMost = [-(LinePixels/2)*UnitDistance 0 0];
ImagePlane_Origin = [0 0 0];

%% SlewRotation
ImagePlane_RightMost = Rotation3D_alpha2(ImagePlane_RightMost,SlewAngle,[0 -1 0]);
ImagePlane_LeftMost = Rotation3D_alpha2(ImagePlane_LeftMost,SlewAngle,[0 -1 0]);
ImagePlane_Focal = Rotation3D_alpha2(ImagePlane_Focal,SlewAngle,[0 -1 0]);

%% EmissionRotation
ImagePlane_RightMost = Rotation3D_alpha2(ImagePlane_RightMost,EmissionAngle,ImagePlane_Focal);
ImagePlane_LeftMost = Rotation3D_alpha2(ImagePlane_LeftMost,EmissionAngle,ImagePlane_Focal);

%% To real Z
% ImagePlane_Origin(3) = CameraDistance+FocalLength;
% ImagePlane_RightMost(3) = ImagePlane_RightMost(3) + CameraDistance+FocalLength;
% ImagePlane_LeftMost(3) = ImagePlane_LeftMost(3) + CameraDistance+FocalLength;
% ImagePlane_Focal(3) = ImagePlane_Focal(3) + CameraDistance+FocalLength;

% Nadir distance equal to camera distance
VarticalDiff = CameraDistance - ImagePlane_Focal(3);
ImagePlane_Focal(3) = ImagePlane_Focal(3) + VarticalDiff;
ImagePlane_Origin(3) = ImagePlane_Origin(3) + VarticalDiff;
ImagePlane_RightMost(3) = ImagePlane_RightMost(3) + VarticalDiff;
ImagePlane_LeftMost(3) = ImagePlane_LeftMost(3) + VarticalDiff;

%% Project to world plane
WorldPlane_LeftMost = (ImagePlane_Focal(1:2)-ImagePlane_RightMost(1:2)) * (ImagePlane_RightMost(3)/(ImagePlane_RightMost(3)-ImagePlane_Focal(3))) + ImagePlane_RightMost(1:2); %+ImagePlane_RightMost(1:2)?
WorldPlane_RightMost = (ImagePlane_Focal(1:2)-ImagePlane_LeftMost(1:2)) * (ImagePlane_LeftMost(3)/(ImagePlane_LeftMost(3)-ImagePlane_Focal(3))) + ImagePlane_LeftMost(1:2); %+ImagePlane_LeftMost(1:2)?
WorldPlane_LeftMost(3) = 0;
WorldPlane_RightMost(3) = 0;

%%
WorldPlane_Origin = (ImagePlane_Focal(1:2)-ImagePlane_Origin(1:2)) * (ImagePlane_Origin(3)/(ImagePlane_Origin(3)-ImagePlane_Focal(3))) + ImagePlane_Origin(1:2);
WorldPlane_Origin(3) = 0;
%%
% WorldPlane_Origin = zeros(1,3);
% WorldPlane_Origin(1) = tand(SlewAngle)* (CameraDistance+FocalLength);
%% Set to WorldPlane_Origin zero
% OffsetToZero = WorldPlane_Origin(1);
% WorldPlane_LeftMost(1) = WorldPlane_LeftMost(1) - OffsetToZero;
% WorldPlane_RightMost(1) = WorldPlane_RightMost(1) - OffsetToZero;
% ImagePlane_Focal(1) = ImagePlane_Focal(1) - OffsetToZero;
% ImagePlane_Origin(1) = ImagePlane_Origin(1) - OffsetToZero;
% WorldPlane_Origin(1) = WorldPlane_Origin(1) - OffsetToZero;

OffsetToZero = WorldPlane_Origin(1:2);
WorldPlane_LeftMost(1:2) = WorldPlane_LeftMost(1:2) - OffsetToZero;
WorldPlane_RightMost(1:2) = WorldPlane_RightMost(1:2) - OffsetToZero;
ImagePlane_Focal(1:2) = ImagePlane_Focal(1:2) - OffsetToZero;
ImagePlane_Origin(1:2) = ImagePlane_Origin(1:2) - OffsetToZero;
WorldPlane_Origin(1:2) = WorldPlane_Origin(1:2) - OffsetToZero;
%% Set to ImagePlane_Origin zero 20170623
% ImagePlane_LeftMost(1) = ImagePlane_LeftMost(1) - OffsetToZero;
% ImagePlane_RightMost(1) = ImagePlane_RightMost(1) - OffsetToZero;

ImagePlane_LeftMost(1:2) = ImagePlane_LeftMost(1:2) - OffsetToZero;
ImagePlane_RightMost(1:2) = ImagePlane_RightMost(1:2) - OffsetToZero;
%% WorldPlane_LeftMostTop, WorldPlane_LeftMostBottom, WorldPlane_RightTop, WorldPlane_RightBottom
WorldPlane_LeftMostTop = WorldPlane_LeftMost;
WorldPlane_LeftMostBottom = WorldPlane_LeftMost;
WorldPlane_RightTop = WorldPlane_RightMost;
WorldPlane_RightBottom = WorldPlane_RightMost;

HalfLines = (floor((MaximumLines-1)/2)*SpacialResolution);
WorldPlane_LeftMostTop(2) = WorldPlane_LeftMostTop(2) + HalfLines + SpacialResolution;
WorldPlane_LeftMostBottom(2) = WorldPlane_LeftMostBottom(2) - HalfLines;
WorldPlane_RightTop(2) = WorldPlane_RightTop(2) + HalfLines + SpacialResolution;
WorldPlane_RightBottom(2) = WorldPlane_RightBottom(2) - HalfLines;

%% Offset
if nargin > 4,
    
    %% X direction
    ImagePlane_Origin(1) = ImagePlane_Origin(1) + Offset(1);
    ImagePlane_Focal(1) = ImagePlane_Focal(1) + Offset(1);
    WorldPlane_Origin(1) = WorldPlane_Origin(1) + Offset(1);
    
    WorldPlane_LeftMostTop(1) = WorldPlane_LeftMostTop(1) + Offset(1);
    WorldPlane_LeftMostBottom(1) = WorldPlane_LeftMostBottom(1) + Offset(1);
    WorldPlane_RightTop(1) = WorldPlane_RightTop(1) + Offset(1);
    WorldPlane_RightBottom(1) = WorldPlane_RightBottom(1) + Offset(1);
    WorldPlane_LeftMost(1) = WorldPlane_LeftMost(1) + Offset(1);
    WorldPlane_RightMost(1) = WorldPlane_RightMost(1) + Offset(1);
    
    ImagePlane_LeftMost(1) = ImagePlane_LeftMost(1) + Offset(1); % 20170623
    ImagePlane_RightMost(1) = ImagePlane_RightMost(1) + Offset(1); % 20170623
    %% Y direction
    ImagePlane_Origin(2) = ImagePlane_Origin(2) + Offset(2);
    ImagePlane_Focal(2) = ImagePlane_Focal(2) + Offset(2);
    WorldPlane_Origin(2) = WorldPlane_Origin(2) + Offset(2);
    
    WorldPlane_LeftMostTop(2) = WorldPlane_LeftMostTop(2) + Offset(2);
    WorldPlane_LeftMostBottom(2) = WorldPlane_LeftMostBottom(2) + Offset(2);
    WorldPlane_RightTop(2) = WorldPlane_RightTop(2) + Offset(2);
    WorldPlane_RightBottom(2) = WorldPlane_RightBottom(2) + Offset(2);
    WorldPlane_LeftMost(2) = WorldPlane_LeftMost(2) + Offset(2);
    WorldPlane_RightMost(2) = WorldPlane_RightMost(2) + Offset(2);
    
    ImagePlane_LeftMost(2) = ImagePlane_LeftMost(2) + Offset(2); % 20170623
    ImagePlane_RightMost(2) = ImagePlane_RightMost(2) + Offset(2); % 20170623
end
