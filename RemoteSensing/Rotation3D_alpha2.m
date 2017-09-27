function RotatedLocations = Rotation3D_alpha2(ToBeRotatedLocations,RotationAngle,RotationAxis)
%{
2017/04/19
Rotation3D_alpha2
1. Rotate matrix in 3D
[1] http://inside.mines.edu/fs_home/gmurray/ArbitraryAxisRotation/
%}
NormRotationAxis = norm(RotationAxis);
if NormRotationAxis ~= 1,
    RotationAxis = RotationAxis./NormRotationAxis;
end
RotationMatrix = zeros(4,4);
RotationMatrix(1,1) = RotationAxis(1)^2 + (1-RotationAxis(1)^2)*cosd(RotationAngle);
RotationMatrix(1,2) = RotationAxis(1)*RotationAxis(2)*(1-cosd(RotationAngle)) - RotationAxis(3)*sind(RotationAngle);
RotationMatrix(1,3) = RotationAxis(1)*RotationAxis(3)*(1-cosd(RotationAngle)) + RotationAxis(2)*sind(RotationAngle);
RotationMatrix(1,4) = 0;

RotationMatrix(2,1) = RotationAxis(2)*RotationAxis(1)*(1-cosd(RotationAngle)) + RotationAxis(3)*sind(RotationAngle);
RotationMatrix(2,2) = RotationAxis(2)^2 + (1-RotationAxis(2)^2)*cosd(RotationAngle);
RotationMatrix(2,3) = RotationAxis(2)*RotationAxis(3)*(1-cosd(RotationAngle)) - RotationAxis(1)*sind(RotationAngle);
RotationMatrix(2,4) = 0;

RotationMatrix(3,1) = RotationAxis(3)*RotationAxis(1)*(1-cosd(RotationAngle)) - RotationAxis(2)*sind(RotationAngle);
RotationMatrix(3,2) = RotationAxis(3)*RotationAxis(2)*(1-cosd(RotationAngle)) + RotationAxis(1)*sind(RotationAngle);
RotationMatrix(3,3) = RotationAxis(3)^2 + (1 - RotationAxis(3)^2)*cosd(RotationAngle);
RotationMatrix(3,4) = 0;

RotationMatrix(4,1) = 0;
RotationMatrix(4,2) = 0;
RotationMatrix(4,3) = 0;
RotationMatrix(4,4) = 1;

Num = size(ToBeRotatedLocations,1);
ExtendedOne = ones(Num,1);
ToBeRotatedLocationsExtended  = [ToBeRotatedLocations ExtendedOne];

RotatedLocationsExtended =  RotationMatrix * ToBeRotatedLocationsExtended';
RotatedLocations = ( RotatedLocationsExtended(1:3,:) )';
