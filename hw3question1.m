Image = imread('jokerimage.png') ;
Initial_Red = Image(:,:,1) ; % Initial Matrices
Initial_Green = Image(:,:,2) ;
Initial_Blue = Image(:,:,3) ;

Padded_Initial_Red = zeros(516);%initializing padded matrices
Padded_Initial_Blue = zeros(516);
Padded_Initial_Green = zeros(516);
Padded_Initial_Red(3:514,3:514) = Initial_Red; %added 2 rows and columns of zeros
Padded_Initial_Blue(3:514,3:514) = Initial_Blue;
Padded_Initial_Green(3:514,3:514) = Initial_Green;



%part A
%horizantally and vertically flipped kernel matrix is equal to itself,
%therefore there is no need to flip
Blur_Gaussian_Kernel = [1 / 256, 4  / 256,  6 / 256,  4 / 256, 1 / 256;
    4 / 256, 16 / 256, 24 / 256, 16 / 256, 4 / 256;
    6 / 256, 24 / 256, 36 / 256, 24 / 256, 6 / 256;
    4 / 256, 16 / 256, 24 / 256, 16 / 256, 4 / 256;
    1 / 256, 4  / 256,  6 / 256,  4 / 256, 1 / 256];
Blurred_Green = zeros(512);%initializing blurred image matrices
Blurred_Red = zeros(512);
Blurred_Blue = zeros(512);
for i = 3:514  %slide kernel matrix over image matrices
    for j = 3:514
        Blurred_Green(i-2,j-2) = weightedSum(Blur_Gaussian_Kernel, Padded_Initial_Green(i-2:i+2,j-2:j+2),5)/250;
        Blurred_Blue(i-2,j-2) = weightedSum(Blur_Gaussian_Kernel, Padded_Initial_Blue(i-2:i+2,j-2:j+2),5)/250;
        Blurred_Red(i-2,j-2) = weightedSum(Blur_Gaussian_Kernel, Padded_Initial_Red(i-2:i+2,j-2:j+2),5)/250;
    end
end
Blurred(:,:,1) = Blurred_Red;
Blurred(:,:,2) = Blurred_Green;
Blurred(:,:,3) = Blurred_Blue;
imwrite(Blurred,'Blurred.png','png');



%part B
%horizantally and vertically flipped kernel matrix is equal to itself,
%therefore there is no need to flip
Sharpener_Kernel = [0, -0.5, 0; -0.5, 3, -0.5; 0, -0.5, 0];

Padded_Blurred_Red = zeros(516);
Padded_Blurred_Blue = zeros(516);
Padded_Blurred_Green = zeros(516);
Padded_Blurred_Red(3:514,3:514) = Blurred_Red; %added 2 rows and columns of zeros
Padded_Blurred_Blue(3:514,3:514) = Blurred_Blue;
Padded_Blurred_Green(3:514,3:514) = Blurred_Green;

Sharpened_Green = zeros(512);
Sharpened_Red = zeros(512);
Sharpened_Blue = zeros(512);
for i = 3:514
    for j = 3:514
        Sharpened_Red(i-2,j-2) = weightedSum(Sharpener_Kernel, Padded_Blurred_Red(i-1:i+1,j-1:j+1),3);
        Sharpened_Green(i-2,j-2) = weightedSum(Sharpener_Kernel, Padded_Blurred_Green(i-1:i+1,j-1:j+1),3);
        Sharpened_Blue(i-2,j-2) = weightedSum(Sharpener_Kernel, Padded_Blurred_Blue(i-1:i+1,j-1:j+1),3);
    end
end

Sharpened(:,:,1)=Sharpened_Red;
Sharpened(:,:,2)=Sharpened_Green;
Sharpened(:,:,3)=Sharpened_Blue;
imwrite(Sharpened,'Sharpened.png','png');





%part C
Edge_Kernel = [-1,-1,0; -1,0,1; 0,1,1];
Edged_Green = zeros(512);
Edged_Red = zeros(512);
Edged_Blue = zeros(512);
for i = 3:514
    for j = 3:514
        Edged_Green(i-2,j-2)  = weightedSum(Edge_Kernel, Padded_Initial_Green(i-1:i+1,j-1:j+1),3)/100;
        Edged_Blue(i-2,j-2)  = weightedSum(Edge_Kernel, Padded_Initial_Blue(i-1:i+1,j-1:j+1),3)/100;
        Edged_Red(i-2,j-2)  = weightedSum(Edge_Kernel, Padded_Initial_Red(i-1:i+1,j-1:j+1),3)/100;
    end
end
Edged(512,512,3) = zeros;
Edged(:,:,1) = Edged_Red;
Edged(:,:,2) = Edged_Green;
Edged(:,:,3) = Edged_Blue;
imwrite(Edged,'Edged.png','png');



%part D
Emboss_Kernel = [ -2, -1,  0; -1,  1,  1; 0,  1,  2];
Embossed_Green = zeros(512);
Embossed_Red = zeros(512);
Embossed_Blue = zeros(512);
for i = 3:514
    for j = 3:514
        Embossed_Green(i-2,j-2)  = weightedSum(Emboss_Kernel, Padded_Initial_Green(i-1:i+1,j-1:j+1),3)/300;
        Embossed_Blue(i-2,j-2)  = weightedSum(Emboss_Kernel, Padded_Initial_Blue(i-1:i+1,j-1:j+1),3)/300;
        Embossed_Red(i-2,j-2)  = weightedSum(Emboss_Kernel, Padded_Initial_Red(i-1:i+1,j-1:j+1),3)/300;
    end
end
Embossed(512,512,3) = zeros;
Embossed(:,:,1) = Embossed_Red;
Embossed(:,:,2) = Embossed_Green;
Embossed(:,:,3) = Embossed_Blue;
imwrite(Embossed,'Embossed.png','png');





% a function to convolute two n by n matrices 
function k = weightedSum(x,y,n)
k = 0;
for i = 1:n
    for j = 1:n
        k = k+ x(i,j)*y(i,j);
    end
end
end