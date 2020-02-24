

    %% Exercise 2 report, title "face pose estimation", Author name : ...,
    %% Part I.  Synthesis of a sequence of images
    clear; close all; clc
    %% 1/ Load Data (Vertices, Faces, Texture), Display and rotate
    load('model_3D_02.mat'); % faces (Nfx3); vertices(Nx3); texture(Nx3);
    % change z direction
    vertices(:,3)= -vertices(:,3);
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
    poscamZ=-20;
    % axis_rot - this variable decide the axis of rotation 1 - X axis, 2 - Y
    % axis and 3 - Z axis
    axis_rot = 2;
    phi=0:10:90;% rotation angles
    for c=1:size(phi,2)
        RY=XYZrotation(phi(c),axis_rot);
        verticesR=(RY*vertices')';
        display_face_fac_vert_tex0(faces, verticesR,texture, [Nx Ny],poscamZ);
        % to keep the same field of view  given by the first display
        %     if b==0, ax=gca;fov=ax.CameraViewAngle;b=1;
        camva(fov);  % Set the camera field of view (see help Camera Graphics  Terminology)
        % to impose a field of view  given by the pixel size and the image size
        % camva(fov);  % Set the camera field of view
        pause(0.3)
        % Grab the rendered frame
        F = getframe(gcf);
        I(c).image=F.cdata;
        % save of the image
        imwrite(I(c).image,sprintf('model_%03d.png',phi(c)))
    end
    %% 3. Calibration of the camera
    % Here we know the intrinsic parametrs 
    K = [ -focal * 1/pix, 0 , Nx/2, 0;
          0, -focal * 1/pix, Ny/2, 0;
          0, 0, 1, 0 ];
      
    % for image model_000.png
    % Moving my camera from -20 to -10 to get a translation of 10 along Z -
    % axis and a identity rotation matrix
    R = [1,0,0; 0,1,0; 0,0,1];
    T = [0,0,-poscamZ];
    Proj = [ R, T'; 0,0,0,1];
    % we are taking the vertex 3897 
    P = [vertices(3897,1),vertices(3897,2),vertices(3897,3),1];
    P_proj = K * Proj * P';
    u1 = (P_proj(1)/P_proj(3));
    v1 = (P_proj(2)/P_proj(3));
    img1 = imread('model_000.png');
    figure;
    imshow(img1);
    hold on;
    axis on;
    plot(u1,v1,'+','Color','r');
    %for image model_030
    % Moving my camera from -20 to -10 to get a translation of 10 along Z -
    % axis and a rotation of 30 degre around Y axis
    axis_rot = 2;
    R = XYZrotation( 30 ,axis_rot);
    T = [0,0,-poscamZ];
    Proj = [ R, T'; 0,0,0,1];
    % we are taking the vertex 3897 
    P = [vertices(3897,1),vertices(3897,2),vertices(3897,3),1];
    P_proj = K * Proj * P';
    u2 = (P_proj(1)/P_proj(3));
    v2 = (P_proj(2)/P_proj(3));
    img2 = imread('model_030.png');
    figure;
    imshow(img2);
    hold on;
    axis on;
    plot(u2,v2,'+','Color','r');
    % In both image we got the vertex vertex 3897  at same location.
    %%
    %% Part 2
    %%
