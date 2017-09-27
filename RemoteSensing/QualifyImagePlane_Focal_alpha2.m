function ImagePlane_FocalCoordinates = QualifyImagePlane_Focal_alpha2(FeaturesCoordinates,ImagePlane_FocalCoordinates,WorldPlane_LeftMostOriginCoCoordinates,WorldPlane_RightMostCoCoordinates,HighestZ,LR)
%{
2017/04/16
QualifyImagePlane_Focal_alpha1
1. Qualify ImagePlane_Focal: locate in total coverage range and lower than HighestZ


2017/04/21
QualifyImagePlane_Focal_alpha2
1. Use the real ImagePlane_Focal, WorldPlane_Origin, WorldPlane_LeftMost
and WorldPlane_RightMost to constraint the ImagePlane_FocalCoordinates.
2. Add LR: 0=left;1=Right
%}
% HERE
% First, HighestZ, then L or R (Use a parameter to determine)

%% Refine the height of ImagePlane_FocalCoordinates, whose height is larger than HighestZ, to HighestZ.
ZNeedToChanged = (ImagePlane_FocalCoordinates(:,3) > HighestZ);
%ImagePlane_FocalCoordinates = zeros(size(FeaturesCoordinates));
% TestColumn = 158;
% figure,
% plot3([ImagePlane_FocalCoordinates(TestColumn,1) FeaturesCoordinates(TestColumn,1)],[ImagePlane_FocalCoordinates(TestColumn,2) FeaturesCoordinates(TestColumn,2)],[ImagePlane_FocalCoordinates(TestColumn,3) FeaturesCoordinates(TestColumn,3)],'r');hold on
if any(ZNeedToChanged),
    ZNeedToChangedNum = sum(ZNeedToChanged);
    FeaturesCoordinatesNeedToChanged = FeaturesCoordinates(ZNeedToChanged,:);
    ImagePlane_Focal_Changed = zeros(ZNeedToChangedNum,3);
    %% Z
    ImagePlane_Focal_Changed(:,3) = HighestZ;
    ZFactor = (HighestZ-FeaturesCoordinatesNeedToChanged(:,3))./(ImagePlane_FocalCoordinates(:,3)-FeaturesCoordinatesNeedToChanged(:,3));
    %% X
    ImagePlane_Focal_Changed(:,1) = (ImagePlane_FocalCoordinates(:,1)-FeaturesCoordinatesNeedToChanged(:,1)).*ZFactor + FeaturesCoordinatesNeedToChanged(:,1);
    %% Y
    ImagePlane_Focal_Changed(:,2) = (ImagePlane_FocalCoordinates(:,2)-FeaturesCoordinatesNeedToChanged(:,2)).*ZFactor + FeaturesCoordinatesNeedToChanged(:,2);
    ImagePlane_FocalCoordinates(ZNeedToChanged,:) = ImagePlane_Focal_Changed;
end
% plot3([ImagePlane_FocalCoordinates(TestColumn,1) FeaturesCoordinates(TestColumn,1)],[ImagePlane_FocalCoordinates(TestColumn,2) FeaturesCoordinates(TestColumn,2)],[ImagePlane_FocalCoordinates(TestColumn,3) FeaturesCoordinates(TestColumn,3)],'b');

if LR == 0,
    XNeedToChanged = (ImagePlane_FocalCoordinates(:,1) < WorldPlane_LeftMostOriginCoCoordinates(:,1));
    if any(XNeedToChanged),
        %XNeedToChangedNum = sum(XNeedToChanged);
        %% X
        XFactor = (WorldPlane_LeftMostOriginCoCoordinates(XNeedToChanged,1)-FeaturesCoordinates(XNeedToChanged,1))./(ImagePlane_FocalCoordinates(XNeedToChanged,1)-FeaturesCoordinates(XNeedToChanged,1));
        ImagePlane_FocalCoordinates(XNeedToChanged,1) = WorldPlane_LeftMostOriginCoCoordinates(XNeedToChanged,1);
        %% Y
        ImagePlane_FocalCoordinates(XNeedToChanged,2) = (ImagePlane_FocalCoordinates(XNeedToChanged,2)-FeaturesCoordinates(XNeedToChanged,2)).*XFactor + FeaturesCoordinates(XNeedToChanged,2);
        %% Z
        ImagePlane_FocalCoordinates(XNeedToChanged,3) = (ImagePlane_FocalCoordinates(XNeedToChanged,3)-FeaturesCoordinates(XNeedToChanged,3)).*XFactor + FeaturesCoordinates(XNeedToChanged,3);
    end
else
    XNeedToChanged = (ImagePlane_FocalCoordinates(:,1) > WorldPlane_RightMostCoCoordinates(:,1));
    if any(XNeedToChanged),
        %XNeedToChangedNum = sum(XNeedToChanged);
        %% X
        XFactor = (WorldPlane_RightMostCoCoordinates(XNeedToChanged,1)-FeaturesCoordinates(XNeedToChanged,1))./(ImagePlane_FocalCoordinates(XNeedToChanged,1)-FeaturesCoordinates(XNeedToChanged,1));
        ImagePlane_FocalCoordinates(XNeedToChanged,1) = WorldPlane_RightMostCoCoordinates(XNeedToChanged,1);
        %% Y
        ImagePlane_FocalCoordinates(XNeedToChanged,2) = (ImagePlane_FocalCoordinates(XNeedToChanged,2)-FeaturesCoordinates(XNeedToChanged,2)).*XFactor + FeaturesCoordinates(XNeedToChanged,2);
        %% Z
        ImagePlane_FocalCoordinates(XNeedToChanged,3) = (ImagePlane_FocalCoordinates(XNeedToChanged,3)-FeaturesCoordinates(XNeedToChanged,3)).*XFactor + FeaturesCoordinates(XNeedToChanged,3);
    end
end

% plot3([ImagePlane_FocalCoordinates(TestColumn,1) FeaturesCoordinates(TestColumn,1)],[ImagePlane_FocalCoordinates(TestColumn,2) FeaturesCoordinates(TestColumn,2)],[ImagePlane_FocalCoordinates(TestColumn,3) FeaturesCoordinates(TestColumn,3)],'c');
% x = 1;

% if ImagePlane_Focal(1) < WorldPlane_LeftMost(1),
%     ImagePlane_FocalCoordinates = zeros(size(FeaturesCoordinates));
%     ImagePlane_FocalCoordinates(:,1) = WorldPlane_LeftMost(1);
%     %% Y
%     YFactor = (WorldPlane_LeftMost(1)-FeaturesCoordinates(:,1))./(ImagePlane_FocalCoordinatesOld(:,1)-FeaturesCoordinates(:,1));
%     ImagePlane_FocalCoordinates(:,2) = (ImagePlane_FocalCoordinatesOld(:,2)-FeaturesCoordinates(:,2)).*YFactor + FeaturesCoordinates(:,2);
%     %% Z
%     ImagePlane_FocalCoordinates(:,3) = (sqrt((ImagePlane_FocalCoordinates(:,1)-FeaturesCoordinates(:,1)).^2 + (ImagePlane_FocalCoordinates(:,2)-FeaturesCoordinates(:,2)).^2)./...
%         sqrt((ImagePlane_FocalCoordinatesOld(:,1)-FeaturesCoordinates(:,1)).^2 + (ImagePlane_FocalCoordinatesOld(:,2)-FeaturesCoordinates(:,2)).^2)).*(ImagePlane_Focal(3)-FeaturesCoordinates(:,3)) + FeaturesCoordinates(:,3);
% elseif ImagePlane_Focal(1) > WorldPlane_RightMost(1),
%     ImagePlane_FocalCoordinates = zeros(size(FeaturesCoordinates));
%     ImagePlane_FocalCoordinates(:,1) = WorldPlane_RightMost(1);
%     %% Y
%     YFactor = (WorldPlane_LeftMost(1)-FeaturesCoordinates(:,1))./(ImagePlane_FocalCoordinatesOld(:,1)-FeaturesCoordinates(:,1));
%     ImagePlane_FocalCoordinates(:,2) = (ImagePlane_FocalCoordinatesOld(:,2)-FeaturesCoordinates(:,2)).*YFactor + FeaturesCoordinates(:,2);
%     %% Z
%     ImagePlane_FocalCoordinates(:,3) = (sqrt((ImagePlane_FocalCoordinates(:,1)-FeaturesCoordinates(:,1)).^2 + (ImagePlane_FocalCoordinates(:,2)-FeaturesCoordinates(:,2)).^2)./...
%         sqrt((ImagePlane_FocalCoordinatesOld(:,1)-FeaturesCoordinates(:,1)).^2 + (ImagePlane_FocalCoordinatesOld(:,2)-FeaturesCoordinates(:,2)).^2)).*(ImagePlane_Focal(3)-FeaturesCoordinates(:,3)) + FeaturesCoordinates(:,3);
% else
%     ImagePlane_FocalCoordinates = ImagePlane_FocalCoordinatesOld;
% end




% x = 1;
% figure,
% plot(ImagePlane_FocalCoordinatesOld(:,1),ImagePlane_FocalCoordinatesOld(:,2),'r*');hold on
% plot(ImagePlane_Focal_Old(:,1),ImagePlane_Focal_Old(:,2),'g*');
% plot(ImagePlane_Focal_Changed(:,1),ImagePlane_Focal_Changed(:,2),'b*');
% plot(WorldPlane_Origin(1),WorldPlane_Origin(2),'r*');
% EdgeL = ImagePlane_FocalCoordinatesL;
% EdgeR = ImagePlane_FocalCoordinatesR;
% if ImagePlane_FocalCoordinatesL(1) < WorldPlane_LeftMostL,
%     EdgeL(:,1) = WorldPlane_LeftMostL;
%     EdgeL(:,2) = 
%     
% end
% 
% if ImagePlane_FocalCoordinatesR(1) > WorldPlane_RightMostR,
%     EdgeR(:,1) = WorldPlane_RightMostR;
%     
% end

% WorldPlane_OriginCoordinates = ones(size(FeaturesCoordinates));
% WorldPlane_OriginCoordinates(:,1) = WorldPlane_OriginCoordinates(:,1).*WorldPlane_Origin(1);
% WorldPlane_OriginCoordinates(:,2) = ImagePlane_FocalCoordinates(:,2);
% WorldPlane_OriginCoordinates(:,3) = WorldPlane_OriginCoordinates(:,3).*WorldPlane_Origin(3);

