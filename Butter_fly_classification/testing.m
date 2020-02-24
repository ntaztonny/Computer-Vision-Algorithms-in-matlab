imgSet = imageSet('tests/','recursive');
[x, siz ]  = size(imgSet);
sum = 1;
%descriptors extracted from the training script
X = descriptors;
Y = especies;
%machine learning function using the descriptors from training
Mdl = fitcknn(X,Y,'NumNeighbors',10,'Standardize',1);
e = 1;
h = 1;
%read all the directories
for iterator=1:siz
 %read all the images   
 for counter=1:imgSet(iterator).Count
     %read image    
     img = read(imgSet(iterator),counter);
     %Convert Image from RGB Color Space to L*a*b* Color Space
     conversionform = makecform('srgb2lab'); 
     lab_img = applycform(img,conversionform); 
     L_Image = lab_img(:, :, 1);  % Extract the L from image
     A_Image = lab_img(:, :, 2);  % Extract the A image.
     B_Image = lab_img(:, :, 3);  % Extract the B image.
     
     %Classify color based on Kmeans using L*ab* channels
     ab = double(lab_img(:,:,:));
     nrows = size(ab,1);
     ncols = size(ab,2);
     ab = reshape(ab,nrows*ncols,3);
     nColors = 4;
    %repeat the clustering 3 times to avoid local minima
    [cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                          'Replicates',3);

                                      
    %label the image with the 4 mains colors                                  
    pixel_labels = reshape(cluster_idx,nrows,ncols);    
    %get the size of the matriz
    [y1,x1,z1] = size(pixel_labels);

    
    %initialize variables
    s1 = 0;
    c1 = 1;
    s2 = 0;

    t1 = 0;
    t2 = 0;
    t3 = 0;

    z1 = 0;
    z2 = 0;
    z3 = 0;
    
    w1 = 0;
    w2 = 0;
    w3 = 0;
    
    c2 = 1;
    c3 = 1;
    c4 = 1;
    

    rmax = 0;
    gmax = 0;
    bmax = 0;
    
    rmed = 0;
    gmed = 0;
    bmed = 0;
    
    rmin = 0;
    gmin = 0;
    bmin = 0;    
    
    
    %get the number with most appear in the image(In this case will be the background)
    max_number = mode(pixel_labels(:));
    %get the main color of the butterfly(which is the second main color of all the image)
    second_max = mode(pixel_labels(pixel_labels~=max_number));
    %get the second main color of the butterfly(which is the third main color of all the image)    
    third_max = mode(pixel_labels(pixel_labels~=max_number & pixel_labels~=second_max));
    %get the the minimum color of the butterfly(which is also the less frequent color label of the image)
    minmode = mode(pixel_labels(pixel_labels~=max_number & pixel_labels~=second_max & pixel_labels~=third_max));    


    %get the matrix for each channel with the true colors using the segmented matrix as a base
    for i=1:y1
        for j=1:x1
            %background
            if pixel_labels(i,j) == max_number   
                s1(c1) = A_Image(i,j);
                s2(c1) = B_Image(i,j);
                c1 = c1 + 1;
            end
            %main butterfly color
            if pixel_labels(i,j) == second_max   
                t1(c2) = A_Image(i,j);
                t2(c2) = B_Image(i,j);
                t3(c2) = L_Image(i,j);
                rmax = img(i,j,1);
                gmax = img(i,j,2);
                bmax = img(i,j,3);                  
                c2 = c2 + 1;
            end
            %second main butterfly color
            if pixel_labels(i,j) == third_max   
                z1(c3) = A_Image(i,j);
                z2(c3) = B_Image(i,j);
                z3(c3) = L_Image(i,j);
                rmed = img(i,j,1);
                gmed = img(i,j,2);
                bmed = img(i,j,3);                  
                c3 = c3 + 1;
            end

            %minimum color
            if pixel_labels(i,j) == minmode   
                w1(c4) = A_Image(i,j);
                w2(c4) = B_Image(i,j);
                w3(c4) = L_Image(i,j);
                rmin = img(i,j,1);
                gmin = img(i,j,2);
                bmin = img(i,j,3);                    
                c4 = c4 + 1;
            end
        end
    end


  
    %test descriptors
    test_descriptors(sum,:) = [ mean(t1) std(t1) mean(t2) std(t2) mean(t3) std(t3)   mean(z1) std(z1) mean(z2) std(z2) mean(z3) std(z3)     mean(w1) std(w1) mean(w2) std(w2) mean(w3) std(w3)  ];
    %test especies
    test_especies(sum, 1) = [iterator]
    
    %descriptor which is going to be tested using the machine learning
    %algorithm
    buterfly = [mean(t1) std(t1) mean(t2) std(t2) mean(t3) std(t3)        mean(z1) std(z1) mean(z2) std(z2) mean(z3) std(z3)     mean(w1) std(w1) mean(w2) std(w2) mean(w3) std(w3)  ];
    %predict what is the class of the butterfly
    butClass = predict(Mdl,buterfly)
    %if butterfly is different from what it should be, it is a miss
    if butClass ~= iterator
        error(e, :) = [ iterator butClass counter]
        e = e + 1
    end
     %if butterfly is equal from what it should be, it is a hit
    if butClass == iterator
        hit(h, :) = [iterator butClass ]
        h = h + 1
    end      
    
    sum=sum+1;
  end
end 