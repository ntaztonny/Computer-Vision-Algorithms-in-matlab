%% NOM? : Lab Pixel Super-resolution

clear;close all;clc
I=double(imread('barbara.png')); 
figure('Name','I');imshow(I,[],'InitialMagnification','fit');colorbar;axis on;title('I');
f=4; % should be even % f stands for ????
aff=1; % boolean for display

%% Simulation of a stack of images
Nim=10; % Nim is ???
I1=zeros(size(I,1),size(I,2),Nim);
I2=zeros(round(size(I,1)/f),round(size(I,2)/f),Nim);
txty=f*rand(2,Nim)-(f/2); %% txty is ???
txty(:,1)=[0,0];
if aff==1 ,figure('Name','pile d''images'),end
for c=1:Nim
    xform = [ 1  0  0;        0  1  0;   txty(1,c) txty(2,c)  1 ]; %??
    tform_translate = maketform('affine',xform); %??
    I1(:,:,c)= imtransform(I, tform_translate,'XData',[1 size(I,2)],'YData',[1 size(I,1)],'FillValues',mean(I(:)));%??
    I2(:,:,c)=I1(1:f:end,1:f:end,c);%??
    if aff==1,    imshow(I2(:,:,c),[],'InitialMagnification','fit');colorbar;axis on;title(sprintf('image n° %d',c));pause(0.1),end
end
