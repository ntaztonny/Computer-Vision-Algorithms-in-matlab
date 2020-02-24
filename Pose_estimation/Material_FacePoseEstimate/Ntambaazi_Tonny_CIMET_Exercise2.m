%% Exercise 2 report, title "face pose estimation", Ntambaazi Tonny_CIMET : ...,


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
fov=2*atand(Ny*pix/2/focal);% Field of view of the camera in degrees

%% camera location on the optical axis (OZ)
poscamZ = -20;

phi=0:10:90;% rotation angles
for c=1:size(phi,2)
    %1_3
    %setting the rotation to the Y 90%
    RY=XYZrotation(phi(c),2);
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

%% 1_ 2
 dbtype('display_face_fac_vert_tex0.m')
 % The display_face_fac_vert_tex0.m function  takes parameters of the
 % faces, vertices, texture, fpos, poscamZ: 
 %1:creates a render using the opengl API, and also creates the window displace plane: 2: using the mesh_h = trimesh(); it generates the facial mesh, using the phong lighting model:
 %Using the set matlab function, with parameters of the aspect ratio,
 %position, perspective projection, camera position, 
 % Finally, the color, and material and light color... are all set by this
 % function
 %%
%  Calutating the matrices
% Rotation of the first image at 0 rotation:
 Rot_1 = XYZrotation(0,2);
 % Rotation of the third image at 20 degree rotation
 Rot_2 = XYZrotation(20,2);
 % translation matrix
 trans_1 = [0,0, -poscamZ];
 %combining the translation and rotation matrices forming the rigid body
 %transform
 Rot_trans1 = [Rot_1, trans_1'; 0,0,0,1];
 Rot_trans2 = [Rot_2, trans_1'; 0,0,0,1];
 %K matrix
 K_mat = [-1/pix, 0, Nx/2; 0, -1/pix, Nx/2; 0, 0, 1];
 %Projection matrix
 Pro_mat = [focal, 0, 0, 0; 0, focal, 0, 0; 0, 0, 1, 0;];
 %
 Calib_1 = K_mat * Pro_mat * Rot_trans1;
 Calib_2 = K_mat * Pro_mat * Rot_trans2;
 point = [vertices(3897,:), 1];
 
 point_1 = Calib_1 * point';
 point_2 = Calib_2 * point';
 % plotting the point
 
 point_1 = point_1 / point_1(3);
 point_2 = point_2 / point_2(3);
 I_1 = imread('model_000.png');
 I_2 = imread('model_020.png');
 
 %Projection of the points using the calibration matrix on the 2 images
 figure; 
 
 subplot (1,2,1), 
 imshow(I_1); 
 title('Point Projection on the 2 images');
 hold on;
 plot(point_1(1,1),point_1(2,1),'g.');
 subplot (1,2,2), imshow(I_2); 
 hold on; 
 plot(point_2(1,1),point_2(2,1),'g.');
 
 
 %% Part 2_1 Feature points detection and matching

 %Starting the VI_feat_toolbox
 run('vlfeat/toolbox/vl_setup')

 % converting the images to gray from rgb
 I_gray1 = single(rgb2gray(I_1)); 
 I_gray2 = single(rgb2gray(I_2));%single typle is recommended in the documentation
 
 % Compute the shift keypoints
 
 [F1, D1] = vl_sift(I_gray1);
 [F2, D2] = vl_sift(I_gray2);
 
 
 %  implement the basic matching algorithm. 
%  [matches, scores] = vl_ubcmatch(D1, D2) ;

% Here, a threshold of 1.6 is used to minimize the number of false matches: by comparing the eucledian distance between the match points identified: 
%if it is greater than or equal to 1.6 the point is used otherwise, it is omitted 

[matches, scores] = vl_ubcmatch(D1, D2, 1.6) ;
 % Plot the points onto the images
 %image 1
 figure;
 
 subplot(1,2,1);
 imshow(uint8(I_1));
 title('Points matched in 2 images');
 hold on;
 plot(F1(1,matches(1,:)),F1(2,matches(1,:)),'g.');
 %Image 2
 subplot(1,2,2);
 imshow(uint8(I_2));
 hold on;
 plot(F2(1,matches(2,:)),F2(2,matches(2,:)),'g.');
 
 % Comment
 % The displays show that the not all points are perfectly matched. A clear
 % example are the points around the neck. The left picture has 4 points
 % but te right has 3points, however, when the rdges are sharp and distinct
 % forexample around the eyes, there will be good matching. 4 points are
 % observed in both eyes of both images
 
 %% Part 2_2 The Ransac algorithm
 
 
numMatches = size(matches,2);
X1 = F1(1:2,matches(1,:)) ; X1(3,:) = 1 ;
X2 = F2(1:2,matches(2,:)) ; X2(3,:) = 1 ;

for t = 1:100
  % estimate homograpyh
  subset = vl_colsubset(1:numMatches, 4) ;
  A = [] ;
  for i = subset
    A = cat(1, A, kron(X1(:,i)', vl_hat(X2(:,i)))) ;
  end
  [U,S,V] = svd(A) ;
  H{t} = reshape(V(:,9),3,3) ;

  % score homography
  X2_ = H{t} * X1 ;
  du = X2_(1,:)./X2_(3,:) - X2(1,:)./X2(3,:) ;
  dv = X2_(2,:)./X2_(3,:) - X2(2,:)./X2(3,:) ;
  ok{t} = (du.*du + dv.*dv) < 6*6 ;
  score(t) = sum(ok{t}) ;
end

[score, best] = max(score) ;
H = H{best} ;
ok = ok{best} ;
 
%show matches
dh1 = max(size(I_2,1)-size(I_1,1),0) ;
dh2 = max(size(I_1,1)-size(I_2,1),0) ;


figure ; clf ;
subplot(2,1,1) ;
imagesc([padarray(I_1,dh1,'post') padarray(I_2,dh2,'post')]) ;
o = size(I_1,2) ;
line([F1(1,matches(1,:));F2(1,matches(2,:))+o], ...
     [F1(2,matches(1,:));F2(2,matches(2,:))]) ;
title(sprintf('%d tentative matches', numMatches)) ;
axis image off ;

subplot(2,1,2) ;
imagesc([padarray(I_1,dh1,'post') padarray(I_2,dh2,'post')]) ;
o = size(I_1,2) ;
line([F1(1,matches(1,ok));F2(1,matches(2,ok))+o], ...
     [F1(2,matches(1,ok));F2(2,matches(2,ok))]) ;
title(sprintf('%d (%.2f%%) inliner matches out of %d', ...
              sum(ok), ...
              100*sum(ok)/numMatches, ...
              numMatches)) ;
axis image off ;
% The homography model isn't really effective for large angles: The
% matching is better whent there is a smaller rotation between the 2 images
% being matched. The alternative method is: 
 
 %% Part 2_2 The Ransac algorithm: testing larger angles
 
%  Loading another sample image to test for homolograph basing on angles
%  I_3 = imread('model_050.png');
%  I_gray3 = single(rgb2gray(I_3));
%  [F2, D2] = vl_sift(I_gray3);
%  
%  numMatches = size(matches,2);
% X1 = F1(1:2,matches(1,:)) ; X1(3,:) = 1 ;
% X2 = F2(1:2,matches(2,:)) ; X2(3,:) = 1 ;
% 
% for t = 1:100
%   % estimate homograpyh
%   subset = vl_colsubset(1:numMatches, 4) ;
%   A = [] ;
%   for i = subset
%     A = cat(1, A, kron(X1(:,i)', vl_hat(X2(:,i)))) ;
%   end
%   [U,S,V] = svd(A) ;
%   H{t} = reshape(V(:,9),3,3) ;
% 
%   % score homography
%   X2_ = H{t} * X1 ;
%   du = X2_(1,:)./X2_(3,:) - X2(1,:)./X2(3,:) ;
%   dv = X2_(2,:)./X2_(3,:) - X2(2,:)./X2(3,:) ;
%   ok{t} = (du.*du + dv.*dv) < 6*6 ;
%   score(t) = sum(ok{t}) ;
% end
% 
% [score, best] = max(score) ;
% H = H{best} ;
% ok = ok{best} ;
%  
% %show matches
% dh1 = max(size(I_2,1)-size(I_1,1),0) ;
% dh2 = max(size(I_1,1)-size(I_2,1),0) ;
% 
% 
% figure(5); clf ;
% subplot(2,1,1) ;
% imagesc([padarray(I_1,dh1,'post') padarray(I_2,dh2,'post')]) ;
% o = size(I_1,2) ;
% line([F1(1,matches(1,:));F2(1,matches(2,:))+o], ...
%      [F1(2,matches(1,:));F2(2,matches(2,:))]) ;
% title(sprintf('%d tentative matches', numMatches)) ;
% axis image off ;
% 
% subplot(2,1,2) ;
% imagesc([padarray(I_1,dh1,'post') padarray(I_2,dh2,'post')]) ;
% o = size(I_1,2) ;
% line([F1(1,matches(1,ok));F2(1,matches(2,ok))+o], ...
%      [F1(2,matches(1,ok));F2(2,matches(2,ok))]) ;
% title(sprintf('%d (%.2f%%) inliner matches out of %d', ...
%               sum(ok), ...
%               100*sum(ok)/numMatches, ...
%               numMatches)) ;
% axis image off ;


%% Part 3_1 Computation of the fundamental matrix

mat1 = ones( 1, size(matches,2));
pt_1 = [F1( 1:2, matches(1,:)); mat1];
pt_2 = [F2( 1:2, matches(2,:)); mat1 ];
%the Fundamental matrix
Fundamental_max = det_F_normalized_8point(pt_1,pt_2);

Fundamental_max

%Drawing the epipolar lines in first image

point_set = F1( 1:2, matches(1,:));
epiLines = epipolarLine(Fundamental_max', point_set');
%Compute the intersection points of the lines and the image border.
points = lineToBorderPoints(epiLines,size(I_1));

%plotting points on image
figure; 
imshow (I_1);
title('Epipolar lines on the first image')
hold on;
line(points(:,[1,3])',points(:,[2,4])');


%% Part 3_2 Computation of the essential matrix

Essential_mat = K_mat' * Fundamental_max * K_mat;

Essential_mat





