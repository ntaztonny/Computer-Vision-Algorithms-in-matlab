function Filtered_Img = Filter( FT_Image, radius )

%     shapeInserter = vision.ShapeInserter('Shape','Circles', 'Fill', true, ...
%                    'FillColor', 'Custom', 'CustomFillColor',  uint8(1));
               
    Mask_r = zeros(size( FT_Image ));
    % Getting center point
    C1_x = size( FT_Image, 2 ) / 2; 
    C1_y = size( FT_Image, 1 ) / 2; 

    % Masking right point Circle
    % Finding the next maximum along the center point towards left
    temp = abs(FT_Image);
    [max_value, Index ] = max(temp( C1_y, C1_x + 1: size( FT_Image, 2)));
    C2_x = C1_x + 1+ Index; 
    C2_y = C1_y; 

    % Drawing circles on mask
    %circles = int32([C2_x C2_y radius]);
    %Mask_r = step( shapeInserter, Mask_r, circles);
    [rr cc] = meshgrid(1:1024);
    Mask_r = sqrt((rr-C2_x).^2+(cc-C2_y).^2)<=radius;
    imshow(Mask_r);

    %Applying mask
    Filtered_Img = FT_Image .* double(Mask_r);
    figure;imshow(Filtered_Img, []); title ('mask');
end

