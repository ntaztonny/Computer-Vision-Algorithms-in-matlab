function [R]=XYZrotation(angle,d);
% angle is n degree
% d=1 rotation axis is X, d=2 ...Y, d=3 ...Z
switch d
    case 1
        R=[1, 0,0;
            0, cosd(angle), -sind(angle);
            0,sind(angle),cosd(angle)];
    case 2
        R=[cosd(angle), 0, sind(angle);
            0,1, 0 ;
            -sind(angle),0,cosd(angle)];
    case 3
        R=[cosd(angle), -sind(angle), 0;
            sind(angle),cosd(angle),0;
            0,0,1];
end




