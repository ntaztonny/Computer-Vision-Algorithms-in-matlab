%% Exercise 4 report, title "image super resolution", Ntambaazi Tonny_CIMET : ...,

clear;clc
Ipng=(imread('imaget.jpg'));
imwrite(Ipng, 'imaget.png');
I=(imread('imaget.png'));
I = rgb2gray(I);

imshow(I);

Ib =double(imread('barbara.png'));
figure('Name','I');imshow(I,[],'InitialMagnification','fit');colorbar;axis on;title('I'); title('Original image');
f=4; % should be even % f stands for down sampling factor tht will be used for ceating down resolved images
aff=1; % boolean for display



%% Part 1.1 Simulation of a stack of images
Nim=50; 
% Nim is the number of images that are interpolated to form
% the super resolved images: These are used to create a stack containing 50
% images

%Initializing matrices I1 & I2 for creating the image stack...
I1=zeros(size(I,1),size(I,2),Nim);
I2=zeros(round(size(I,1)/f),round(size(I,2)/f),Nim);

txty=f*rand(2,Nim)-(f/2);
txty(:,1)=[0,0];
if aff==1 ,figure('Name','pile d''images'),end

% Creating a stack of low resolved images

for c=1:Nim
    xform = [ 1  0  0;        0  1  0;   txty(1,c) txty(2,c)  1 ]; %??
    tform_translate = maketform('affine',xform); %??
    I1(:,:,c)= imtransform(I, tform_translate,'XData',[1 size(I,2)],'YData',[1 size(I,1)],'FillValues',mean(I(:)));%??
    I2(:,:,c)=I1(1:f:end,1:f:end,c);%??
    if aff==1,    imshow(I2(:,:,c),[],'InitialMagnification','fit');colorbar;axis on;title(sprintf('image n° %d',c));pause(0.1),end
                  title('Stack of the low resolved images');
%     figure; imshow(I2(:,:,c));
end

% There are artifacts in the pants and scarf on the down sampled image because 
% the stripes in the original image appear as uneven overlap of the pixels creating 
% a more of the metaphorical paint in some places than others which causes
% hence showing artifacts in the down sampled image compared to the
% original image.

 

%% Part 2.1 Pixel super-resolution of the image stack

% 
[X,Y]=meshgrid(1:f:size(I,2),1:f:size(I,1));
[Xi,Yi]=meshgrid(1:size(I,2),1:size(I,1));
Xt=zeros(size(X,1),size(X,2)*Nim);Yt=Xt;datat=Xt;

% Interpolating 10 low resolved to create a super resolved image
for c=1:10 % NimSR is the number of images considered to calculate
% the SR image
Xt(:,(size(X,2)*(c-1)+1):(size(X,2)*(c)))=X-txty(1,c);
Yt(:,(size(Y,2)*(c-1)+1):(size(Y,2)*(c)))=Y-txty(2,c);
datat(:,(size(Y,2)*(c-1)+1):(size(Y,2)*(c)))=I2(:,:,c);
end

% Building the super resolved image
ISR = griddata(Xt,Yt,datat,Xi,Yi,'cubic');

[x_i,y_i] = size(ISR);
figure; imshow(ISR,[],'InitialMagnification','fit');colorbar;axis on;title('');pause(0.1); title('SRI of a 10 stack images');

%% Computing the super resolution with 50 images

% 
[X,Y]=meshgrid(1:f:size(I,2),1:f:size(I,1));
[Xi_50,Yi_50]=meshgrid(1:size(I,2),1:size(I,1));
Xt=zeros(size(X,1),size(X,2)*Nim);Yt=Xt;datat=Xt;

% Interpolating 30 low resolved to create a super resolved image
for c=1:50 % NimSR is the number of images considered to calculate
% the SR image
Xt(:,(size(X,2)*(c-1)+1):(size(X,2)*(c)))=X-txty(1,c);
Yt(:,(size(Y,2)*(c-1)+1):(size(Y,2)*(c)))=Y-txty(2,c);
datat(:,(size(Y,2)*(c-1)+1):(size(Y,2)*(c)))=I2(:,:,c);
end

% Building the super resolved image
ISR_50 = griddata(Xt,Yt,datat,Xi_50,Yi_50,'cubic');

[x_i_50,y_i_50] = size(ISR);
figure; imshow(ISR_50,[],'InitialMagnification','fit');colorbar;axis on;title('');pause(0.1); title('SRI of a stack of 50 images');

%% Part 2.2
% Comments:
% Here, the increase in the number of the low resolved images used in creation
% of the super resolves increases the overall appearance of the image: This
% is observed as an image stack of 10 was used followed by a 50 image
% stack: The 50 image stack shows less artifacts around the pants as well
% as the scarf. There are also better details of the shadows on the super
% resolved image created from 50 image stack compared to that of 10 image
% stack. This is because the more lower resolved images used; the more is
% the proper interpolation of pixels preventing uneven overlap of the
% pixels hence decreasing the error of correlation
% 





%% Part 2.3 Calculating the  mean squares:


% Displaying the mean square evolution
NimSR = 50;
X_plot = zeros(NimSR,2);

hold on;
for c=10:10:NimSR % NimSR is the number of images considered to calculate
% the SR image
Xt(:,(size(X,2)*(c-1)+1):(size(X,2)*(c)))=X-txty(1,c);
Yt(:,(size(Y,2)*(c-1)+1):(size(Y,2)*(c)))=Y-txty(2,c);
datat(:,(size(Y,2)*(c-1)+1):(size(Y,2)*(c)))=I2(:,:,c);
    ISR = griddata(Xt,Yt,datat,Xi,Yi,'cubic');
    I_h = I(1:(x_i-3),1:(y_i-3));
    ISR = ISR(1:(x_i-3),1:(y_i-3));
   


end
Meansquare =  sqrt (mean(mean((I_h-ISR).^2)));
Meansquare
%% Part 3 Influence of the noise on pixel super-resolution

clear all; 

I=double(imread('barbara.png'));
f=4; % should be even % f stands for ????
aff=1; % boolean for display


Nim=10; 
% Nim is the number of images that are interpolated to form
% the super resolved images: These are used to create a stack containing 50
% images

%Initializing matrices I1 & I2 for creating the image stack...
I1=zeros(size(I,1),size(I,2),Nim);
I2=zeros(round(size(I,1)/f),round(size(I,2)/f),Nim);

txty=f*rand(2,Nim)-(f/2);
txty(:,1)=[0,0];
if aff==1 ,figure('Name','pile d''images'),end

% Creating a stack of low resolved images

for c=1:Nim
    xform = [ 1  0  0;        0  1  0;   txty(1,c) txty(2,c)  1 ]; %??
    tform_translate = maketform('affine',xform); 
    I1(:,:,c)= imtransform(I, tform_translate,'XData',[1 size(I,2)],'YData',[1 size(I,1)],'FillValues',mean(I(:)));
    I2(:,:,c)= I1(1:f:end,1:f:end,c);
    % adding noise to the image

    I2(:,:,c) = imnoise (I2(:,:,c)/255, 'gaussian', 0.2);
    if aff==1,    
        imshow(I2(:,:,c),[],'InitialMagnification','fit');colorbar;axis on;title(sprintf('image n° %d',c));pause(0.1),end
        title('Stack of the low resolved images with noise');
%     figure; imshow(I2(:,:,c));
end


% super-resolution of the image stack

% 
[X,Y]=meshgrid(1:f:size(I,2),1:f:size(I,1));
[Xi,Yi]=meshgrid(1:size(I,2),1:size(I,1));
Xt=zeros(size(X,1),size(X,2)*Nim);Yt=Xt;datat=Xt;

% Interpolating 10 low resolved to create a super resolved image
for c=1:10 % NimSR is the number of images considered to calculate
% the SR image
Xt(:,(size(X,2)*(c-1)+1):(size(X,2)*(c)))=X-txty(1,c);
Yt(:,(size(Y,2)*(c-1)+1):(size(Y,2)*(c)))=Y-txty(2,c);
datat(:,(size(Y,2)*(c-1)+1):(size(Y,2)*(c)))=I2(:,:,c);
end

% Building the super resolved image
ISR = griddata(Xt,Yt,datat,Xi,Yi,'cubic');

[x_i,y_i] = size(ISR);
figure; imshow(ISR,[],'InitialMagnification','fit');colorbar;axis on;title('');pause(0.1); title('SRI of a 10 stack images with noise');

%  Adding noise to the images cause a drop in the performance especially as
%  the noise level increases.However increase in the noise causes a
%  reduction in the super resolution of the resultng image
%  The resulting calculated super resolved image however
%  improves the image and shows better result with reduced noise compared
%  to the original image stack.... 

%% Part 4 Pixel super-resolution of the image stack assuming that shiftsare not known accurately estimated

clear all; 

I=double(imread('barbara.png'));
f=4; % should be even % f stands down sampling factor
aff=1; % boolean for display
alpha = 20;

Nim=10; 
% Nim is the number of images that are interpolated to form
% the super resolved images: These are used to create a stack containing 50
% images

%Initializing matrices I1 & I2 for creating the image stack...
I1=zeros(size(I,1),size(I,2),Nim);
I2=zeros(round(size(I,1)/f),round(size(I,2)/f),Nim);

txty= f*rand(2,Nim)-(f/2);
txty(:,1)=[0,0];

% Shifting the txty values, ie adding noise to this in the stack
txty = txty + alpha*randn(size(txty));
if aff==1 ,figure('Name','pile d''images'),end

% Creating a stack of low resolved images

for c=1:Nim
    xform = [ 1  0  0;        0  1  0;   txty(1,c) txty(2,c)  1 ]; %??
    tform_translate = maketform('affine',xform); 
    I1(:,:,c)= imtransform(I, tform_translate,'XData',[1 size(I,2)],'YData',[1 size(I,1)],'FillValues',mean(I(:)));
    I2(:,:,c)= I1(1:f:end,1:f:end,c);
     
    if aff==1,    
        imshow(I2(:,:,c),[],'InitialMagnification','fit');colorbar;axis on;title(sprintf('image n° %d',c));pause(0.1),end
        title('Stack of the low resolved images with x-y-shift');
%     figure; imshow(I2(:,:,c));
end


% super-resolution of the image stack

% 
[X,Y]=meshgrid(1:f:size(I,2),1:f:size(I,1));
[Xi,Yi]=meshgrid(1:size(I,2),1:size(I,1));
Xt=zeros(size(X,1),size(X,2)*Nim);Yt=Xt;datat=Xt;

% Interpolating 10 low resolved to create a super resolved image
for c=1:10 % NimSR is the number of images considered to calculate
% the SR image
Xt(:,(size(X,2)*(c-1)+1):(size(X,2)*(c)))=X-txty(1,c);
Yt(:,(size(Y,2)*(c-1)+1):(size(Y,2)*(c)))=Y-txty(2,c);
datat(:,(size(Y,2)*(c-1)+1):(size(Y,2)*(c)))=I2(:,:,c);
end

% Building the super resolved image
ISR = griddata(Xt,Yt,datat,Xi,Yi,'cubic');

[x_i,y_i] = size(ISR);
figure; imshow(ISR,[],'InitialMagnification','fit');colorbar;axis on;title('');pause(0.1); title('SRI of a 10 stack images with x-y-shifts');

Meansquare =  sqrt (mean(mean((I-ISR).^2)));
Meansquare 

% The change of the x-y-shift matrix, causes a change on the position of
% the low undersampled images but there seems no practicle effect observed
% resulting super resolved image: while the MSE decreases gradually with
% the value of the used sigma 

