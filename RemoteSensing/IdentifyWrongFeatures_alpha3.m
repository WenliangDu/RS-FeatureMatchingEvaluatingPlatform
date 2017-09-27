function [WrongFeaturesRecord,FeaturesCoordinates,WorldPlane_OriginCoordinatesL,WorldPlane_OriginCoCoordinatesL,ImagePlane_FocalCoordinatesL,...
    WorldPlane_OriginCoordinatesR,WorldPlane_OriginCoCoordinatesR,ImagePlane_FocalCoordinatesR] = IdentifyWrongFeatures_alpha3(FeaturesCoordinates,ImagePlane_FocalCoordinatesL,WorldPlane_LeftMostOriginCoCoordinatesL,WorldPlane_RightMostCoCoordinatesL,ImagePlane_FocalCoordinatesR,WorldPlane_LeftMostOriginCoCoordinatesR,WorldPlane_RightMostCoCoordinatesR,Interpolation,HighestZ,...
    WorldPlane_OriginL,WorldPlane_LeftMostL,WorldPlane_RightMostL,ImagePlane_FocalL,WorldPlane_OriginR,WorldPlane_LeftMostR,WorldPlane_RightMostR,ImagePlane_FocalR,...
    WorldPlane_OriginCoordinatesL,WorldPlane_OriginCoCoordinatesL,WorldPlane_OriginCoordinatesR,WorldPlane_OriginCoCoordinatesR)
%{
2017/04/15
IdentifyWrongFeatures_alpha1
1. Identify the features cannot be captured by camera L or R.

2017/04/21
IdentifyWrongFeatures_alpha2
1. QualifyImagePlane_Focal_alpha1 => alpha2: Use the real ImagePlane_Focal, WorldPlane_Origin, WorldPlane_LeftMost
and WorldPlane_RightMost to constraint the ImagePlane_FocalCoordinates.

2017/04/22
IdentifyWrongFeatures_alpha2
1. IdentifyWrongFeatures_Sub1_alpha1 => alpha2: Use new
features, WorldPlane_OriginCoordinatesL/R, WorldPlane_OriginCoCoordinatesL/R, ImagePlane_FocalCoordinatesL/R


%}
    
FeatureNum = size(FeaturesCoordinates,1);
WrongFeaturesRecord = false(FeatureNum,1);
%% Calculate ImagePlane_FocalCoordinatesL/R
ImagePlane_FocalCoordinatesL2 = QualifyImagePlane_Focal_alpha2(FeaturesCoordinates,ImagePlane_FocalCoordinatesL,WorldPlane_LeftMostOriginCoCoordinatesL,WorldPlane_RightMostCoCoordinatesL,HighestZ,0);
ImagePlane_FocalCoordinatesR2 = QualifyImagePlane_Focal_alpha2(FeaturesCoordinates,ImagePlane_FocalCoordinatesR,WorldPlane_LeftMostOriginCoCoordinatesR,WorldPlane_RightMostCoCoordinatesR,HighestZ,1);
%%
NewFeaturesCoordinatesTemp = zeros(1,3);
NewNum = 1;
for i = 1:FeatureNum,
    [IfWrong,NewFeaturesCoordinatesTempTemp] = IdentifyWrongFeatures_Sub1_alpha3(FeaturesCoordinates(i,:),ImagePlane_FocalCoordinatesL2(i,:),Interpolation);
    if ~IfWrong,
        [IfWrong,NewFeaturesCoordinatesTempTemp] = IdentifyWrongFeatures_Sub1_alpha3(FeaturesCoordinates(i,:),ImagePlane_FocalCoordinatesR2(i,:),Interpolation);
    end
    if IfWrong,
        NewFeaturesCoordinatesTemp(NewNum,:) = NewFeaturesCoordinatesTempTemp;
        NewNum = NewNum + 1;
    end
    WrongFeaturesRecord(i) = IfWrong;
end

%% Update FeaturesCoordinates
if any(WrongFeaturesRecord),
    WrongFeaturesNumRecord = find(WrongFeaturesRecord);
    RightFeaturesRecordNew = false(NewNum-1,1);
    %% Update ImagePlane_FocalCoordinatesLN/RN, WorldPlane_LeftMostOriginCoCoordinatesLN/RN, WorldPlane_RightMostCoCoordinatesLN/RN
    [WorldPlane_OriginCoordinatesLN,WorldPlane_OriginCoCoordinatesLN,ImagePlane_FocalCoordinatesLN,WorldPlane_LeftMostOriginCoCoordinatesLN,WorldPlane_RightMostCoCoordinatesLN] = ObtainInfoInFeaturePlane_alpha1(NewFeaturesCoordinatesTemp,WorldPlane_OriginL,WorldPlane_LeftMostL,WorldPlane_RightMostL,ImagePlane_FocalL);
    [WorldPlane_OriginCoordinatesRN,WorldPlane_OriginCoCoordinatesRN,ImagePlane_FocalCoordinatesRN,WorldPlane_LeftMostOriginCoCoordinatesRN,WorldPlane_RightMostCoCoordinatesRN] = ObtainInfoInFeaturePlane_alpha1(NewFeaturesCoordinatesTemp,WorldPlane_OriginR,WorldPlane_LeftMostR,WorldPlane_RightMostR,ImagePlane_FocalR);
    %% Calculate ImagePlane_FocalCoordinatesLN/RN
    ImagePlane_FocalCoordinatesLNN = QualifyImagePlane_Focal_alpha2(NewFeaturesCoordinatesTemp,ImagePlane_FocalCoordinatesLN,WorldPlane_LeftMostOriginCoCoordinatesLN,WorldPlane_RightMostCoCoordinatesLN,HighestZ,0);
    ImagePlane_FocalCoordinatesRNN = QualifyImagePlane_Focal_alpha2(NewFeaturesCoordinatesTemp,ImagePlane_FocalCoordinatesRN,WorldPlane_LeftMostOriginCoCoordinatesRN,WorldPlane_RightMostCoCoordinatesRN,HighestZ,1);
    
    for i = 1:NewNum-1,
        [IfWrong,~] = IdentifyWrongFeatures_Sub1_alpha3(NewFeaturesCoordinatesTemp(i,:),ImagePlane_FocalCoordinatesLNN(i,:),Interpolation);
        if ~IfWrong,
            [IfWrong,~] = IdentifyWrongFeatures_Sub1_alpha3(NewFeaturesCoordinatesTemp(i,:),ImagePlane_FocalCoordinatesRNN(i,:),Interpolation);
        end
        RightFeaturesRecordNew(i) = ~IfWrong;
    end
    
    %% Update FeaturesCoordinates,WorldPlane_OriginCoordinatesL/R,WorldPlane_OriginCoCoordinatesL/R,ImagePlane_FocalCoordinatesL/R
    UpdateNum = WrongFeaturesNumRecord(RightFeaturesRecordNew);
    if ~isempty(UpdateNum),
        WrongFeaturesRecord(UpdateNum) = false;
        FeaturesCoordinates(UpdateNum,:) = NewFeaturesCoordinatesTemp(RightFeaturesRecordNew,:);
        
        WorldPlane_OriginCoordinatesL(UpdateNum,:) = WorldPlane_OriginCoordinatesLN(RightFeaturesRecordNew,:);
        WorldPlane_OriginCoCoordinatesL(UpdateNum,:) = WorldPlane_OriginCoCoordinatesLN(RightFeaturesRecordNew,:);
        ImagePlane_FocalCoordinatesL(UpdateNum,:) = ImagePlane_FocalCoordinatesLN(RightFeaturesRecordNew,:);
        WorldPlane_OriginCoordinatesR(UpdateNum,:) = WorldPlane_OriginCoordinatesRN(RightFeaturesRecordNew,:);
        WorldPlane_OriginCoCoordinatesR(UpdateNum,:) = WorldPlane_OriginCoCoordinatesRN(RightFeaturesRecordNew,:);
        ImagePlane_FocalCoordinatesR(UpdateNum,:) = ImagePlane_FocalCoordinatesRN(RightFeaturesRecordNew,:);
        
    end
end



