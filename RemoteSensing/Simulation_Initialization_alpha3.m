function [CameraDetail,SlewAngleL,SlewAngleR,EmissionAngleL,EmissionAngleR,Offset] = Simulation_Initialization_alpha3(DeltaSlewAngle,DeltaEmissionAngle,SlewAngleRange,EmissionAngleRange,OffsetRadius)
%{
2017/04/22
Simulation_Initialization_alpha1
1. Initialize CameraDetail, SlewAngle, EmissionAngle and Offset

2017/04/26
Simulation_Initialization_alpha2
1. Set SlewAngleRange,EmissionAngleRange,OffsetRadius as input.

2017/06/23
Simulation_Initialization_alpha2
1. add CameraDetail(:,3) for drawing

2017/07/07
Simulation_Initialization_alpha3
1. initialize FOV instead of SpacialResolution
%}
CameraDetail = zeros(5,2); % 1: LROC; 2: HiRISE
%CameraDetail(1,1) = 1; % SpacialResolution
CameraDetail(1,1) = 5.7; % FOV (two NACs FOV=5.7, one NAC=2.85)
CameraDetail(2,1) = 100000; % CameraDistance %100000
CameraDetail(3,1) = 10000; % LinePixels
CameraDetail(4,1) = 52224; % MaximumLines
CameraDetail(5,1) = 0.7; % FocalLength

%CameraDetail(1,2) = 0.25; % SpacialResolution
CameraDetail(1,2) = 1.14; % FOV
CameraDetail(2,2) = 300000; % CameraDistance
CameraDetail(3,2) = 20048; % LinePixels
CameraDetail(4,2) = 40000; % MaximumLines
CameraDetail(5,2) = 12; % FocalLength

%% For drawing
%CameraDetail(1,3) = 2; % SpacialResolution
CameraDetail(1,3) = 10; % SpacialResolution
CameraDetail(2,3) = 15000; % CameraDistance
CameraDetail(3,3) = 10000; % LinePixels
CameraDetail(4,3) = 10000; % MaximumLines
CameraDetail(5,3) = 10000; % FocalLength
%% Random SlewAngleL, EmissionAngle and Offset
% SlewAngleRange = 30;%0~30; make SlewAngle from -30 to 30
%DeltaSlewAngle = 30;
SlewAngleMid = (SlewAngleRange-DeltaSlewAngle/2) - ((SlewAngleRange*2)-DeltaSlewAngle)*rand();
SlewAngleL = SlewAngleMid + DeltaSlewAngle/2;
SlewAngleR = SlewAngleMid - DeltaSlewAngle/2;

% SlewAngleL = 10;
% SlewAngleR = 0;

% EmissionAngleRange = 30;
%DeltaEmissionAngle = 0;
EmissionAngleMid = (EmissionAngleRange-DeltaEmissionAngle/2) - ((EmissionAngleRange*2)-DeltaEmissionAngle)*rand();
EmissionAngleL = EmissionAngleMid + DeltaEmissionAngle/2;
EmissionAngleR = EmissionAngleMid - DeltaEmissionAngle/2;
% EmissionAngleL = 60*rand()-30;
% EmissionAngleR = 60*rand()-30;
% EmissionAngleL = 0;
% EmissionAngleR = 0;

% OffsetRadius = 0;
OffsetTheta = 180*rand()-90;
Offset(1) = OffsetRadius * cosd(OffsetTheta);
Offset(2) = OffsetRadius * sind(OffsetTheta);