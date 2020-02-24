%% Exercise 2 report, title "face pose estimation", Author name : ...,


%% Part I.  Synthesis of a sequence of images
clear; close all; clc

%% 1/ Load Data (Vertices, Faces, Texture), Display and rotate
load('model_3D_01.mat'); % faces (Nfx3); vertices(Nx3); texture(Nx3);
% change z direction
vertices(:,3)=-vertices(:,3);
% scale so that the face is in a bounding box [-1 1,-1 1,-1 1]
vertices=vertices/max(vertices(:));

% Size of the image
Nx=400;Ny=Nx;
% size of the pixel pitch and focal lenght
pix=20e-3; % in mm
focal=50; % in mm
% field of view computation
fov=2*atand(Ny*pix/2/focal)% Field of view of the camera in degrees

%% camera location on the optical axis (OZ)
poscamZ=-20

phi=0:10:90;% rotation angles
for c=1:1%size(phi,2)
    RY=XYZrotation(phi(c),1);
    verticesR=(RY*vertices')';
    display_face_fac_vert_tex0(faces, verticesR,texture, [Nx Ny],poscamZ);
    % to keep the same field of view  given by the first display
    %     if b==0, ax=gca;fov=ax.CameraViewAngle;b=1;
    camva(fov);  % Set the camera field of view (see help Camera Graphics Terminology)
    % to impose a field of view  given by the pixel size and the image size
    % camva(fov);  % Set the camera field of view
    pause(0.3)
    % Grab the rendered frame
    F = getframe(gcf);
    I(c).image=F.cdata;
    % save of the image
    imwrite(I(c).image,sprintf('model_%03d.png',phi(c)))
end

