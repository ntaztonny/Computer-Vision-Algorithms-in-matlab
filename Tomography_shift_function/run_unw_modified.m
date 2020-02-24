[fn, pn]=uigetfile('*.tif','Load wrapped phase image');
namef=[pn,fn];

phase=imread(namef);
phase=double(phase)*2*pi/255;
unwrap_Gold2_1_modified
figure(20);
imagesc(unphase)
title('Continuous phase distribution');
colormap(gray)