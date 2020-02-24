%%  Ntambaazi Tonny, CIMET: Phase difference  Report Lab 1


% This file uses two other functions that are contained in the folder
% provided
% Please check the filter function which was used for applying masks to the
% to the respective images 
% The other useful file in this lab is the "unw_modifed.m" file used for
% unwrapping the phase

%%
clear all; close all; clc;

Reference = imread('Reference.tif');
Object    = imread('Object.tif');
radius = 20;

%% Reference image
Ref_FT = fft2(Reference);
Ref_FT = fftshift(Ref_FT);
imagesc(log(abs(Ref_FT)));

% Applying mask to the image using the filter function
Filt_Ref = Filter(Ref_FT, radius );
figure; imagesc(log(abs(Filt_Ref))); title('Reference filtered image');

Ref_mask = ifft2(Filt_Ref);
figure; imshow(Ref_mask); title('Reference IFT');

Ref_phase = angle(Ref_mask);

figure; imshow(Ref_phase); title('Reference phase');

%% Oject image

Obj_FT = fft2(Object);
Obj_FT = fftshift(Obj_FT);
imagesc(log(abs(Obj_FT)));

% Applying mask to the image using the filter function
Filt_Object = Filter(Obj_FT, radius );
figure; imagesc(log(abs(Filt_Object))); title ('Object filtered Image');

% Applying the inverse Fourir transform
Obj_mask = ifft2(Filt_Object);
figure; imshow(Obj_mask); title ('Object IFF');

Obj_phase = angle (Obj_mask);
figure; imshow(Obj_phase); title('object phase');

%% Phase difference

phase = Obj_phase - Ref_phase;
phase_value = phase < 0;
Real_phase_value = phase + (phase_value .* (2*3.14));

figure; imagesc(Real_phase_value); title('wrapped phase difference');

% Unwrapping the phase and diplaying the final result
unwrap_Gold2_1_modified
figure;
imagesc(unphase)
title('Continuous phase distribution');
colormap(gray)






