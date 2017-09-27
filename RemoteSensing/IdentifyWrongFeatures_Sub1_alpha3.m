function [IfWrong,NewFeaturesCoordinates] = IdentifyWrongFeatures_Sub1_alpha3(FeaturesCoordinates,ImagePlane_FocalCoordinates,Interpolation)
%{
2017/4/15
IdentifyWrongFeatures_Sub1_alpha1
1. 

2017/04/23
IdentifyWrongFeatures_Sub1_alpha2
1. Replace the  

2017/04/23
IdentifyWrongFeatures_Sub1_alpha3
1. Refine the situation when DiffY=0;
%}
WrongBuffer = 10;
IfWrong = false;
NewFeaturesCoordinates = [];

DiffX = ImagePlane_FocalCoordinates(1)- FeaturesCoordinates(1);
DiffY = ImagePlane_FocalCoordinates(2) - FeaturesCoordinates(2);
Diff = sqrt( DiffX^2 + DiffY^2 );
DiffRadius = round(Diff/WrongBuffer);

if DiffRadius == 0,
   return
end

DeltaX = DiffX/DiffRadius;
DeltaY = DiffY/DiffRadius;

RefX = (FeaturesCoordinates(1)+DeltaX*DiffRadius) : -DeltaX : (FeaturesCoordinates(1)+DeltaX); % From far to near
if DeltaY == 0,
    RefY = zeros(1,length(RefX));
else
    RefY = (FeaturesCoordinates(2)+DeltaY*DiffRadius) : -DeltaY : (FeaturesCoordinates(2)+DeltaY);
end
RefDiff = (sqrt((RefX-FeaturesCoordinates(1)).^2 + (RefY-FeaturesCoordinates(2)).^2))';
RefZ = (RefDiff./Diff).*(ImagePlane_FocalCoordinates(3)-FeaturesCoordinates(3)) + FeaturesCoordinates(3);

WorldZ = Interpolation(RefX',RefY');

IfWrongRef = ( (RefZ - WorldZ) > 0 );
WrongPosi = find( IfWrongRef==0,1,'first');
if ~isempty(WrongPosi),
    IfWrong = true;
    NewFeaturesCoordinates = [RefX(WrongPosi) RefY(WrongPosi) WorldZ(WrongPosi)];
%     
%     figure(34),
%     plot3([FeaturesCoordinates(1) ImagePlane_FocalCoordinates(1)],[FeaturesCoordinates(2) ImagePlane_FocalCoordinates(2)],[FeaturesCoordinates(3) ImagePlane_FocalCoordinates(3)],'r');hold on
%     plot3(RefX,RefY,WorldZ,'g*');
%     %plot3(NewFeaturesCoordinates(1),NewFeaturesCoordinates(2),NewFeaturesCoordinates(3),'c*');
%     x = 1;
% else
%     figure(33),
%     plot3([FeaturesCoordinates(1) ImagePlane_FocalCoordinates(1)],[FeaturesCoordinates(2) ImagePlane_FocalCoordinates(2)],[FeaturesCoordinates(3) ImagePlane_FocalCoordinates(3)],'r');hold on
%     plot3(RefX,RefY,WorldZ,'g*');
%     %plot3(NewFeaturesCoordinates(1),NewFeaturesCoordinates(2),NewFeaturesCoordinates(3),'c*');
%     x = 1;
end