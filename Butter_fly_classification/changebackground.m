clc;close all;clear all;
%%read all images

imagefile = dir('/Users/zhaolingcong/Documents/MATLAB/matlab/project/leedsbutterfly/output_seg/*.jpg');
                
for j=1:length(imagefile)
    currentfilename = strcat('/Users/zhaolingcong/Documents/MATLAB/matlab/project/leedsbutterfly/output_seg/',imagefile(j).name);
    currentimg = imread(currentfilename);
    images{j} = currentimg;
end
%% get all mask images
maskfile = dir('/Users/zhaolingcong/Documents/MATLAB/matlab/project/leedsbutterfly/segmentations/*.png');
                
for j=1:length(maskfile)
    currentname = strcat('/Users/zhaolingcong/Documents/MATLAB/matlab/project/leedsbutterfly/segmentations/',maskfile(j).name);
    currentmask = imread(currentname);
    masks{j} = currentmask;
end
%% change all the mask images to blue background
len = length(maskfile);

masksize = zeros(length(maskfile),2);

for n=1:len
    [masksize(n,1),masksize(n,2)] = size(masks{n});
end
 
for m= 1:len
    for a = 1:masksize(m,1)
         for b = 1:masksize(m,2)
             if masks{m}(a,b)== 0;
                masks{m}(a,b)=255;
                Izeros{m}(a,b)=0;
             end
       
         end
    end
             mask2{m} = cat(3,Izeros{m},Izeros{m},masks{m});
             bluebg_r{m} = mask2{m}(:,:,1)+images{m}(:,:,1);
             bluebg_g{m} = mask2{m}(:,:,2)+images{m}(:,:,2)
             bluebg_b{m} = mask2{m}(:,:,3)+images{m}(:,:,3)
             newimg{m}= cat(3,bluebg_r{m},bluebg_g{m},bluebg_b{m});
             
    imwrite(newimg{m},imagefile (m).name);  
             
end