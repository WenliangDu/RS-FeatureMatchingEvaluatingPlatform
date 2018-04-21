function FeaturesImagePlaneCoordinates = Projection_WorldtoImage_alpha5_1(FeaturesCoordinates,WorldPlane_OriginCoordinates,WorldPlane_OriginCoCoordinates,ImagePlane_FocalCoordinates,FocalLength,UnitDistance,SpacialResolution)
%{
2017/04/14
Projection_WorldtoImage_alpha1
1. Project the coordinates of features from world plane to image plane.

2017/04/17
Projection_WorldtoImage_alpha2
1. Use another methods to project the coordinates of features from world plane to image plane.

2017/04/18
Projection_WorldtoImage_alpha3
1. Use more another methods to project the coordinates of features from world plane to image plane.

2017/04/20
Projection_WorldtoImage_alpha4
1. Use WorldPlane_Origin, ImagePlane_Focal according to the height of features.

2017/04/21
Projection_WorldtoImage_alpha5
1. Use WorldPlane_Origin, ImagePlane_Focal according to the height of
features, calculated by other program.

2018/04/21
Projection_WorldtoImage_alpha5_1
1. Add SpacialResolution

%}
FeatureNum = size(FeaturesCoordinates,1);
FeaturesImagePlaneCoordinates = zeros(FeatureNum,2);
%% Calculate FeaturesImagePlaneCoordinates(:,2)
FeaturesImagePlaneCoordinates(:,2) = (WorldPlane_OriginCoCoordinates(:,2) - WorldPlane_OriginCoordinates(2))./SpacialResolution;

%% AlphaFO
Vector_Focal2Feature = FeaturesCoordinates - ImagePlane_FocalCoordinates;
Vector_Focal2Origin = WorldPlane_OriginCoCoordinates - ImagePlane_FocalCoordinates;

Norm_Focal2FeatureSub = Vector_Focal2Feature.^2;
Norm_Focal2Feature = sqrt( Norm_Focal2FeatureSub(:,1) + Norm_Focal2FeatureSub(:,2) + Norm_Focal2FeatureSub(:,3) );

Norm_Focal2OriginSub = Vector_Focal2Origin.^2;
Norm_Focal2Origin = sqrt( Norm_Focal2OriginSub(:,1) + Norm_Focal2OriginSub(:,2) + Norm_Focal2OriginSub(:,3) );

% AlphaFO:angle of vector Focal2Feature and vector Focal2Origin
AlphaFOSub1Sub = Vector_Focal2Feature.*Vector_Focal2Origin;
AlphaFOSub1 = AlphaFOSub1Sub(:,1) + AlphaFOSub1Sub(:,2) + AlphaFOSub1Sub(:,3);
AlphaFOSub2 = Norm_Focal2Feature .* Norm_Focal2Origin;
AlphaFO = acosd(AlphaFOSub1./AlphaFOSub2);

%% Calculate FeaturesImagePlaneCoordinates(:,1)
FeaturesImagePlaneSignSub = FeaturesCoordinates(:,1) - WorldPlane_OriginCoCoordinates(:,1);
FeaturesImagePlaneSign = (-1)*(FeaturesImagePlaneSignSub./(abs(FeaturesImagePlaneSignSub)));

FeaturesImagePlaneCoordinatesXsub1 = tand(AlphaFO).*FocalLength;
FeaturesImagePlaneCoordinates(:,1) = (FeaturesImagePlaneCoordinatesXsub1 .* FeaturesImagePlaneSign)./UnitDistance;

NotANumber = (FeaturesImagePlaneSignSub == 0);
if any(NotANumber),
    FeaturesImagePlaneCoordinates(NotANumber,1) = 0;
end